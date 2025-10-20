output "info_targets" {
  value = {
      name   = yandex_compute_instance.targets.name
      id     = yandex_compute_instance.targets.id
      fqdn   = yandex_compute_instance.targets.fqdn
      ip_nat = yandex_compute_instance.targets.network_interface.0.nat_ip_address
      ip     = yandex_compute_instance.targets.network_interface.0.ip_address
  }
  description = "info"
}

output "info_initiators" {
  value = [
    for i in yandex_compute_instance.initiators :
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
