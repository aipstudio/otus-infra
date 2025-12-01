resource "yandex_compute_instance" "frontends" {
  name        = "frontend-${count.index + 1}"
  platform_id = "standard-v1"
  count       = var.frontends_count
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.debian.image_id
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
    ssh-keys           = "debian:${local.ssh-pub}"
  }
}
