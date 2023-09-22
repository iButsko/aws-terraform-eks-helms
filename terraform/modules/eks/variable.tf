variable "subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_eks_subnet" {
  type    = string
  default = ""
}

variable "private_eks_subnet2" {
  type    = string
  default = ""
}

#variable "identity_provider_config_name" {
#  type = string
#}
#
#variable "issuer_url" {
#  type = string
#}