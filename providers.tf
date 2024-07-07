terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }
  }
  backend "s3" {
    bucket = "ue2-8517-mongoeks-da"
    key    = "eks-state.tfstate"
    region = "us-east-2"

  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      Project = "Monogo"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


