resource "yandex_compute_instance" "storage" {
  name        = "storage"
  hostname        = "storage"
  platform_id = "standard-v1"

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

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk.*.id
      content {
        disk_id = secondary_disk.value
      }
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

resource "yandex_compute_disk" "storage_disk" {
  count = 1
  name     = "disk-${count.index}"
  type     = "network-hdd"
  size     = 1
  zone     = var.default_zone
}

output "info_storage" {
  value = {
      name   = yandex_compute_instance.storage.name
      id     = yandex_compute_instance.storage.id
      fqdn   = yandex_compute_instance.storage.fqdn
      ip_nat = yandex_compute_instance.storage.network_interface.0.nat_ip_address
      ip     = yandex_compute_instance.storage.network_interface.0.ip_address
  }
  description = "info"
}
