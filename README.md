# AWS VPC Endpoints Terraform

Terraform creates VPC endpoint resources on AWS.

## Usage

```hcl
module "endpoints" {
  source = "git@github.com:examplae/aws-vpc-endpoints.git"
    
  master_prefix       = "dev"
  aws_region          = "ap-southeast-1"
  assume_role         = "arn:aws:iam::111122223333:role/AWSAFTExecution"
  vpc_id             = "vpc-12345678"
  security_group_ids = ["sg-12345678"]

  endpoints = {
    s3 = {
      # interface endpoint
      service             = "s3"
      tags                = { Name = "s3-vpc-endpoint" }
    },
    sqs = {
      service             = "sqs"
      private_dns_enabled = true
      security_group_ids  = ["sg-987654321"]
      subnet_ids          = ["subnet-12345678", "subnet-87654321"]
      tags                = { Name = "sqs-vpc-endpoint" }
    },
  }
  endpoint_services = {
    integration = {
      network_load_balancer_arns = [
        "arn:aws:elasticloadbalancing:ap-southeast-1:123456789012:loadbalancer/net/non-prod/8add86a6da89e57e"
      ],
    }
  }
}
```

## Examples

- [Complete-VPC](../../examples/complete-vpc) with VPC Endpoints.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | git::https://github.com/GalaxyFinX/aws-security-group.git | v1.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_connection_notification.connection_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_connection_notification) | resource |
| [aws_vpc_endpoint_service.endpoint_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service) | resource |
| [aws_vpc_endpoint_service_allowed_principal.allowed_principal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service_allowed_principal) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc_endpoint_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_master_prefix"></a> [master\_prefix](#input\_master\_prefix) | Prefix name | `string` | n/a | yes |
| <a name="input_allowed_principals"></a> [allowed\_principals](#input\_allowed\_principals) | A list of the ARNs of principal to allow to discover a VPC endpoint service. | `list(string)` | `[]` | no |
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | AssumeRole to manage the resources within account that owns | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name to deploy resources. | `string` | `"ap-southeast-1"` | no |
| <a name="input_create"></a> [create](#input\_create) | Determines whether resources will be created | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | A boolean flag to determine whether to create Security Group. | `bool` | `false` | no |
| <a name="input_endpoint_services"></a> [endpoint\_services](#input\_endpoint\_services) | A map of endpoint services containing their properties and configurations | `any` | `{}` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | A map of interface and/or gateway endpoints containing their properties and configurations | `any` | `{}` | no |
| <a name="input_notification_configurations"></a> [notification\_configurations](#input\_notification\_configurations) | A list of configurations of Endpoint Connection Notifications for VPC Endpoint events. | <pre>list(object({<br>    sns_arn = string<br>    events  = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_security_group_extend_rules"></a> [security\_group\_extend\_rules](#input\_security\_group\_extend\_rules) | A list of maps of Security Group rules.<br>The values of map is fully complated with `aws_security_group_rule` resource.<br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.<br>{<br>  type              = "ingress"<br>  from\_port         = 6379<br>  to\_port           = 6379<br>  protocol          = "tcp"<br>  cidr\_blocks       = []<br>  security\_group\_id = "sg-123456789"<br>} | `any` | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Default security group IDs to associate with the VPC endpoints | `list(string)` | `[]` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | A list of maps of Security Group rules.<br>The values of map is fully complated with `aws_security_group_rule` resource.<br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule.<br>  {<br>    type                     = "ingress"<br>    from\_port                = 443<br>    to\_port                  = 443<br>    protocol                 = "tcp"<br>    cidr\_blocks              = ["0.0.0.0/0"]<br>    source\_security\_group\_id = null<br>    self                     = null<br>  }, | `any` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "self": null,<br>    "source_security_group_id": null,<br>    "to_port": 0,<br>    "type": "egress"<br>  },<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 443,<br>    "protocol": "tcp",<br>    "to_port": 443,<br>    "type": "ingress"<br>  }<br>]</pre> | no |
| <a name="input_security_name"></a> [security\_name](#input\_security\_name) | Name of the security group. | `string` | `"endpoint-proxy"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Default subnets IDs to associate with the VPC endpoints | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting VPC endpoint resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which the endpoint will be used | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_entry_endpoints"></a> [dns\_entry\_endpoints](#output\_dns\_entry\_endpoints) | List of the DNS entries for the VPC Endpoint created |
| <a name="output_private_dns_name_endpoint_services"></a> [private\_dns\_name\_endpoint\_services](#output\_private\_dns\_name\_endpoint\_services) | List of the endpoint service private DNS name configuration |
| <a name="output_service_name_endpoint_services"></a> [service\_name\_endpoint\_services](#output\_service\_name\_endpoint\_services) | List of the service name for endpoint services created |
