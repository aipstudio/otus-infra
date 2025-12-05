resource "yandex_compute_instance" "elasticsearchs" {
  depends_on = [resource.local_file.metadata]
  name        = "elasticsearch-${count.index + 1}"
  hostname    = "elasticsearch-${count.index + 1}"
  platform_id = "standard-v1"
  allow_stopping_for_update = true
  count       = var.elasticsearchs_count

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      name = "elasticsearch-disk-oc-${count.index + 1}"
      image_id = data.yandex_compute_image.debian.image_id
      size = 10
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.elasticsearch_disks[count.index].id
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

resource "yandex_compute_disk" "elasticsearch_disks" {
  count = var.elasticsearchs_count
  name  = "elasticsearch-disk-${count.index + 1}"
  type  = "network-hdd"
  size  = 1
  zone  = var.default_zone
}

output "info_elasticsearchs" {
  value = [
    for i in yandex_compute_instance.elasticsearchs:
    {
      name   = i.name
      ip     = i.network_interface.0.ip_address
    }
  ]
}
