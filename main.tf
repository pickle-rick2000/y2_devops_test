# Configure the AWS Provider
terraform {
  # required_version = ">= 1.3.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {
}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}



module "vpc" {
  # using the terraform templates for creating a vpc
  source  = "terraform-aws-modules/vpc/aws" #template source
  version = "3.18.1"

  name                 = "yad2-eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  enable_nat_gateway   = true # will allow the auto-scaling
  single_nat_gateway   = true # will allow the auto-scaling
  enable_dns_hostnames = true # will allow the auto-scaling

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared" #optional for good mesures
    "kubernetes.io/role/elb"                    = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared" #optional for good mesures
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

#Cluster neccessery resources (vpc, eks)
#Also additional resources (security groups)

module "eks" {
  # using the terraform template for creating eks cluster
  source                          = "terraform-aws-modules/eks/aws" #template source
  cluster_name                    = var.cluster_name
  cluster_version                 = "1.24" #k8s version available on aws
  version                         = "~>18.30.3" #eks module version
  cluster_endpoint_private_access = true     #alow automatic cluster join by the private endpoints 
  cluster_endpoint_public_access = true     #alow automatic cluster join by the PUBLIC endpoints 
  enable_irsa = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  #the worker groups
  eks_managed_node_groups = {
    spot = {
      name = "yad2-eks-ins"
      desired_size = 3
      min_size = 1
      max_size = 5

      labels= {
        role = "spot"
      }

      instance_type = ["t2.nano"]
      capacity_type = "SPOT"
      vpc_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
  }
  cluster_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
}



