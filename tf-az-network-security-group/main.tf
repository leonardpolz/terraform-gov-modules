module "configuration_interceptor" {
  source = "../tf-governance-interceptor-facade"
  configurations = [for nsg in var.network_security_groups : {
    tf_id                = nsg.tf_id
    resource_type        = "Microsoft.Network/networkSecurityGroups"
    resource_config_json = jsonencode(nsg)
    }
  ]
}

locals {
  network_security_group_map = {
    for nsg in var.network_security_groups : nsg.tf_id => merge(
      nsg, {
        name     = module.configuration_interceptor.configuration_map[nsg.tf_id].name
        tags     = module.configuration_interceptor.configuration_map[nsg.tf_id].tags
        location = module.configuration_interceptor.configuration_map[nsg.tf_id].location
    })
  }
}

resource "azurerm_network_security_group" "network_security_groups" {
  for_each            = local.network_security_group_map
  name                = each.value.nc_bypass != null ? each.value.nc_bypass : each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  tags                = each.value.tags
}

locals {
  network_security_rule_list = flatten([
    for key, nsg in local.network_security_group_map : [
      for sr in nsg.security_rules != null ? nsg.security_rules : [] : merge(
        sr, {
          tf_id     = "${key}_${sr.tf_id}"
          nsg_tf_id = key
      })
    ]
  ])
}

resource "azurerm_network_security_rule" "network_security_group_rules" {
  for_each                                   = { for sr in local.network_security_rule_list : sr.tf_id => sr }
  name                                       = each.value.nc_bypass != null ? each.value.nc_bypass : each.value.name
  resource_group_name                        = azurerm_network_security_group.network_security_groups[each.value.nsg_tf_id].resource_group_name
  network_security_group_name                = azurerm_network_security_group.network_security_groups[each.value.nsg_tf_id].name
  description                                = each.value.description
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  access                                     = each.value.access
  priority                                   = each.value.priority
  direction                                  = each.value.direction
}

module "role_assignments" {
  source = "../tf-az-role-assignment"
  role_assignments = flatten([
    for key, nsg in local.network_security_group_map : [
      for ra in nsg.role_assignments : merge(ra, {
        tf_id       = ra.tf_id != null ? ra.tf_id : "${key}_${ra.principal_id}_${ra.role_definition_name != null ? replace(ra.role_definition_name, " ", "_") : ra.role_definition_id}"
        parent_name = nsg.name
        scope       = azurerm_network_security_group.network_security_groups[key].id
      })
    ] if nsg.role_assignments != null
  ])
}

