resource "local_file" "hosts" {
  depends_on = [resource.yandex_compute_instance.targets,resource.yandex_compute_instance.initiators]
  content = templatefile("${path.module}/hosts.tftpl", {
    targets = yandex_compute_instance.targets
    initiators = yandex_compute_instance.initiators
  })
  filename = "hosts"
}

resource "null_resource" "ansible_provisioning_targets" {
  depends_on = [resource.yandex_compute_instance.targets]
  provisioner "remote-exec" {
    inline = ["sudo apt update -qq && sudo apt -y install htop"]
    connection {
      type        = "ssh"
      user        = "debian"
      host        = resource.yandex_compute_instance.targets[0].network_interface.0.nat_ip_address
      private_key = "${file(var.ssh_root_key.ssh-key)}"
    }
  }
  provisioner "local-exec" {
    command     = "ansible-playbook -vvv -i hosts ansible/targets.yml"
    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}

#resource "null_resource" "ansible_provisioning_initiators" {
#  depends_on = [resource.yandex_compute_instance.initiators]
#  provisioner "local-exec" {
#    command     = "ansible-playbook -vvv -i hosts ansible/initiators.yml"
#    working_dir = path.module
#    interpreter = ["bash", "-c"]
#  }
#}
