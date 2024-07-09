module "base_vpc" {
  source = "./modules/base"
}

module "base_eks" {
  source                  = "./modules/eks"
  cidr_eks_subnet_private = module.base_vpc.subnet_private_id
  cidr_eks_subnet_public  = module.base_vpc.subnet_public_id
  vpc_eks_id              = module.base_vpc.vpc_id
}
# resource "helm_release" "mongo" {
#   name  = "mongo"
#   chart = "./_helm/mongodb"

# }

# source: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/eks-managed-node-group/eks-al2023.tf
# module "eks_al2023" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = "da-mongoeks-al2023"
#   cluster_version = "1.30"

#   # EKS Addons
#   cluster_addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {}
#     kube-proxy             = {}
#     vpc-cni                = {}
#   }

#   vpc_id     = module.base_vpc.vpc_id
#   subnet_ids = concat(module.base_vpc.subnet_private_id, module.base_vpc.subnet_public_id)

#   eks_managed_node_groups = {
#     example = {
#       # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
#       instance_types = ["t3.large"]

#       min_size = 2
#       max_size = 5
#       # This value is ignored after the initial creation
#       # https://github.com/bryantbiggs/eks-desired-size-hack
#       desired_size = 2
#     }
#   }
# }
