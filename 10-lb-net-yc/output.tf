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

output "info_loadbalancer_net" {
  value = {
    name = yandex_lb_network_load_balancer.lb_net.name
    id = yandex_lb_network_load_balancer.lb_net.id
    listener = yandex_lb_network_load_balancer.lb_net.listener
  }
  description = "info"
}

output "info_frontends" {
  value = [
    for i in yandex_compute_instance_group.frontends.instances:
    {
      name   = i.name
      id     = i.instance_id
      fqdn   = i.fqdn
      ip_nat = i.network_interface.0.nat_ip_address
      ip     = i.network_interface.0.ip_address
      status = i.status
      status_message = i.status_message
    }
  ]
  description = "info"
}

output "info_backends" {
  value = [
    for i in yandex_compute_instance.backends:
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
