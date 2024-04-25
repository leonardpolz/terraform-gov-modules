module "configuration_interceptor" {
  source = "../tf-governance-interceptor-facade"
  configurations = [for vnet in var.virtual_networks : {
    tf_id                = vnet.tf_id
    resource_type        = "Microsoft.Network/virtualNetworks"
    resource_config_json = jsonencode(vnet)
    }
  ]
}

locals {
  virtual_network_map = module.configuration_interceptor.configuration_map
}

resource "azurerm_virtual_network" "virtual_networks" {
  for_each                = local.virtual_network_map
  name                    = each.value.nc_bypass != null ? each.value.nc_bypass : each.value.name
  resource_group_name     = each.value.resource_group_name
  address_space           = each.value.address_space
  location                = each.value.location
  bgp_community           = each.value.bgp_community
  edge_zone               = each.value.edge_zone
  flow_timeout_in_minutes = each.value.flow_timeout_in_minutes
  tags                    = each.value.tags

  dynamic "ddos_protection_plan" {
    for_each = each.value.ddos_protection_plan != null ? [each.value.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  dynamic "encryption" {
    for_each = each.value.encryption != null ? [each.value.encryption] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }
}

resource "azurerm_virtual_network_dns_servers" "dns_servers" {
  for_each           = local.virtual_network_map
  virtual_network_id = azurerm_virtual_network.virtual_networks[each.key].id
  dns_servers        = each.value.dns_servers
}

locals {
  subnet_list = flatten([
    for key, vnet in local.virtual_network_map : [
      for snet in vnet.subnets != null ? vnet.subnets : [] : merge(snet, {
        tf_id               = "${key}_${snet.tf_id}"
        vnet_tf_id          = key
        resource_group_name = vnet.resource_group_name
      })
    ]
  ])

  subnet_map = { for snet in local.subnet_list : snet.tf_id => snet }
}

resource "azurerm_subnet" "subnets" {
  for_each                                      = local.subnet_map
  name                                          = each.value.nc_bypass != null ? each.value.nc_bypass : each.value.name
  resource_group_name                           = each.value.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.virtual_networks[each.value.vnet_tf_id].name
  address_prefixes                              = each.value.address_prefixes
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids

  dynamic "delegation" {
    for_each = each.value.delegations != null ? each.value.delegations : []
    content {
      name = delegation.value.nc_bypass != null ? delegation.value.nc_bypass : delegation.value.name

      dynamic "service_delegation" {
        for_each = delegation.value.service_delegation != null ? [delegation.value.service_delegation] : []
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}

locals {
  network_security_group_association_list = flatten([
    for key, snet in local.subnet_map : [
      for nsga in snet.network_security_group_associations != null ? snet.network_security_group_associations : [] : merge(
        nsga, {
          tf_id      = "${key}_${nsga.tf_id}"
          snet_tf_id = key
        }
      )
    ]
  ])
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_associations" {
  for_each                  = { for nsga in local.network_security_group_association_list : nsga.tf_id => nsga }
  network_security_group_id = each.value.network_security_group_id
  subnet_id                 = azurerm_subnet.subnets[each.value.snet_tf_id].id
}

locals {
  route_table_association_list = flatten([
    for key, snet in local.subnet_map : [
      for rta in snet.route_table_associations != null ? snet.route_table_associations : [] : merge(
        rta, {
          tf_id      = "${key}_${rta.tf_id}"
          snet_tf_id = key
        }
      )
    ]
  ])
}

resource "azurerm_subnet_route_table_association" "route_table_associations" {
  for_each       = { for rta in local.route_table_association_list : rta.tf_id => rta }
  route_table_id = each.value.route_table_id
  subnet_id      = azurerm_subnet.subnets[each.value.snet_tf_id].id
}

locals {
  virtual_network_peering_list = flatten([
    for key, vnet in local.virtual_network_map : [
      for vnetp in vnet.virtual_network_peerings != null ? vnet.virtual_network_peerings : [] : merge(
        vnetp, {
          tf_id               = "${key}_${vnetp.tf_id}"
          vnet_tf_id          = key
          resource_group_name = vnet.resource_group_name
      })
    ]
  ])
}

resource "azurerm_virtual_network_peering" "virtual_network_peerings" {
  for_each                     = { for vnetp in local.virtual_network_peering_list : vnetp.tf_id => vnetp }
  name                         = each.value.nc_bypass != null ? each.value.nc_bypass : each.value.name
  virtual_network_name         = azurerm_virtual_network.virtual_networks[each.value.vnet_tf_id].name
  remote_virtual_network_id    = each.value.remote_virtual_network_id
  resource_group_name          = each.value.resource_group_name
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  use_remote_gateways          = each.value.use_remote_gateways
  triggers                     = each.value.triggers
}

module "role_assignments" {
  source = "../tf-az-role-assignment"
  role_assignments = flatten([
    for key, vnet in local.virtual_network_map : [
      for ra in vnet.role_assignments != null ? vnet.role_assignments : [] : merge(ra, {
        tf_id = ra.tf_id != null ? ra.tf_id : "${key}_${ra.principal_id}_${ra.role_definition_name != null ? replace(ra.role_definition_name, " ", "_") : ra.role_definition_id}"
        scope = azurerm_virtual_network.virtual_networks[key].id
      })
    ]
  ])
}