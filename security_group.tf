locals {
  create_security_group = var.create && var.create_security_group ? true : false
}

module "security_group" {
  source                      = "git::https://github.com/tin-nguyen71/aws-security-group.git?ref=main"
  name_security_group         = var.security_name
  security_group_rules        = var.security_group_rules
  security_group_extend_rules = var.security_group_extend_rules
  vpc_id                      = var.vpc_id
  tags                        = var.tags
  master_prefix               = var.vpc_name
  create_security_group       = local.create_security_group
  aws_region                  = data.aws_region.current.name
  assume_role                 = var.assume_role
}
