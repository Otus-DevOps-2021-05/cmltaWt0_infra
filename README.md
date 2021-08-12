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

Homework Cloud testapp
===

testapp_IP = 178.154.203.209
testapp_port = 9292

Что сделано в рамках базового домашнего задания:

- установлен и настроен YC CLI
- создан инстанс с помощью **yc**
- установлены ruby, mongodb, запущено тестовое приложение

Самостоятельная работа:

- создан скрипт установки ruby
- создан скринт установки monogdb
- создан скрипт деплоя тестового приложения

Дополнительное задание:

- создан стартап скрипт для cloud-init

Команда создания инстанса:

```
➜ yc compute instance create \
--name reddit-app \
--hostname reddit-app \
--memory=4 \
--create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
--network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
--metadata serial-port-enable=1 \
--metadata-from-file user-data=metadata.yaml
```


Homework Packer
===


Что было сделано:
- перенесены все скрипты из предыдущего ДЗ в папку `config-scripts`
- Создан `reddit-base` (packer/ubuntu16.json) образ с установленными mongod и ruby
- Параметризированы почти все переменные (packer/variables.json)
- Запущен VPC на базе этого образа
- Вручную донастроен reddit app с puma сервером
- Создан Immutable образ, на базе `reddit-base`, c устанновленным приложением reddit app (packer/immutable.json)
- Параметризированы почти все переменные (packer/variables-full.json)
- Сконфигурирован `systemd` сервис `reddit.service` для автоматического старта приложения в инстансе на баще образа r`eddit-full` (packer/files/reddit.service)
- Создан скрипт `config-scripts/create-reddit-vm.sh` для автоматического создания VPC на базе образа `reddit-full`

Deploy instructions:

```
bash config-scripts/create-reddit-vm.sh
```


YC command to create VPC:

```
yc compute instance create \
    --name reddit-app \
    --hostname reddit-app \
    --memory=2 \
    --create-boot-disk image-id=fd8a2srn01nl87m96egi,size=10GB \
    --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
    --metadata serial-port-enable=1
```

Создан VPC для проверки ДЗ:

```
➜  cmltaWt0_infra git:(packer-base) bash config-scripts/create-reddit-vm.sh
done (1m7s)
id: xxxxxxxxxxxxxxxxxx
folder_id: xxxxxxxxxxxxxxxxxx
created_at: "2021-07-15T08:33:58Z"
name: reddit-app
zone_id: ru-central1-a
platform_id: standard-v2
resources:
  memory: "2147483648"
  cores: "2"
  core_fraction: "100"
status: RUNNING
boot_disk:
  mode: READ_WRITE
  device_name: xxxxxxxxxxxxxxxxxx
  auto_delete: true
  disk_id: xxxxxxxxxxxxxxxxxx
network_interfaces:
- index: "0"
  mac_address: xxxxxxxxxxxxxxxxxx
  subnet_id: xxxxxxxxxxxxxxxxxx
  primary_v4_address:
    address: x.x.x.x
    one_to_one_nat:
      address: 178.154.240.243
      ip_version: IPV4
fqdn: reddit-app.ru-central1.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}
```

Для проверки:

```
open http://178.154.240.243:9292
```


Homework Terraform-1 (забыл закоммитить в прошлый ПР)
===

Что сделано:

- создан терраформ конфиг для создания инстанса с приложением reddit-app
- создан конфиг создания Network лоад балансера с таргет группой с фиксированным таргетом в виде нашего приложения
- добавлен reddit-app-2 инстанс дуюлированием кода, обновлена таргет группа
- удалет статический reddit-app-2, вместо него использован аргумент count=2 для ресурса vpc
- обновлена таргет группа динамическим таргетом


Проблемы добавления приложения руками:

- дублирование кода
- ручные действия (отсутствие автоматизации)
- время ожидания на ручное добавление
- описание connection секции для провижинера требует ручного указания IP для подключения
- в целом мне не нравится время на до-сборку приложения (я бы брал готовые образы reddit-full вместо reddit-base)


