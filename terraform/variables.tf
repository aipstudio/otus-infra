variable "vm_resources_list" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk          = number
    core_fraction = number
  }))
  default = [
    {
      vm_name       = "vm-1"
      cpu           = 2
      ram           = 1
      disk          = 1
      core_fraction = 5

    },
    {
      vm_name       = "vm-2"
      cpu           = 4
      ram           = 2
      disk          = 1
      core_fraction = 5
    },
  ]
  description = "There's list if dict's with VM resources"
}

variable "debian" {
  type        = string
  default     = "debian-12"
  description = "debian_name"
}

variable "ubuntu" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu_name"
}

###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "net_otus"
  description = "VPC network&subnet name"
}

variable "vms_ssh_root_key" {
  type = map(any)
  default = {
    serial-port-enable = 1
    ssh-keys           = "~/.ssh/id_rsa.pub"
  }
}
