################################################################################
#Endpoint Variables
################################################################################

variable "create" {
  description = "Determines whether resources will be created"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used"
  type        = string
  default     = null
}

variable "endpoints" {
  description = "A map of interface and/or gateway endpoints containing their properties and configurations"
  type        = any
  default     = {}
}

variable "security_group_ids" {
  description = "Default security group IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "Default subnets IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting VPC endpoint resources"
  type        = map(string)
  default     = {}
}

################################################################################
#Endpoint Services Variables
################################################################################
variable "endpoint_services" {
  description = "A map of endpoint services containing their properties and configurations"
  type        = any
  default     = {}
}

variable "allowed_principals" {
  description = "A list of the ARNs of principal to allow to discover a VPC endpoint service."
  type        = list(string)
  default     = []
}

variable "notification_configurations" {
  description = "A list of configurations of Endpoint Connection Notifications for VPC Endpoint events."
  type = list(object({
    sns_arn = string
    events  = list(string)
  }))
  default = []
}

################################################################################
#Security Variables
################################################################################

variable "create_security_group" {
  type        = bool
  default     = false
  description = "A boolean flag to determine whether to create Security Group."
  validation {
    condition     = contains([true, false], var.create_security_group)
    error_message = "Valid values for var: create_security_group are `true`, `false`."
  }
}

variable "security_name" {
  description = "Name of the security group."
  type        = string
  default     = "endpoint-proxy"
}

variable "security_group_rules" {
  type = any
  default = [
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
      self                     = null
    },
    {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  description = <<-EOT
    A list of maps of Security Group rules.
    The values of map is fully complated with `aws_security_group_rule` resource.
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.
      {
        type                     = "ingress"
        from_port                = 443
        to_port                  = 443
        protocol                 = "tcp"
        cidr_blocks              = ["0.0.0.0/0"]
        source_security_group_id = null
        self                     = null
      },
  EOT
}

variable "security_group_extend_rules" {
  type        = any
  default     = []
  description = <<-EOT
    A list of maps of Security Group rules.
    The values of map is fully complated with `aws_security_group_rule` resource.
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.
    {
      type              = "ingress"
      from_port         = 6379
      to_port           = 6379
      protocol          = "tcp"
      cidr_blocks       = []
      security_group_id = "sg-123456789"
    }
  EOT
}

################################################################################
# Common Variables
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS Region name to deploy resources."
  type        = string
  default     = "ap-southeast-1"
}

variable "assume_role" {
  description = "AssumeRole to manage the resources within account that owns"
  type        = string
  default     = null
  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.assume_role))
    error_message = "Must be a valid AWS IAM role ARN."
  }
}

variable "master_prefix" {
  description = "Prefix name"
  type        = string
}
