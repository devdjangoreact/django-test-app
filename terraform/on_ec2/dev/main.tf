## Dev
# create VPC just public 
# create security group
# create eks cluster
# create autoscaling group and load balancer
# create outpute for envaroment to jenkins for deploy to aws k8s

## Prod with best practice but more expensive
# create VPC just public and pivate witb nat gateway internet
# NAT Gateways in Public Subnets to give access to Internet from Private Subnets
# create security group
# create eks cluster
# create autoscaling group and load balancer
# create outpute for envaroment to jenkins for deploy to aws k8s


provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "remote-tf-django-test-app"    // Bucket where to SAVE Terraform State
    key    = "on_ec2/dev/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                    // Region where bycket created
  }
}

module "vpc_module" {
  source               = "../../modules/aws_network"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = []
}

module "security_group_module" {
  source = "../../modules/aws_security_group"
  env    = var.env
  vpc_id = module.vpc_module.vpc_id
}

module "ec2_module" {
  source             = "../../modules/aws_ec2"
  env                = var.env
  instance_type      = var.instance_type
  security_group_id  = module.security_group_module.security_group_id
  public_subnets     = module.vpc_module.public_subnet_ids
  count_ec2_instance = var.count_ec2_instance
}

# module "asg_elb_module" {
#   source             = "../../modules/aws_asg_elb"
#   env                = var.env
#   instance_type      = var.instance_type
#   count_ec2_instance = var.count_ec2_instance
#   security_group_id  = module.security_group_module.security_group_id
#   public_subnets     = module.vpc_module.public_subnet_ids
#   vpc_id             = module.vpc_module.vpc_id
# }

# module "aws_eks_module" {
#   source          = "../../modules/aws_eks"
#   env             = var.env
#   instance_type   = var.instance_type
#   public_subnets  = module.vpc_module.public_subnet_ids
#   private_subnets = module.vpc_module.private_subnet_ids
#   vpc_id          = module.vpc_module.vpc_id
# }

