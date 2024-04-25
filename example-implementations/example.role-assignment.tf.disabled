module "role_assignment" {
  //source = "git::https://github.com/leonardpolz/terraform-governance-framework-core-modules.git//tf-az-role-assignment?ref=v1.0.0"
  source = "../tf-az-role-assignment"
  role_assignments = [
    {
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      description                            = null
      name                                   = null
      principal_id                           = "00000000-0000-0000-0000-000000000000"
      role_definition_id                     = null
      role_definition_name                   = "Contributor"
      skip_service_principal_aad_check       = null
      tf_id                                  = "test"
      scope                                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group"
    },
    {
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      description                            = null
      name                                   = null
      principal_id                           = "11111111-1111-1111-1111-111111111111"
      role_definition_id                     = null
      role_definition_name                   = "Reader"
      skip_service_principal_aad_check       = null
      tf_id                                  = "test2"
      scope                                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group"
    },
  ]
}

output "role_assignment_config" {
  value = module.role_assignment.role_assignment_config_map
}