resource "yandex_compute_instance" "backends" {
  name        = "backend-${count.index + 1}"
  hostname    = "backend-${count.index + 1}"
  platform_id = "standard-v1"
  allow_stopping_for_update = true
  count       = var.backends_count

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      name = "backend-disk-oc-${count.index + 1}"
      image_id = data.yandex_compute_image.centos.image_id
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

output "info_backends" {
  value = [
    for i in yandex_compute_instance.backends:
    {
      name   = i.name
      ip     = i.network_interface.0.ip_address
    }
  ]
}
