data "aws_region" "current" {}

data "aws_vpc_endpoint_service" "this" {
  for_each = { for k, v in var.endpoints : k => v if var.create }

  service      = lookup(each.value, "service", null)
  service_name = lookup(each.value, "service_name", null)

  filter {
    name   = "service-type"
    values = [lookup(each.value, "service_type", "Interface")]
  }
}
