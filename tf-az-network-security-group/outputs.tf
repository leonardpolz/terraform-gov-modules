output "network_security_groups" {
    value = azurerm_network_security_group.network_security_groups
}

output "network_security_group_rules" {
    value = azurerm_network_security_rule.network_security_group_rules
}

output "role_assignments" {
    value = module.role_assignments.role_assignments
}

output "network_security_group_config_map" {
  value = module.configuration_interceptor.configuration_map
}