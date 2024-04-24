output "role_assignments" {
  value = azurerm_role_assignment.role_assignments
}

output "role_assignment_config_map" {
  value = module.configuration_interceptor.configuration_map
}