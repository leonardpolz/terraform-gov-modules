provider "azurerm" {
  features {}
}

variables {
  route_tables = [
    {
      tf_id       = "test_route_table"
      parent_name = "test-parent"

      name_config = {
        values = {
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

      resource_group_name           = "my-rg"
      location                      = "germanywestcentral"
      disable_bgp_route_propagation = true

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

      routes = [
        {
          tf_id = "test_route"

          name_config = {
            values = {
              workload_name = "example"
            }
          }

          nc_bypass = "test-route"

          address_prefix         = "0.0.0.1"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "8.8.8.8"
        },
        {
          tf_id = "test_route_2"

          name_config = {
            values = {
              workload_name = "example"
            }
          }

          nc_bypass = "test-route"

          address_prefix         = "0.0.0.1"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "8.8.8.8"
        }
      ]
    },
    {
      tf_id       = "test_route_table_2"
      parent_name = "test-parent"

      name_config = {
        values = {
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

      resource_group_name           = "my-rg"
      location                      = "germanywestcentral"
      disable_bgp_route_propagation = true

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

      routes = [
        {
          tf_id = "test_route"

          name_config = {
            values = {
              workload_name = "example"
            }
          }

          nc_bypass = "test-route"

          address_prefix         = "0.0.0.1"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "8.8.8.8"
        },
        {
          tf_id = "test_route_2"

          name_config = {
            values = {
              workload_name = "example"
            }
          }

          nc_bypass = "test-route"

          address_prefix         = "0.0.0.1"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "8.8.8.8"
        }
      ]
    }
  ]
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
    condition     = azurerm_route_table.route_tables["test_route_table"].location == "germanywestcentral"
    error_message = "Route table location '${azurerm_route_table.route_tables["test_route_table"].location}' does not match expected value 'germanywestcentral'"
  }

  assert {
    condition     = azurerm_route_table.route_tables["test_route_table"].disable_bgp_route_propagation == true
    error_message = "Route table disable_bgp_route_propagation '${azurerm_route_table.route_tables["test_route_table"].disable_bgp_route_propagation}' does not match expected value 'true'"
  }

  assert {
    condition     = azurerm_route.routes["test_route_table_test_route"].address_prefix == "0.0.0.1"
    error_message = "Route address_prefix '${azurerm_route.routes["test_route_table_test_route"].address_prefix}' does not match expected value '0.0.0.1'"
  }

  assert {
    condition     = azurerm_route.routes["test_route_table_test_route"].next_hop_type == "VirtualAppliance"
    error_message = "Route next_hop_type '${azurerm_route.routes["test_route_table_test_route"].next_hop_type}' does not match expected value 'VirtualAppliance'"
  }

  assert {
    condition     = azurerm_route.routes["test_route_table_test_route"].next_hop_in_ip_address == "8.8.8.8"
    error_message = "Route next_hop_in_ip_address '${azurerm_route.routes["test_route_table_test_route"].next_hop_in_ip_address}' does not match expected value '8.8.8.8'"
  }
}
