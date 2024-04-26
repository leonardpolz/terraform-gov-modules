module "configuration_interceptor" {
  source = "../tf-governance-interceptor-facade"
  configurations = [for rt in var.route_tables : {
    tf_id                = rt.tf_id
    resource_type        = "Microsoft.Network/routeTables"
    resource_config_json = jsonencode(rt)
    }
  ]
}

locals {
  route_table_map = module.configuration_interceptor.configuration_map
}

resource "azurerm_route_table" "route_tables" {
  for_each                      = local.route_table_map
  name                          = each.value.nc_bypass != null ? each.value.nc_bypass : each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  tags                          = each.value.tags
}

locals {
  route_list = flatten([
    for key, rt in local.route_table_map : [
      for r in rt.routes != null ? rt.routes : [] : merge(
        r, {
          tf_id    = "${key}_${r.tf_id}"
          rt_tf_id = key
        }
      )
    ]
  ])
}

resource "azurerm_route" "routes" {
  for_each               = { for r in local.route_list : r.tf_id => r }
  name                   = each.value.nc_bypass != null ? each.value.nc_bypass : each.value.name
  resource_group_name    = azurerm_route_table.route_tables[each.value.rt_tf_id].resource_group_name
  route_table_name       = azurerm_route_table.route_tables[each.value.rt_tf_id].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}

module "role_assignments" {
  source = "../tf-az-role-assignment"
  role_assignments = flatten([
    for key, rt in local.route_table_map : [
      for ra in rt.role_assignments != null ? rt.role_assignments : [] : merge(ra, {
        tf_id = ra.tf_id != null ? ra.tf_id : "${key}_${ra.principal_id}_${ra.role_definition_name != null ? replace(ra.role_definition_name, " ", "_") : ra.role_definition_id}"
        scope = azurerm_route_table.route_tables[key].id
      })
    ]
  ])
}