{
    "app": {
        "hosts": {
            "appserver": {
                "ansible_host": "${external_ip_address_app}"
            }
        }
    },
    "db": {
        "hosts": {
            "dbserver": {
                "ansible_host": "${external_ip_address_db}"
            }
        }
    }
}
