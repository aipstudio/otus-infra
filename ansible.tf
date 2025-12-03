resource "local_file" "metadata" {
  content = templatefile("${path.module}/metadata_base.yaml.tftpl", {
    ssh-pub = local.ssh-pub
  })
  filename = "${path.module}/metadata_base.yaml"
}

resource "local_file" "ansible_hosts_bastion" {
  depends_on = [resource.yandex_compute_instance.bastion,resource.yandex_compute_instance_group.frontends,resource.yandex_compute_instance.backends]
  content = templatefile("${path.module}/ansible_hosts_bastion.tftpl", {
    bastion = yandex_compute_instance.bastion
    storage = yandex_compute_instance.storage
    frontends = yandex_compute_instance_group.frontends
    backends = yandex_compute_instance.backends
    mysqls = yandex_compute_instance.mysqls
    postgresqls = yandex_compute_instance.postgresqls
    elasticsearchs = yandex_compute_instance.elasticsearchs
    kafkas = yandex_compute_instance.kafkas
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
    mysqls = yandex_compute_instance.mysqls
    postgresqls = yandex_compute_instance.postgresqls
    elasticsearchs = yandex_compute_instance.elasticsearchs
    kafkas = yandex_compute_instance.kafkas
    var_net_lb_mysql = var.net_lb_mysql
    var_net_lb_postgresql = var.net_lb_postgresql
  })
  filename = "ansible/group_vars/all.yml"
}

resource "null_resource" "ansible_provisioning_bastion" {
  depends_on = [resource.yandex_compute_instance.bastion,resource.local_file.ansible_hosts_bastion,resource.local_file.ansible_group_vars_all]
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
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
      user        = "${var.ssh_user}"
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
      user        = "${var.ssh_user}"
      host        = resource.yandex_compute_instance_group.frontends.instances[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible/frontends.sh ${resource.yandex_compute_instance_group.frontends.instances[count.index].name}"
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
      user        = "${var.ssh_user}"
      host        = resource.yandex_compute_instance.backends[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible/backends.sh ${resource.yandex_compute_instance.backends[count.index].name}"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_mysqls" {
  depends_on = [resource.yandex_compute_instance.mysqls,resource.local_file.ansible_hosts_bastion,resource.local_file.ansible_group_vars_all]
  count = var.mysqls_count
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host        = resource.yandex_compute_instance.mysqls[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible/mysqls.sh ${resource.yandex_compute_instance.mysqls[count.index].name}"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_postgresqls" {
  depends_on = [resource.yandex_compute_instance.postgresqls,resource.local_file.ansible_hosts_bastion,resource.local_file.ansible_group_vars_all]
  count = var.postgresqls_count
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host        = resource.yandex_compute_instance.postgresqls[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible/postgresql.sh ${resource.yandex_compute_instance.postgresqls[count.index].name}"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_elasticsearchs" {
  depends_on = [resource.yandex_compute_instance.elasticsearchs,resource.local_file.ansible_hosts_bastion,resource.local_file.ansible_group_vars_all]
  count = var.elasticsearchs_count
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host        = resource.yandex_compute_instance.elasticsearchs[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible/elk.sh ${resource.yandex_compute_instance.elasticsearchs[count.index].name}"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_kafkas" {
  depends_on = [resource.yandex_compute_instance.kafkas,resource.local_file.ansible_hosts_bastion,resource.local_file.ansible_group_vars_all]
  count = var.kafkas_count
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      host        = resource.yandex_compute_instance.kafkas[count.index].network_interface.0.ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
      bastion_host = resource.yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  }
  provisioner "local-exec" {
    command     = "ansible/kafka.sh ${resource.yandex_compute_instance.kafkas[count.index].name}"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}
