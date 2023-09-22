terraform {
  source = "../../../modules//bastion/"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path                             = "../vpc/"
}

inputs = {
  vpc_security_group_ids = dependency.vpc.outputs.vpc_security_group_ids
  subnet_id              = dependency.vpc.outputs.subnet_id
  aws_eip_bastion        = dependency.vpc.outputs.aws_eip_bastion

}