resource "local_file" "hosts" {
  depends_on = [resource.yandex_compute_instance.targets,resource.yandex_compute_instance.initiators]
  content = templatefile("${path.module}/hosts.tftpl", {
    target = yandex_compute_instance.targets
    initiators = yandex_compute_instance.initiators
  })
  filename = "hosts"
}

resource "null_resource" "ansible_provisioning_targets" {
  depends_on = [resource.yandex_compute_instance.targets,resource.local_file.hosts]
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "debian"
      host        = resource.yandex_compute_instance.targets.network_interface.0.nat_ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i hosts ansible/targets.yml"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "ansible_provisioning_initiators" {
  depends_on = [resource.yandex_compute_instance.initiators,resource.local_file.hosts]
  count = 1
  provisioner "remote-exec" {
    inline = ["sleep 1"]
    connection {
      type        = "ssh"
      user        = "centos"
      host        = resource.yandex_compute_instance.initiators[count.index].network_interface.0.nat_ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -i hosts ansible/initiators.yml"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}
