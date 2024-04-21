output "resource_groups" {
  value = azurerm_resource_group.resource_groups
}

output "role_assignments" {
  value = module.role_assignments.role_assignments
}

