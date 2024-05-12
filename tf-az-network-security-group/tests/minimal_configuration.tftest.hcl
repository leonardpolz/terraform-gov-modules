provider "azurerm" {
  features {}
}

run "plan" {
  command = plan

  variables {
    network_security_groups = [{
      tf_id = "test_nsg"

      name_config = {
        name_segments = {
          workload_name = "test-nsg"
          environment   = "test"
        }
      }

      nc_bypass = "test-nsg"

      tags = {
        terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
        deployed_by              = "Leonard Polz"
        hidden-title             = "Test Network Security Group"
      }

      resource_group_name = "test-rg"
      location            = "germanywestcentral"
    }]
  }

  assert {
    condition     = azurerm_network_security_group.network_security_groups["test_nsg"].name == "test-nsg"
    error_message = "Network security group name '${azurerm_network_security_group.network_security_groups["test_nsg"].name}' does not match expected value 'test-nsg'"
  }

  assert {
    condition     = azurerm_network_security_group.network_security_groups["test_nsg"].resource_group_name == "test-rg"
    error_message = "Network security group resource_group_name '${azurerm_network_security_group.network_security_groups["test_nsg"].resource_group_name}' does not match expected value 'test-rg'"
  }

  assert {
    condition     = azurerm_network_security_group.network_security_groups["test_nsg"].location == "germanywestcentral"
    error_message = "Network security group location '${azurerm_network_security_group.network_security_groups["test_nsg"].location}' does not match expected value 'germanywestcentral'"
  }
}
