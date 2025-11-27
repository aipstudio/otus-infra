resource "yandex_compute_instance" "postgresqls" {
  depends_on = [resource.local_file.metadata]
  name        = "postgresql-${count.index + 1}"
  hostname    = "postgresql-${count.index + 1}"
  platform_id = "standard-v1"
  count       = var.postgresqls_count

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      name = "postgresql-disk-oc-${count.index + 1}"
      image_id = data.yandex_compute_image.centos.image_id
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.postgresql_disks[count.index].id
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = false
  }

  metadata = {
    serial-port-enable = local.serial-port
    user-data          = "${resource.local_file.metadata.content}"
  }
}

resource "yandex_compute_disk" "postgresql_disks" {
  count = var.postgresqls_count
  name  = "postgresql-disk-${count.index + 1}"
  type  = "network-hdd"
  size  = 1
  zone  = var.default_zone
}

resource "yandex_lb_target_group" "load_balancer_postgresql" {
  name = "network-load-balancer-group-postgresqls"
  dynamic "target" {
    for_each = yandex_compute_instance.postgresqls
      content {
        subnet_id = yandex_vpc_subnet.subnet.id
        address   = target.value.network_interface.0.ip_address
      }
    }
}

resource "yandex_lb_network_load_balancer" "lb_net_postgresql" {
  count = var.postgresqls_count !=0 ? 1 : 0
  name = "network-load-balancer-postgresql-internal"
  type = "internal"
  deletion_protection = false
  depends_on = [yandex_resourcemanager_folder_iam_member.load_balancer_editor]

  listener {
    name        = "network-load-balancer-listener-9999"
    port        = 9999
    target_port = 9999
    protocol    = "tcp"
    internal_address_spec {
      ip_version = "ipv4"
      subnet_id = yandex_vpc_subnet.subnet.id
      address = var.net_lb_postgresql
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.load_balancer_postgresql.id
    healthcheck {
      name                = "postgresql"
      interval            = 3
      timeout             = 1
      unhealthy_threshold = 3
      healthy_threshold   = 3
      tcp_options {
        port = 9999
      }
#      http_options {
#        port = 8008
#        path = /read-write
#      }
    }
  }
}

output "info_postgresqls" {
  value = [
    for i in yandex_compute_instance.postgresqls:
    {
      name   = i.name
      ip     = i.network_interface.0.ip_address
    }
  ]
  description = "info"
}

output "info_load_balancer_net_postgresql" {
  depends_on = [resource.yandex_lb_network_load_balancer.lb_net_postgresql]
  value = {
    ip = var.net_lb_postgresql
    port = "9999"
    #name = yandex_lb_network_load_balancer.lb_net_postgresql.name
    #ip = [for listener in yandex_lb_network_load_balancer.lb_net_postgresql.listener : [for internal_address_spec in listener.internal_address_spec : internal_address_spec.address ]]
    #port = [for listener in yandex_lb_network_load_balancer.lb_net_postgresql.listener : listener.port ]
  }
}
