terraform {
  source = "../../../modules//eks/"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path                             = "../vpc/"
}

inputs = {
  vpc_id              = dependency.vpc.outputs.vpc_id
  subnet_id           = dependency.vpc.outputs.subnet_id
  private_subnet_id   = dependency.vpc.outputs.private_subnet_id
  private_eks_subnet  = dependency.vpc.outputs.private_eks_subnet
  private_eks_subnet2 = dependency.vpc.outputs.private_eks_subnet2
}