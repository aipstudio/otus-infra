output "info_servers-web" {
  value = [
    for i in yandex_compute_instance.web :
    {
      name = i.name
      id   = i.id
      fqdn = i.fqdn
    }
  ]
  description = "info"
}

output "info_servers-db" {
  value = [
    for i in yandex_compute_instance.vm_for_each :
    {
      name = i.name
      id   = i.id
      fqdn = i.fqdn
      ip   = i.network_interface.0.nat_ip_address
    }
  ]
  description = "info"
}

output "info_server_storage" {
  value = {
    name = yandex_compute_instance.storage.name
    id   = yandex_compute_instance.storage.id
    fqdn = yandex_compute_instance.storage.fqdn
  }
}
