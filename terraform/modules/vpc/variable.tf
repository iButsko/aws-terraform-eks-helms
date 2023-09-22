variable "vpc_cidr_block" {
  description = "list of CIDR block"
  type        = string
  default     = "10.0.0.0/16"

}

variable "DevTest_subnetpub" {
  description = "list of CIDR block public subnet"
  type        = string
  default     = "10.0.10.0/24"

}

variable "DevTest_subnetpub_alb" {
  description = "list of CIDR block public subnet"
  type        = string
  default     = "10.0.11.0/24"

}

variable "DevTest_subnetprivate" {
  description = "list of CIDR block private subnet"
  type        = string
  default     = "10.0.20.0/24"

}

variable "devtest_eks_private" {
  description = "list of CIDR block private eks subnet"
  type        = string
  default     = "10.0.30.0/24"
}

variable "devtest_eks_private2" {
  description = "list of CIDR block private eks subnet"
  type        = string
  default     = "10.0.40.0/24"
}

variable "environment" {
  description = "name of env"
  type        = string
  default     = "DevTest"
}