Homework Terraform-2
===

Что сделано:

- удален load balancer
- создана сеть и подсеть, добавлены зависимости в создании ресурсов
- созданы отдельные конфиги для packer под app и db
- разнесены терраформ ресурсы по разным файлам, для app и db использованы разные image_ids
- созданы два модуля app и db и все наработки перенесены туда
- созданы окружения stage и prod
- проверена работоспособность работы модулей в них
- обновлен скрипт установки mongodb для того чтобы запустить сервис на 0.0.0.0
- добавлен `puma-service.tmpl` для указания DATABASE_URL
- настроено сохранение стейта c использованием Yandex Cloud Object Storage
- параметризированы названия инстансов в зависимости от окружения


Заметки:
- создать bucket через WEB интерфейс с ключами доступа не удалось, потому бакет был создан через terraform:
```
resource "yandex_storage_bucket" "terraform" {
   access_key = "xxxxxxxxxxxxxxxxxxxx"
   secret_key = "xxxxxxxxxxxxxxxxxxxx"
   bucket     = "cmltawt0-infra-terraform"
 }
```
после этого стейдж был перенесен локально и руками удалена секция с бакетом
и далее бекенд был перенесен снова в Object Storage

- отсутствие возможности использовать переменные в секции `backend`, нужно только хардкодить ключи и секреты
- конфигурацию приложений нужно переносить в Ansible, так как terraform не видит изменений и не будет обновлять состояние инфраструктуры


Homework Ansible-1
===

Что сделано:
- установлен ansible==2.10.7
- создали файл inventory и inventory.yml
- определили ansible.cfg
- проверили подключение к хостам и возможность запуста произвольных команд и использование различных модулей
- написали плейбук clone.yml
- зупустили, получили в результате ]appserver: ok=2    changed=0` что означает что репозиторий уже склонирован
- удалили репозиторий и повторили запуск плейбука, результат `appserver: ok=2    changed=1` - репозиторий был склонирован
- ДЗ * -> создан скрипт для динамического инвентори


ДЗ *

- настроен terraform `local_file` ресурс для сохранения inventory для ансибл в hosts и json формате

```
# generate inventory file for Ansible
resource "local_file" "ansible_ready_to_use_inventory" {
  content = templatefile("../../ansible/tf-inventory.json.tpl",
    {
      external_ip_address_app = module.app.external_ip_address_app
      external_ip_address_db  = module.db.external_ip_address_db
    }
  )
  filename = "../../ansible/tf-inventory.json"
}

# generate inventory file for Ansible
resource "local_file" "hosts" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      external_ip_address_app = module.app.external_ip_address_app
      external_ip_address_db  = module.db.external_ip_address_db
    }
  )
  filename = "../../ansible/hosts"
}

```
- для вычитки списка хостов можно использовать либо первый либо второй вариант
- но для целей обучения создадим скрипт на питоне, который будет парсить json формат и генерировать JSON для динамического запуска

```
ansible git:(ansible-1) ✗ ansible-inventory --inventory inventory.py --graph
@all:
  |--@app:
  |  |--178.154.221.240
  |--@db:
  |  |--178.154.222.87
  |--@ungrouped:
```

Хотелось сделать коннектор для Yandex Cloud через yandexcloud библиотеку, но она не ставится на Mac OS Monterey.

Homework Ansible-2
===

Что сделано:
- проработаны несколько вариантов использования плейбуков
- изменено создание образов с помощью Packer
  - созданы packer_db и packer_app
- убран провижен из Terraform
- проверен деплой приложения с помощью плейбука site.yml
- используется dynamic inventory (с прошлого ДЗ)
- проверен флоу packer build -> terraform apply -> ansible-playbook site.yml

P.S. изменил хендлер на обновления файла /etc/mongod.conf
    - name: daemon reload
      service: daemon_reload=true
