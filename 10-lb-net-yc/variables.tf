variable "frontends_count" {
  description = "Number of frontends"
  type        = number
  default     = 0
}

variable "backends_count" {
  description = "Number of backends"
  type        = number
  default     = 0
}

variable "mysqls_count" {
  description = "Number of mysqls"
  type        = number
  default     = 0
}

variable "postgresqls_count" {
  description = "Number of postgresqls"
  type        = number
  default     = 0
}

variable "elasticsearchs_count" {
  description = "Number of elasticsearchs"
  type        = number
  default     = 3
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

variable "net_lb_mysql" {
  type        = string
  default     = "10.0.1.50"
}

variable "net_lb_postgresql" {
  type        = string
  default     = "10.0.1.51"
}

variable "vpc_subnet_name" {
  type        = string
  default     = "subnet"
  description = "VPC subnet name"
}

variable "vpc_net_name" {
  type        = string
  default     = "net"
  description = "VPC network name"
}

variable "ssh_root_key" {
  type = map(any)
  default = {
    serial-port-enable = 1
    ssh-pub            = "~/.ssh/id_rsa.pub"
    ssh-key            = "~/.ssh/id_rsa"
  }
}

variable "ssh_user" {
  type        = string
  default     = "ansible"
}
