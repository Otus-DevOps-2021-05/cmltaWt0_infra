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
