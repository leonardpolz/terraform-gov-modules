provider "azurerm" {
  features {}
}

run "plan" {
  command = plan

  variables {
    network_security_groups = [
      {
        tf_id       = "test_nsg"
        parent_name = "example-parent"

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

        role_assignments = [
          {
            principal_id       = "00000000-0000-0000-0000-000000000000"
            role_definition_id = "00000000-0000-0000-0000-000000000001"
          },
          {
            principal_id       = "00000000-0000-0000-0000-000000000001"
            role_definition_id = "00000000-0000-0000-0000-000000000002"
          }
        ]

        security_rules = [
          {
            tf_id = "test_nsg_rule"

            name_config = {
              name_segments = {
                workload_name = "test-nsg-rule"
              }
            }

            nc_bypass = "test-nsg-rule"

            description                = "Allow inbound traffic on port 80"
            protocol                   = "Tcp"
            source_port_range          = "33"
            source_address_prefix      = "1.1.1.1"
            destination_port_range     = "80"
            destination_address_prefix = "2.2.2.2"
            access                     = "Allow"
            priority                   = 100
            direction                  = "Inbound"
          }
        ]
      },
      {
        tf_id       = "test_nsg_2"
        parent_name = "example-parent"

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

        role_assignments = [
          {
            principal_id       = "00000000-0000-0000-0000-000000000000"
            role_definition_id = "00000000-0000-0000-0000-000000000001"
          },
          {
            principal_id       = "00000000-0000-0000-0000-000000000001"
            role_definition_id = "00000000-0000-0000-0000-000000000002"
          }
        ]

        security_rules = [
          {
            tf_id = "test_nsg_rule"

            name_config = {
              name_segments = {
                workload_name = "test-nsg-rule"
              }
            }

            nc_bypass = "test-nsg-rule"

            description                = "Allow inbound traffic on port 80"
            protocol                   = "Tcp"
            source_port_range          = "33"
            source_address_prefix      = "1.1.1.1"
            destination_port_range     = "80"
            destination_address_prefix = "2.2.2.2"
            access                     = "Allow"
            priority                   = 100
            direction                  = "Inbound"
          }
        ]
      }
    ]
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

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].name == "test-nsg-rule"
    error_message = "Network security rule name '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].name}' does not match expected value 'test-nsg-rule'"
  }

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].description == "Allow inbound traffic on port 80"
    error_message = "Network security rule description '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].description}' does not match expected value 'Allow inbound traffic on port 80'"
  }

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].protocol == "Tcp"
    error_message = "Network security rule protocol '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].protocol}' does not match expected value 'Tcp'"
  }

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].source_port_range == "33"
    error_message = "Network security rule source_port_range '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].source_port_range}' does not match expected value '33'"
  }

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].source_address_prefix == "1.1.1.1"
    error_message = "Network security rule source_address_prefix '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].source_address_prefix}' does not match expected value '1.1.1.1'"
  }

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].destination_port_range == "80"
    error_message = "Network security rule destination_port_range '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].destination_port_range}' does not match expected value '80'"
  }

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].destination_address_prefix == "2.2.2.2"
    error_message = "Network security rule destination_address_prefix '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].destination_address_prefix}' does not match expected value '2.2.2.2'"
  }

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].access == "Allow"
    error_message = "Network security rule access '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].access}' does not match expected value 'Allow'"
  }

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].priority == 100
    error_message = "Network security rule priority '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].priority}' does not match expected value '100'"
  }

  assert {
    condition     = azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].direction == "Inbound"
    error_message = "Network security rule direction '${azurerm_network_security_rule.network_security_group_rules["test_nsg_test_nsg_rule"].direction}' does not match expected value 'Inbound'"
  }
}