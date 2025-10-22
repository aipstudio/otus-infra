resource "yandex_compute_instance" "lb" {
  name        = "lb"
  platform_id = "standard-v1"
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
    subnet_id = yandex_vpc_subnet.net_otus.id
    nat       = true
  }
  metadata = {
    serial-port-enable = local.serial-port
    ssh-keys           = "debian:${local.ssh-pub}"
  }
}
