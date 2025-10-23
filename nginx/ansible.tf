resource "local_file" "ansible_hosts" {
  depends_on = [resource.yandex_compute_instance.lb,resource.yandex_compute_instance.frontends,resource.yandex_compute_instance.backends]
  content = templatefile("${path.module}/ansible_hosts.tftpl", {
    lb = yandex_compute_instance.lb
    frontends = yandex_compute_instance.frontends
    backends = yandex_compute_instance.backends
  })
  filename = "ansible/hosts"
}

resource "local_file" "ansible_hosts_bastion" {
  depends_on = [resource.yandex_compute_instance.lb,resource.yandex_compute_instance.frontends,resource.yandex_compute_instance.backends]
  content = templatefile("${path.module}/ansible_hosts_bastion.tftpl", {
    lb = yandex_compute_instance.lb
    frontends = yandex_compute_instance.frontends
    backends = yandex_compute_instance.backends
  })
  filename = "ansible/hosts_bastion"
}

resource "local_file" "ansible_group_vars_all" {
  depends_on = [resource.yandex_compute_instance.lb,resource.yandex_compute_instance.frontends,resource.yandex_compute_instance.backends]
  content = templatefile("${path.module}/ansible_group_vars_all.tftpl", {
    lb = yandex_compute_instance.lb
    frontends = yandex_compute_instance.frontends
    backends = yandex_compute_instance.backends
  })
  filename = "ansible/group_vars/all.yml"
}

resource "null_resource" "ansible_provisioning_lb" {
  depends_on = [resource.yandex_compute_instance.lb,resource.local_file.ansible_hosts,resource.local_file.ansible_group_vars_all]
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "debian"
      host        = resource.yandex_compute_instance.lb.network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.lb.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i ansible/hosts_bastion ansible/lb.yml"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_frontends" {
  depends_on = [resource.yandex_compute_instance.frontends,resource.local_file.ansible_hosts,resource.local_file.ansible_group_vars_all]
  count = var.frontends_count
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "debian"
      host        = resource.yandex_compute_instance.frontends[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.lb.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i ansible/hosts_bastion ansible/frontends.yml -e variable_hosts=${resource.yandex_compute_instance.frontends[count.index].name}"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_backends" {
  depends_on = [resource.yandex_compute_instance.backends,resource.local_file.ansible_hosts,resource.local_file.ansible_group_vars_all]
  count = var.backends_count
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "debian"
      host        = resource.yandex_compute_instance.backends[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.lb.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i ansible/hosts_bastion ansible/backends.yml -e variable_hosts=${resource.yandex_compute_instance.backends[count.index].name}"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}
