resource "yandex_compute_instance" "storage" {
  depends_on = [resource.local_file.metadata]
  name        = "storage"
  hostname    = "storage"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      name = "storage-disk-oc"
      image_id = data.yandex_compute_image.centos.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disks.*.id
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
    user-data          = "${resource.local_file.metadata.content}"
  }
}

resource "yandex_compute_disk" "storage_disks" {
  count    = 1
  name     = "storage-disk-${count.index + 1}"
  type     = "network-hdd"
  size     = 1
  zone     = var.default_zone
}

output "info_storage" {
  value = {
      name   = yandex_compute_instance.storage.name
      ip     = yandex_compute_instance.storage.network_interface.0.ip_address
  }
  description = "info"
}
