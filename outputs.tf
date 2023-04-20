output "dns_entry_endpoints" {
  description = "List of the DNS entries for the VPC Endpoint created"
  value       = { for k, v in aws_vpc_endpoint.this : k => v.dns_entry[0] if length(v.dns_entry) > 0 }
}

output "service_name_endpoint_services" {
  description = "List of the service name for endpoint services created"
  value       = { for k, v in aws_vpc_endpoint_service.endpoint_service : k => try(v.service_name, "") }
}

output "private_dns_name_endpoint_services" {
  description = "List of the endpoint service private DNS name configuration"
  value       = { for k, v in aws_vpc_endpoint_service.endpoint_service : k => try(v.private_dns_name_configuration[0], "") }
}
