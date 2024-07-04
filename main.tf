data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] #canonical
}

module "base_vpc" {
  source = "./modules/base"
}

# https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v20.16.0/examples/eks-managed-node-group/eks-al2.tf
module "eks_al2" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "mongo-al2"
  cluster_version = "1.30"

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = module.base_vpc.vpc_id
  subnet_ids = concat(module.base_vpc.subnet_private_id, module.base_vpc.subnet_public_id)

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2_x86_64"
      instance_types = ["m6i.large"]

      min_size     = 2
      max_size     = 5
      desired_size = 2
    }
  }

  tags = {
    Name = "Mongo_EKS"
  }
}
