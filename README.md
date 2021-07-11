# cmltaWt0_infra
cmltaWt0 Infra repository

Homework Cloud Bastion
===

Solution 1:
---

```
ssh -i ~/.ssh/appuser -J appuser@<BASTION_IP> appuser@<SOMEINTERNALHOST_IP>
```


Real example:

```
➜ ssh -i ~/.ssh/appuser -J appuser@178.154.241.2 appuser@10.128.0.9
```

Solution 2:
---

```
➜  cat ~/.ssh/config
Host *
    UseKeychain yes

Host simpleinternalhost
    User appuser
    HostName <SOMEINTERNALHOST_IP>
    ProxyJump bastion

Host bastion
    User appuser
    HostName <BASTION_IP>

➜ ssh simpleinternalhost
```


Real example:
```
➜  cat ~/.ssh/config
Host *
    UseKeychain yes

Host simpleinternalhost
    User appuser
    HostName 10.128.0.9
    ProxyJump bastion

Host bastion
    User appuser
    HostName 178.154.241.2


➜ bash -c "echo alias simpleinternalhost=\'ssh simpleinternalhost\'" >> ~/.aliases

➜ source ~/.aliases

➜ simpleinternalhost
```


## Configuration data for VPN testing

bastion_IP = 178.154.241.2

someinternalhost_IP = 10.128.0.9


## Configuration

Two VMs:

- bastion
- someinternalhost w/o External IP


Pritunl vpn server is installed on Bastion host and used to access an internal network.

Configuration file: cloud-bastion.ovpn

## Additional task

Using sslip.io and Let's Encrypt implement valid cert for Pritunl admin dashboard:

### Steps:

- install certbot
- pritunl reset-ssl-cert
- re-enter the letsencrypt domain in the pritunl gui


### Test:


```
➜  ~ host 178-154-241-2.sslip.io
178-154-241-2.sslip.io has address 178.154.241.2
178-154-241-2.sslip.io mail is handled by 0 178-154-241-2.sslip.io.
```
