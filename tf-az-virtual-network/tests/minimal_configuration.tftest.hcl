provider "azurerm" {
  features {}
}

run "plan" {
  command = plan

  variables {
    virtual_networks = [
      {
        tf_id = "test_vnet"

        name_config = {
          name_segments = {
            environment   = "tst"
            workload_name = "test-vnet"
          }
        }

        nc_bypass = "test-vnet"

        tags = {
          terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
          deployed_by              = "Leonard Polz"
          hidden-title             = "Test Virtual Network"
        }

        resource_group_name = "test-rg"
        address_space       = ["0.0.0.0/16"]
      },
    ]
  }

  assert {
    condition     = azurerm_virtual_network.virtual_networks["test_vnet"].name == "test-vnet"
    error_message = "Virtual network name '${azurerm_virtual_network.virtual_networks["test_vnet"].name}' does not match expected value 'test-vnet'"
  }


  assert {
    condition     = azurerm_virtual_network.virtual_networks["test_vnet"].resource_group_name == "test-rg"
    error_message = "Virtual network resource_group_name '${azurerm_virtual_network.virtual_networks["test_vnet"].resource_group_name}' does not match expected value 'test-rg'"
  }

  assert {
    condition     = azurerm_virtual_network.virtual_networks["test_vnet"].address_space[0] == "0.0.0.0/16"
    error_message = "Virtual network address_space[0] '${azurerm_virtual_network.virtual_networks["test_vnet"].resource_group_name}' does not match expected value '0.0.0.0/16'"
  }
}