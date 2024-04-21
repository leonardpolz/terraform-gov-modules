provider "azurerm" {
  features {}
}

variables {
  role_assignments = [
    {
      tf_id                                  = "test_role_assignment_1"
      name                                   = "00000000-0000-0000-0000-000000000000"
      scope                                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg"
      role_definition_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/00000000-0000-0000-0000-000000000000"
      principal_id                           = "00000000-0000-0000-0000-000000000000"
      principal_type                         = "ServicePrincipal"
      condition                              = "true"
      condition_version                      = "1.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/00000000/providers/Microsoft.ManagedIdentity/userAssignedIdentities/00000000"
      description                            = "Test Role Assignment"
      skip_service_principal_aad_check       = true
      skip_principal_aad_check               = true
    },
    {
      tf_id                                  = "test_role_assignment_2"
      name                                   = "00000000-0000-0000-0000-000000000000"
      scope                                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg"
      role_definition_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/00000000-0000-0000-0000-000000000000"
      principal_id                           = "00000000-0000-0000-0000-000000000000"
      principal_type                         = "ServicePrincipal"
      condition                              = "true"
      condition_version                      = "1.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/00000000/providers/Microsoft.ManagedIdentity/userAssignedIdentities/00000000"
      description                            = "Test Role Assignment"
      skip_service_principal_aad_check       = true
      skip_principal_aad_check               = true
    }
  ]
}

run "plan" {

  command = plan

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment_1"].scope == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg"
    error_message = "The scope is not as expected"
  }

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment_1"].role_definition_id == "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/00000000-0000-0000-0000-000000000000"
    error_message = "The role_definition_id is not as expected"
  }

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment_1"].principal_id == "00000000-0000-0000-0000-000000000000"
    error_message = "The principal_id is not as expected"
  }

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment_1"].condition == "true"
    error_message = "The condition is not as expected"
  }

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment_1"].condition_version == "1.0"
    error_message = "The condition_version is not as expected"
  }

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment_1"].delegated_managed_identity_resource_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/00000000/providers/Microsoft.ManagedIdentity/userAssignedIdentities/00000000"
    error_message = "The delegated_managed_identity_resource_id is not as expected"
  }

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment_1"].description == "Test Role Assignment"
    error_message = "The description is not as expected"
  }

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment_1"].skip_service_principal_aad_check == true
    error_message = "The skip_service_principal_aad_check is not as expected"
  }
}
