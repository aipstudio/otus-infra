locals {
  ssh-pub     = file(var.ssh_root_key.ssh-pub)
  ssh-key     = file(var.ssh_root_key.ssh-key)
  serial-port = var.ssh_root_key.serial-port-enable
  ssh-user    = var.ssh_user
}
