module "vpc" {
  source = "./modules/vpc"

}

module "bastion" {
  source                 = "./modules/bastion"
  depends_on             = [module.vpc]
  vpc_security_group_ids = module.vpc.vpc_security_group_ids
  subnet_id              = module.vpc.subnet_id
  aws_eip_bastion        = module.vpc.aws_eip_bastion
}

module "eks_cluster" {
  source              = "./modules/eks"
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.subnet_id
  private_subnet_id   = module.vpc.private_subnet_id
  private_eks_subnet  = module.vpc.private_eks_subnet
  private_eks_subnet2 = module.vpc.private_eks_subnet2
}
