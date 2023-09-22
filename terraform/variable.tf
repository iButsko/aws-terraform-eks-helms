variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "test_deployment"
}

#variable "access_key" {
#  description = "aws access key"
#  type        = string
#  sensitive   = true
#}
#
#variable "secret_access_key" {
#  description = "secret access key"
#  type        = string
#  sensitive   = true
#}

variable "subnet_id" {
  type    = string
  default = ""

}

variable "vpc_security_group_ids" {
  type    = string
  default = ""
}

variable "private_eks_subnet" {
  type    = string
  default = ""
}

variable "private_eks_subnet2" {
  type    = string
  default = ""
}

# variable "region" {
#   description = "default region"
#   default     = "us-east-1"
# }
