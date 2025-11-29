resource "yandex_compute_instance" "backends" {
  depends_on = [resource.local_file.metadata]
  name        = "backend-${count.index + 1}"
  hostname    = "backend-${count.index + 1}"
  platform_id = "standard-v1"
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
    user-data          = "${resource.local_file.metadata.content}"
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
