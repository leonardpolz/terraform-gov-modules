provider "azurerm" {
  features {}
}

variables {
  role_assignments = [{
    tf_id              = "test_role_assignment"
    scope              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg"
    role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/00000000-0000-0000-0000-000000000000"
    principal_id       = "00000000-0000-0000-0000-000000000000"
  }]
}

run "plan" {

  command = plan

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment"].scope == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg"
    error_message = "The scope is not as expected"
  }

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment"].role_definition_id == "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/00000000-0000-0000-0000-000000000000"
    error_message = "The role_definition_id is not as expected"
  }

  assert {
    condition     = azurerm_role_assignment.role_assignments["test_role_assignment"].principal_id == "00000000-0000-0000-0000-000000000000"
    error_message = "The principal_id is not as expected"
  }
}
