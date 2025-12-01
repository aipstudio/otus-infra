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

resource "yandex_vpc_network" "net" {
  name = var.vpc_net_name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.vpc_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = var.default_cidr
  route_table_id = yandex_vpc_route_table.egress-rt.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  folder_id      = var.folder_id
  name           = "egress-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "egress-rt" {
  folder_id      = var.folder_id
  name           = "egress-route-table"
  network_id     = yandex_vpc_network.net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id   = yandex_vpc_gateway.nat_gateway.id
  }
}
