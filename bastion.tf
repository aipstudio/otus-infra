resource "yandex_compute_instance" "bastion" {
  depends_on = [resource.local_file.metadata]
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      name = "bastion-disk-oc"
      image_id = data.yandex_compute_image.debian.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    serial-port-enable = local.serial-port
    user-data          = "${resource.local_file.metadata.content}"
  }
}

output "info_bastion" {
  value = {
    name   = yandex_compute_instance.bastion.name
    ip_nat = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    ip     = yandex_compute_instance.bastion.network_interface.0.ip_address
  }
}
