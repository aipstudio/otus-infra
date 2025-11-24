resource "yandex_compute_instance" "mysqls" {
  name        = "mysql-${count.index + 1}"
  hostname    = "mysql-${count.index + 1}"
  platform_id = "standard-v1"
  count       = var.mysqls_count

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      name = "mysql-disk-oc-${count.index + 1}"
      image_id = data.yandex_compute_image.centos.image_id
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.mysql_disks[count.index].id
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
    ssh-keys           = "centos:${local.ssh-pub}"
  }
}

resource "yandex_compute_disk" "mysql_disks" {
  count = var.mysqls_count
  name  = "mysql-disk-${count.index + 1}"
  type  = "network-hdd"
  size  = 1
  zone  = var.default_zone
}

resource "yandex_lb_target_group" "load_balancer_mysql" {
  name = "network-load-balancer-group-mysqls"
  dynamic "target" {
    for_each = yandex_compute_instance.mysqls
      content {
        subnet_id = yandex_vpc_subnet.subnet.id
        address   = target.value.network_interface.0.ip_address
      }
    }
}

resource "yandex_lb_network_load_balancer" "lb_net_mysql" {
  name = "network-load-balancer-mysql-internal"
  type = "internal"
  deletion_protection = false
  depends_on = [yandex_resourcemanager_folder_iam_member.load_balancer_editor]

  listener {
    name        = "network-load-balancer-listener-6033"
    port        = 6033
    target_port = 6033
    protocol    = "tcp"
    internal_address_spec {
      ip_version = "ipv4"
      subnet_id = yandex_vpc_subnet.subnet.id
      address = var.net_lb_mysql
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.load_balancer_mysql.id
    healthcheck {
      name                = "mysql"
      interval            = 5
      timeout             = 2
      unhealthy_threshold = 3
      healthy_threshold   = 3
      tcp_options {
        port = 6033
      }
    }
  }
}

output "info_mysqls" {
  value = [
    for i in yandex_compute_instance.mysqls:
    {
      name   = i.name
      ip     = i.network_interface.0.ip_address
    }
  ]
  description = "info"
}

output "info_load_balancer_net_mysql" {
  value = {
    name = yandex_lb_network_load_balancer.lb_net_mysql.name
    ip = [for listener in yandex_lb_network_load_balancer.lb_net_mysql.listener : [for internal_address_spec in listener.internal_address_spec : internal_address_spec.address ]]
    port = [for listener in yandex_lb_network_load_balancer.lb_net_mysql.listener : listener.port ]
  }
}
