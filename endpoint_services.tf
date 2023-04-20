################################################################################
# Endpoint(s) Services
################################################################################

resource "aws_vpc_endpoint_service" "endpoint_service" {
  for_each = { for k, v in var.endpoint_services : k => v if var.create && try(v.create, true) }

  gateway_load_balancer_arns = lookup(each.value, "gateway_load_balancer_arns", null)
  network_load_balancer_arns = lookup(each.value, "network_load_balancer_arns", null)
  private_dns_name           = lookup(each.value, "private_dns_name", null)
  acceptance_required        = lookup(each.value, "acceptance_required", true)

  tags = merge(
    var.tags,
    {
      Name = format("%s-%s-endpoint-services", var.master_prefix, each.key)
    },
    lookup(each.value, "tags", {})
  )
}

###################################################
# Allowed Principals
###################################################
locals {
  allowed_principals = flatten([
    for k, v in var.endpoint_services : [
      for principal in distinct(concat(var.allowed_principals, lookup(var.endpoint_services, "allowed_principals", []))) : {
        vpc_endpoint_service_id = aws_vpc_endpoint_service.endpoint_service[k].id
        principal_arn           = principal
      }
    ]
  ])
}

resource "aws_vpc_endpoint_service_allowed_principal" "allowed_principal" {
  for_each = { for k, v in local.allowed_principals : k => v if var.create && try(v.create, true) }

  vpc_endpoint_service_id = each.value.vpc_endpoint_service_id
  principal_arn           = each.value.principal_arn
}

###################################################
# Notification
###################################################

locals {
  notification_configurations = flatten([
    for k, v in var.endpoint_services : [
      for notification in distinct(concat(var.notification_configurations, lookup(var.endpoint_services, "notification_configurations", []))) : {
        vpc_endpoint_service_id     = aws_vpc_endpoint_service.endpoint_service[k].id
        connection_notification_arn = notification.notification_arn
        connection_events           = try(notification.events, ["Accept", "Reject"])
      }
    ]
  ])
}

resource "aws_vpc_endpoint_connection_notification" "connection_notification" {
  for_each = { for k, v in local.notification_configurations : k => v if var.create && try(v.create, true) }

  vpc_endpoint_service_id     = each.value.vpc_endpoint_service_id
  connection_notification_arn = each.value.connection_notification_arn
  connection_events           = each.value.connection_events
}
