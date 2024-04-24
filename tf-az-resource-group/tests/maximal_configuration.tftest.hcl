provider "azurerm" {
  features {}
}

variables {
  resource_groups = [
    {
      tf_id = "test_rg"
      name_config = {
        values = {
          workload_name = "test"
          environment   = "dev"
        }
      }

      nc_bypass = "test-rg"

      location   = "westeurope"
      managed_by = "test"

      tags = {
        terraform_repository_uri = "test.git"
        deployed_by              = "test"
        hidden-title             = "Test Resource Group"
      }

      role_assignments = [
        {
          tf_id              = "test_ra_1"
          principal_id       = "00000000-0000-0000-0000-000000000000"
          role_definition_id = "00000000-0000-0000-0000-000000000001"
        },
        {
          tf_id              = "test_ra_2"
          principal_id       = "00000000-0000-0000-0000-000000000001"
          role_definition_id = "00000000-0000-0000-0000-000000000002"
        }
      ]
    },
    {
      tf_id = "test_rg_2"
      name_config = {
        values = {
          workload_name = "test"
          environment   = "dev"
        }
      }

      nc_bypass = "test-rg"

      location   = "westeurope"
      managed_by = "test"

      tags = {
        terraform_repository_uri = "test.git"
        deployed_by              = "test"
        hidden-title             = "Test Resource Group"
      }

      role_assignments = [
        {
          principal_id       = "00000000-0000-0000-0000-000000000000"
          role_definition_id = "00000000-0000-0000-0000-000000000001"
        },
        {
          principal_id       = "00000000-0000-0000-0000-000000000000"
          role_definition_id = "00000000-0000-0000-0000-000000000002"
        }
      ]
    },
  ]
}

run "plan" {

  command = plan

  assert {
    condition     = azurerm_resource_group.resource_groups["test_rg"].name == "test-rg"
    error_message = "Resource group name '${azurerm_resource_group.resource_groups["test_rg"].name}' does not match expected value 'test-rg'"
  }

  assert {
    condition     = azurerm_resource_group.resource_groups["test_rg"].location == "westeurope"
    error_message = "Resource group location '${azurerm_resource_group.resource_groups["test_rg"].location}' does not match expected value 'westeurope'"
  }

  assert {
    condition     = azurerm_resource_group.resource_groups["test_rg"].managed_by == "test"
    error_message = "Resource group managed_by '${azurerm_resource_group.resource_groups["test_rg"].managed_by}' does not match expected value 'test'"
  }
}
