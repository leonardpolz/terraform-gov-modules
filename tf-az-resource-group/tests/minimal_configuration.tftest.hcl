provider "azurerm" {
  features {}
}

variables {
  resource_groups = [{
    tf_id = "test_rg"
    name_config = {
      name_segments = {
        workload_name = "test"
        environment   = "dev"
      }
    }

    nc_bypass = "test-rg"
    location  = "westeurope"
    
    tags = {
      terraform_repository_uri = "test.git"
      deployed_by              = "test"
      hidden-title             = "Test Resource Group"
    }
  }]
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
}
