resource "yandex_lb_target_group" "reddit-app-tg" {
  name = "reddit-app-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.app.*.network_interface.0.ip_address
    content {
      subnet_id = var.subnet_id
      address   = target.value
    }
  }

}

resource "yandex_lb_network_load_balancer" "reddit-app-lb" {
  name = "reddit-app-load-balancer"

  listener {
    name        = "reddit-app-listener"
    port        = 80
    target_port = 9292
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.reddit-app-tg.id

    healthcheck {
      name = "http"
      http_options {
        port = 9292
      }
    }
  }
}
