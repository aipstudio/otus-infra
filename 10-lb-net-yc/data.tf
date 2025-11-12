data "yandex_compute_image" "debian" {
  family = var.debian
}

data "yandex_compute_image" "centos" {
  family = var.centos
}
