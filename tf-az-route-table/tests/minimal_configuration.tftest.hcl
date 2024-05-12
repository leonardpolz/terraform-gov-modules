provider "azurerm" {
  features {}
}

variables {
  route_tables = [{
    tf_id = "test_route_table"

    name_config = {
      name_segments = {
        workload_name = "example"
        environment   = "tst"
      }
    }

    nc_bypass = "test-route-table"

    tags = {
      terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
      deployed_by              = "Leonard Polz"
      hidden-title             = "Test Virtual Network"
    }

    resource_group_name = "my-rg"
    location            = "westeurope"
  }]
}

run "plan" {
  command = plan

  assert {
    condition     = azurerm_route_table.route_tables["test_route_table"].name == "test-route-table"
    error_message = "Route table name '${azurerm_route_table.route_tables["test_route_table"].name}' does not match expected value 'test-route-table'"
  }

  assert {
    condition     = azurerm_route_table.route_tables["test_route_table"].resource_group_name == "my-rg"
    error_message = "Route table resource_group_name '${azurerm_route_table.route_tables["test_route_table"].resource_group_name}' does not match expected value 'my-rg'"
  }

  assert {
    condition     = azurerm_route_table.route_tables["test_route_table"].location == "westeurope"
    error_message = "Route table location '${azurerm_route_table.route_tables["test_route_table"].location}' does not match expected value 'westeurope'"
  }
}
