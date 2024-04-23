module "configuration_interceptor" {
  source = "../tf-governance-interceptor-facade"
  configurations = [for rg in var.resource_groups : {
    tf_id                = rg.tf_id
    resource_type        = "Microsoft.Resources/resourceGroups"
    resource_config_json = jsonencode(rg)
    }
  ]
}

locals {
  resource_group_map = module.configuration_interceptor.configuration_map
}

resource "azurerm_resource_group" "resource_groups" {
  for_each   = local.resource_group_map
  name       = each.value.name
  location   = each.value.location
  managed_by = each.value.managed_by
  tags       = each.value.tags
}

module "role_assignments" {
  source = "../tf-az-role-assignment"
  role_assignments = flatten([
    for key, rg in local.resource_group_map : [
      for ra in rg.role_assignments : merge(ra, {
        tf_id       = ra.tf_id != null ? ra.tf_id : "${key}_${ra.principal_id}_${ra.role_definition_name != null ? replace(ra.role_definition_name, " ", "_") : ra.role_definition_id}"
        parent_name = rg.name
        scope       = azurerm_resource_group.resource_groups[key].id
      })
    ] if rg.role_assignments != null
  ])
}

