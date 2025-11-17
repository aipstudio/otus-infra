resource "local_file" "ansible_hosts_bastion" {
  depends_on = [resource.yandex_compute_instance.bastion,resource.yandex_compute_instance_group.frontends,resource.yandex_compute_instance.backends]
  content = templatefile("${path.module}/ansible_hosts_bastion.tftpl", {
    bastion = yandex_compute_instance.bastion
    storage = yandex_compute_instance.storage
    frontends = yandex_compute_instance_group.frontends
    backends = yandex_compute_instance.backends
  })
  filename = "ansible/hosts_bastion"
}

resource "local_file" "ansible_group_vars_all" {
  depends_on = [resource.yandex_compute_instance.bastion,resource.yandex_compute_instance_group.frontends,resource.yandex_compute_instance.backends]
  content = templatefile("${path.module}/ansible_group_vars_all.tftpl", {
    bastion = yandex_compute_instance.bastion
    storage = yandex_compute_instance.storage
    frontends = yandex_compute_instance_group.frontends
    backends = yandex_compute_instance.backends
  })
  filename = "ansible/group_vars/all.yml"
}

resource "null_resource" "ansible_provisioning_bastion" {
  depends_on = [resource.yandex_compute_instance.bastion,resource.local_file.ansible_hosts_bastion,resource.local_file.ansible_group_vars_all]
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "centos"
      host        = resource.yandex_compute_instance.bastion.network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i ansible/hosts_bastion ansible/bastion.yml"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_storage" {
  depends_on = [resource.yandex_compute_instance.storage,resource.local_file.ansible_hosts_bastion,resource.local_file.ansible_group_vars_all]
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "centos"
      host        = resource.yandex_compute_instance.storage.network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i ansible/hosts_bastion ansible/storage.yml"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_frontends" {
  depends_on = [resource.yandex_compute_instance_group.frontends,resource.local_file.ansible_hosts_bastion,resource.local_file.ansible_group_vars_all]
  count = var.frontends_count
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "centos"
      host        = resource.yandex_compute_instance_group.frontends.instances[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i ansible/hosts_bastion ansible/frontends.yml -e variable_hosts=${resource.yandex_compute_instance_group.frontends.instances[count.index].name}"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_backends" {
  depends_on = [resource.yandex_compute_instance.backends,resource.local_file.ansible_hosts_bastion,resource.local_file.ansible_group_vars_all]
  count = var.backends_count
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "centos"
      host        = resource.yandex_compute_instance.backends[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i ansible/hosts_bastion ansible/backends_docker.yml -e variable_hosts=${resource.yandex_compute_instance.backends[count.index].name}"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}
