#!/usr/bin/env python
import os
import json
import argparse


class Inventory(object):

    def __init__(self):
        self._inventory = {}
        self.read_cli_args()

        # Called with `--list`.
        if self.args.list:
            self._inventory = self.get_inventory()
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self._inventory = self.get_host()
        # If no groups or vars are present, return an empty inventory.
        else:
            self._inventory = self.empty_inventory()

        print(json.dumps(self._inventory))

    def get_inventory(self):
        with open(f"{os.path.dirname(__file__)}/tf-inventory.json") as file:
            groups = json.load(file)

        _all = {
            "all": {
                "hosts": []
            }
        }
        _meta = {
            "_meta": {
                "hostvars": {}
            }
        }
        result = {}

        for group_name in groups:
            hosts = groups[group_name]["hosts"]
            group = {
                group_name: {
                    "hosts": []
                }
            }
            for host in hosts:
                ansible_host = hosts[host]["ansible_host"]
                group[group_name]["hosts"].append(ansible_host)
                _all["all"]["hosts"].append(ansible_host)

            result.update(group)

        result.update(_meta)

        return result


    def empty_inventory(self):
        """
        Empty inventory.
        """
        return {'_meta': {'hostvars': {}}}

    def read_cli_args(self):
        """
        Read the command line args passed to the script.
        """
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action = 'store_true')
        parser.add_argument('--host', action = 'store')
        self.args = parser.parse_args()


Inventory()
