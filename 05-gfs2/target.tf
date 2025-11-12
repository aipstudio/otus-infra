resource "yandex_compute_instance" "targets" {
  name        = "target"
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
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.targets_disk.*.id
      content {
        disk_id = secondary_disk.value
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

resource "yandex_compute_disk" "targets_disk" {
  count = 1
  name     = "disk-${count.index}"
  type     = "network-hdd"
  size     = 1
  zone     = "ru-central1-a"
}
