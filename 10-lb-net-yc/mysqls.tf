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


output "info_mysqls" {
  value = [
    for i in yandex_compute_instance.mysqls:
    {
      name   = i.name
      id     = i.id
      fqdn   = i.fqdn
      ip_nat = i.network_interface.0.nat_ip_address
      ip     = i.network_interface.0.ip_address
    }
  ]
  description = "info"
}
