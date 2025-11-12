variable "frontends_count" {
  description = "Number of frontends"
  type        = number
  default     = 2
}

variable "backends_count" {
  description = "Number of backends"
  type        = number
  default     = 2
}

variable "debian" {
  type        = string
  default     = "debian-12"
  description = "debian_name"
}

variable "centos" {
  type        = string
  default     = "centos-7"
  description = "centos_name"
}

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
  default     = "subnet"
  description = "VPC network&subnet name"
}

variable "ssh_root_key" {
  type = map(any)
  default = {
    serial-port-enable = 1
    ssh-pub            = "~/.ssh/id_rsa.pub"
    ssh-key            = "~/.ssh/id_rsa"
  }
}
