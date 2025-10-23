output "info_bastion" {
  value = {
      name   = yandex_compute_instance.bastion.name
      id     = yandex_compute_instance.bastion.id
      fqdn   = yandex_compute_instance.bastion.fqdn
      ip_nat = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
      ip     = yandex_compute_instance.bastion.network_interface.0.ip_address
  }
  description = "info"
}

output "info_lb" {
  value = {
      name   = yandex_compute_instance.lb.name
      id     = yandex_compute_instance.lb.id
      fqdn   = yandex_compute_instance.lb.fqdn
      ip_nat = yandex_compute_instance.lb.network_interface.0.nat_ip_address
      ip     = yandex_compute_instance.lb.network_interface.0.ip_address
  }
  description = "info"
}

output "info_frontends" {
  value = [
    for i in yandex_compute_instance.frontends :
    {
      name   = i.name
      id     = i.id
      fqdn   = i.fqdn
      ip_nat = i.network_interface.0.nat_ip_address
      ip     = i.network_interface.0.ip_address
    }
  ]
  description = "info"
}

output "info_backends" {
  value = [
    for i in yandex_compute_instance.backends :
    {
      name   = i.name
      id     = i.id
      fqdn   = i.fqdn
      ip_nat = i.network_interface.0.nat_ip_address
      ip     = i.network_interface.0.ip_address
    }
  ]
  description = "info"
}
