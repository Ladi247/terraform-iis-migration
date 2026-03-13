terraform {
  backend "s3" {
    bucket         = "ladi-terraform-state-bucket-247" # created by backend bootstrap
    key            = "main/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table" # created by backend bootstrap
    encrypt        = true
  }
}

/* provider "aws" {
  region = "us-east-1"
} */

module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_ids
  internet_gateway = module.vpc.internet_gateway
}

module "autoscaling" {
  source            = "./modules/autoscaling"
  subnet_ids        = module.vpc.subnet_ids
  sg_id             = module.security_group.sg_id
  target_group_arn  = module.alb.target_group_arn
  key_name          = var.key_name
  min_size          = var.min_size
  max_size          = var.max_size
  desired_capacity  = var.desired_capacity
}