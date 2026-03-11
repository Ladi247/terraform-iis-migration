module "vpc" {

  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "security_group" {

  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id
}

/* module "windows_ec2" {

  source = "./modules/windows_ec2"

  subnet_id = module.vpc.subnet_ids[0]
  sg_id         = module.security_group.sg_id
  instance_type = var.instance_type
  key_name      = var.key_name
} */

module "alb" {

  source = "./modules/alb"

  vpc_id      = module.vpc.vpc_id
  subnet_ids   = module.vpc.subnet_ids
  

  internet_gateway = module.vpc.internet_gateway

}
/* instance_id = module.windows_ec2.instance_id */

/* module "autoscaling" {

  source = "./modules/autoscaling"

  subnet_ids        = module.vpc.subnet_ids
  sg_id             = module.security_group.sg_id
  target_group_arn  = module.alb.target_group_arn
  key_name          = "iis-migration-key"

} */

module "autoscaling" {

  source = "./modules/autoscaling"

  subnet_ids       = module.vpc.subnet_ids
  sg_id            = module.security_group.sg_id
  target_group_arn = module.alb.target_group_arn

  key_name = var.key_name

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

}