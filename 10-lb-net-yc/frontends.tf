resource "yandex_compute_instance_group" "frontends" {
  name = "frontends"
  folder_id = var.folder_id
  service_account_id = "${yandex_iam_service_account.editor_sa.id}"
  deletion_protection = false
  depends_on = [yandex_resourcemanager_folder_iam_member.compute_editor, yandex_resourcemanager_folder_iam_member.load_balancer_editor]

  instance_template {
    platform_id = "standard-v1"
    name = "frontend-{instance.index}"
    hostname = "frontend-{instance.index}"

    resources {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.centos.image_id
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      network_id  = "${yandex_vpc_network.net.id}"
      subnet_ids  = ["${yandex_vpc_subnet.subnet.id}"]
      nat         = false
    }

    metadata = {
      serial-port-enable = local.serial-port
      ssh-keys = "centos:${local.ssh-pub}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.frontends_count
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_creating = 2
    max_deleting = 0
    max_unavailable = 1
    max_expansion = 0
    startup_duration = 60
  }

  load_balancer {
    target_group_name        = "network-load-balancer-group-frontends"
    target_group_description = "Network Load Balancer"
  }
}

resource "yandex_lb_network_load_balancer" "lb_net_frontend" {
  name = "network-load-balancer-frontend"
  deletion_protection = false
  depends_on = [yandex_resourcemanager_folder_iam_member.load_balancer_editor]

  listener {
    name = "network-load-balancer-listener-80"
    port = 80
    target_port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.frontends.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/active.html"
      }
    }
  }
}

output "info_frontends" {
  value = [
    for i in yandex_compute_instance_group.frontends.instances:
    {
      name   = i.name
      ip     = i.network_interface.0.ip_address
      status = i.status
      status_message = i.status_message
    }
  ]
}

output "info_loadbalancer_net_frontend" {
  value = {
    name = yandex_lb_network_load_balancer.lb_net_frontend.name
    ip = [for listener in yandex_lb_network_load_balancer.lb_net_frontend.listener : [for external_address_spec in listener.external_address_spec : external_address_spec.address ]]
    port = [for listener in yandex_lb_network_load_balancer.lb_net_frontend.listener : listener.port ]
  }
}
