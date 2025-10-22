resource "local_file" "ansible_hosts" {
  depends_on = [resource.yandex_compute_instance.lb,resource.yandex_compute_instance.frontends]
  content = templatefile("${path.module}/ansible_hosts.tftpl", {
    lb = yandex_compute_instance.lb
    frontends = yandex_compute_instance.frontends
    backends = yandex_compute_instance.backends
  })
  filename = "ansible/hosts"
}

resource "local_file" "ansible_group_vars_all" {
  depends_on = [resource.yandex_compute_instance.lb,resource.yandex_compute_instance.frontends]
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
      host        = resource.yandex_compute_instance.lb.network_interface.0.nat_ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
    }
  }
#  provisioner "local-exec" {
#    command     = "ansible-playbook -i hosts ansible/lb.yml"
#    working_dir = path.module
#    interpreter = ["bash", "-c"]
#  }
}

resource "null_resource" "ansible_provisioning_frontends" {
  depends_on = [resource.yandex_compute_instance.frontends,resource.local_file.ansible_hosts,resource.local_file.ansible_group_vars_all]
  count = 1
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "debian"
      host        = resource.yandex_compute_instance.frontends[count.index].network_interface.0.nat_ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
    }
  }
#  provisioner "local-exec" {
#    command     = "ansible-playbook -i hosts ansible/frontends.yml"
#    working_dir = path.module
#    interpreter = ["bash", "-c"]
#  }
}

resource "null_resource" "ansible_provisioning_backends" {
  depends_on = [resource.yandex_compute_instance.backends,resource.local_file.ansible_hosts,resource.local_file.ansible_group_vars_all]
  count = 1
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "debian"
      host        = resource.yandex_compute_instance.frontends[count.index].network_interface.0.nat_ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
    }
  }
#  provisioner "local-exec" {
#    command     = "ansible-playbook -i hosts ansible/frontends.yml"
#    working_dir = path.module
#    interpreter = ["bash", "-c"]
#  }
}
