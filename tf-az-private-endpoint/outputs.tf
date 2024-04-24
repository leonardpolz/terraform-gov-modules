output "private_endpoints" {
  value = azurerm_private_endpoint.private_endpoints
}

output "role_assignments" {
  value = module.role_assignments.role_assignments
}

output "private_endpoint_config_map" {
  value = module.configuration_interceptor.configuration_map
}