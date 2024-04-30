output "virtual_networks" {
  value = azurerm_virtual_network.virtual_networks
}

output "virtual_networks_dns_server_settings" {
  value = azurerm_virtual_network_dns_servers.dns_servers
}

output "subnets" {
  value = azurerm_subnet.subnets
}

output "virtual_network_peerings" {
  value = azurerm_virtual_network_peering.virtual_network_peerings
}

output "role_assignments" {
  value = module.role_assignments.role_assignments
}

output "virtual_network_config_map" {
  value = module.configuration_interceptor.configuration_map
}
