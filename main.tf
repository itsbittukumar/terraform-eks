module "eks" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  vpc_id             = var.vpc_id
  subnet_ids         = var.private_subnet_ids
  security_group_ids = var.cluster_security_group_ids
}

module "node_group" {
  source = "./modules/node-group"

  cluster_name    = module.eks.cluster_name
  subnet_ids      = var.private_subnet_ids
  node_group_name = var.node_group_name
}