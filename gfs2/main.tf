terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

resource "yandex_vpc_network" "net_otus" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "net_otus" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.net_otus.id
  v4_cidr_blocks = var.default_cidr
}

