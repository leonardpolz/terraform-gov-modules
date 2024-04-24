output "resource_groups" {
  value = azurerm_resource_group.resource_groups
}

output "role_assignments" {
  value = module.role_assignments.role_assignments
}

output "resource_group_config_map" {
  value = module.configuration_interceptor.configuration_map 
}
