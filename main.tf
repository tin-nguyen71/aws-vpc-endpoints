################################################################################
# Endpoint(s)
################################################################################

locals {
  security_group = length(var.security_group_ids) > 0 ? var.security_group_ids : [module.security_group.security_group_id]
}

resource "aws_vpc_endpoint" "this" {
  for_each = { for k, v in var.endpoints : k => v if var.create && try(v.create, true) }

  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.this[each.key].service_name
  vpc_endpoint_type = lookup(each.value, "service_type", "Interface")
  auto_accept       = lookup(each.value, "auto_accept", null)

  security_group_ids  = lookup(each.value, "service_type", "Interface") == "Interface" ? distinct(concat(local.security_group, lookup(each.value, "security_group_ids", []))) : null
  subnet_ids          = lookup(each.value, "service_type", "Interface") == "Interface" ? distinct(concat(var.subnet_ids, lookup(each.value, "subnet_ids", []))) : null
  route_table_ids     = lookup(each.value, "service_type", "Interface") == "Gateway" ? lookup(each.value, "route_table_ids", null) : null
  policy              = lookup(each.value, "policy", null)
  private_dns_enabled = lookup(each.value, "service_type", "Interface") == "Interface" ? lookup(each.value, "private_dns_enabled", null) : null

  tags = merge(
    var.tags,
    {
      Name = format("%s-%s-vpc-endpoint", var.master_prefix, each.key)
    },
    lookup(each.value, "tags", {})
  )

  timeouts {
    create = lookup(var.timeouts, "create", "10m")
    update = lookup(var.timeouts, "update", "10m")
    delete = lookup(var.timeouts, "delete", "10m")
  }
}
