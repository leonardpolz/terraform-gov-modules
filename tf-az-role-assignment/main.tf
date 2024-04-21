module "configuration_interceptor" {
  source = "git::https://github.com/leonardpolz/terraform-governance-framework-interceptor-module-example?ref=v1.0.0"
  configurations = [for ra in var.role_assignments : {
    tf_id                = ra.tf_id
    resource_type        = "Microsoft.Authorization/roleAssignments"
    resource_config_json = jsonencode(ra)
    }
  ]
}

resource "azurerm_role_assignment" "role_assignments" {
  for_each = module.configuration_interceptor.configuration_map

  name                                   = each.value.name
  scope                                  = each.value.scope
  role_definition_id                     = each.value.role_definition_id
  role_definition_name                   = each.value.role_definition_name
  principal_id                           = each.value.principal_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  description                            = each.value.description
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

