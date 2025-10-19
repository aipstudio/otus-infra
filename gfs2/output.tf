output "info_targets" {
  value = [
    for i in yandex_compute_instance.targets :
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

#output "info_server_storage" {
#  value = {
#    name = yandex_compute_instance.storage.name
#    id   = yandex_compute_instance.storage.id
#    fqdn = yandex_compute_instance.storage.fqdn
#    ip_nat = i.network_interface.0.nat_ip_address
#    ip   = i.network_interface.0.ip_address
#  }
#}
