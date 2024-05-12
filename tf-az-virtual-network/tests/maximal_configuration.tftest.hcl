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

        resource_group_name     = "test-rg"
        address_space           = ["0.0.0.0/16"]
        location                = "germanywestcentral"
        bgp_community           = "12076:50404"
        edge_zone               = "test"
        flow_timeout_in_minutes = 10

        ddos_protection_plan = {
          id     = "/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/myResourceGroup/providers/Microsoft.Network/ddosProtectionPlans/myDdosProtectionPlan"
          enable = true
        }

        encryption = {
          enforcement = "DropUnencrypted"
        }

        dns_servers = ["10.200.0.8"]

        subnets = [
          {
            tf_id = "default"

            name_config = {
              name_segments = {
                workload_name = "test"
              }
            }

            nc_bypass = "test-snet"

            address_prefixes                              = ["10.100.10.0/24"]
            private_endpoint_network_policies_enabled     = true
            private_link_service_network_policies_enabled = true
            service_endpoints                             = ["Microsoft.AzureActiveDirectory"]
            service_endpoint_policy_ids                   = ["/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/myResourceGroup/providers/Microsoft.Network/serviceEndpointPolicies/myServiceEndpointPolicy"]

            delegations = [
              {
                name_config = {
                  name_segments = {
                    workload_name = "test"
                  }
                }

                nc_bypass = "test-delegation"

                service_delegation = {
                  name    = "Microsoft.ApiManagement/service"
                  actions = ["Microsoft.Network/networkinterfaces/*"]
                }
              }
            ]

            network_security_group_associations = [
              {
                tf_id                     = "test"
                network_security_group_id = "/subscriptions/abcd1234-ef56-gh78-ij90-klmn1234opqr/resourceGroups/ExampleResourceGroup/providers/Microsoft.Network/networkSecurityGroups/ExampleNSG"
              }
            ]

            route_table_associations = [
              {
                tf_id          = "test"
                route_table_id = "/subscriptions/abcd1234-5678-90ab-cdef-1234567890ab/resourceGroups/ExampleResourceGroup/providers/Microsoft.Network/routeTables/ExampleRouteTable"
              }
            ]

            network_security_group_settings = {
              name_config = {
                name_segments = {}
              }

              nc_bypass = "test-nsg"

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
          }
        ]

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
      {
        tf_id = "test_vnet_2"

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

        resource_group_name     = "test-rg"
        address_space           = ["0.0.0.0/16"]
        location                = "germanywestcentral"
        bgp_community           = "12076:50404"
        edge_zone               = "test"
        flow_timeout_in_minutes = 10

        ddos_protection_plan = {
          id     = "/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/myResourceGroup/providers/Microsoft.Network/ddosProtectionPlans/myDdosProtectionPlan"
          enable = true
        }

        encryption = {
          enforcement = "DropUnencrypted"
        }

        dns_servers = ["10.200.0.8"]

        subnets = [
          {
            tf_id = "default"

            name_config = {
              name_segments = {}
            }

            nc_bypass = "test-snet"

            address_prefixes                              = ["10.100.10.0/24"]
            private_endpoint_network_policies_enabled     = true
            private_link_service_network_policies_enabled = true
            service_endpoints                             = ["Microsoft.AzureActiveDirectory"]
            service_endpoint_policy_ids                   = ["/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/myResourceGroup/providers/Microsoft.Network/serviceEndpointPolicies/myServiceEndpointPolicy"]

            delegations = [
              {
                name_config = {
                  name_segments = {
                    workload_name = "test"
                  }
                }

                nc_bypass = "test-delegation"

                service_delegation = {
                  name    = "Microsoft.ApiManagement/service"
                  actions = ["Microsoft.Network/networkinterfaces/*"]
                }
              }
            ]

            network_security_group_associations = [
              {
                tf_id                     = "test"
                network_security_group_id = "/subscriptions/abcd1234-ef56-gh78-ij90-klmn1234opqr/resourceGroups/ExampleResourceGroup/providers/Microsoft.Network/networkSecurityGroups/ExampleNSG"
              }
            ]

            route_table_associations = [
              {
                tf_id          = "test"
                route_table_id = "/subscriptions/abcd1234-5678-90ab-cdef-1234567890ab/resourceGroups/ExampleResourceGroup/providers/Microsoft.Network/routeTables/ExampleRouteTable"
              }
            ]
          }
        ]

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
    error_message = "Virtual network address_space[0] '${azurerm_virtual_network.virtual_networks["test_vnet"].address_space[0]}' does not match expected value '0.0.0.0/16'"
  }

  assert {
    condition     = azurerm_virtual_network.virtual_networks["test_vnet"].location == "germanywestcentral"
    error_message = "Virtual network location '${azurerm_virtual_network.virtual_networks["test_vnet"].location}' does not match expected value 'germanywestcentral'"
  }

  assert {
    condition     = azurerm_virtual_network.virtual_networks["test_vnet"].bgp_community == "12076:50404"
    error_message = "Virtual network bgp_community '${azurerm_virtual_network.virtual_networks["test_vnet"].bgp_community}' does not match expected value '12076:50404'"
  }

  assert {
    condition     = azurerm_virtual_network.virtual_networks["test_vnet"].edge_zone == "test"
    error_message = "Virtual network edge_zone '${azurerm_virtual_network.virtual_networks["test_vnet"].edge_zone}' does not match expected value 'test'"
  }

  assert {
    condition     = azurerm_virtual_network.virtual_networks["test_vnet"].ddos_protection_plan[0].id == "/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/myResourceGroup/providers/Microsoft.Network/ddosProtectionPlans/myDdosProtectionPlan"
    error_message = "Virtual network ddos_protection_plan[0].id '${azurerm_virtual_network.virtual_networks["test_vnet"].ddos_protection_plan[0].id}' does not match expected value '/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/myResourceGroup/providers/Microsoft.Network/ddosProtectionPlans/myDdosProtectionPlan'"
  }

  assert {
    condition     = azurerm_virtual_network.virtual_networks["test_vnet"].ddos_protection_plan[0].enable == true
    error_message = "Virtual network ddos_protection_plan[0].enable '${azurerm_virtual_network.virtual_networks["test_vnet"].ddos_protection_plan[0].enable}' does not match expected value 'true'"
  }

  assert {
    condition     = azurerm_virtual_network.virtual_networks["test_vnet"].encryption[0].enforcement == "DropUnencrypted"
    error_message = "Virtual network encryption[0].enforcement '${azurerm_virtual_network.virtual_networks["test_vnet"].encryption[0].enforcement}' does not match expected value 'DropUnencrypted'"
  }

  assert {
    condition     = azurerm_virtual_network_dns_servers.dns_servers["test_vnet"].dns_servers[0] == "10.200.0.8"
    error_message = "Virtual network dns_servers[0] '${azurerm_virtual_network_dns_servers.dns_servers["test_vnet"].dns_servers[0]}' does not match expected value '10.200.0.8'"
  }

  assert {
    condition     = azurerm_subnet.subnets["test_vnet_default"].name == "test-snet"
    error_message = "Virtual network subnet name '${azurerm_subnet.subnets["test_vnet_default"].name}' does not match expected value 'test-snet'"
  }

  assert {
    condition     = azurerm_subnet.subnets["test_vnet_default"].address_prefixes[0] == "10.100.10.0/24"
    error_message = "Virtual network subnet address_prefixes[0] '${azurerm_subnet.subnets["test_vnet_default"].address_prefixes[0]}' does not match expected value '10.100.10.0/24'"
  }

  assert {
    condition     = azurerm_subnet.subnets["test_vnet_default"].private_endpoint_network_policies_enabled == true
    error_message = "Virtual network subnet private_endpoint_network_policies_enabled '${azurerm_subnet.subnets["test_vnet_default"].private_endpoint_network_policies_enabled}' does not match expected value 'true'"
  }

  assert {
    condition     = azurerm_subnet.subnets["test_vnet_default"].private_link_service_network_policies_enabled == true
    error_message = "Virtual network subnet private_link_service_network_policies_enabled '${azurerm_subnet.subnets["test_vnet_default"].private_link_service_network_policies_enabled}' does not match expected value 'true'"
  }

  assert {
    condition     = azurerm_subnet.subnets["test_vnet_default"].service_endpoints != null
    error_message = "Virtual network subnet service_endpoints is null"
  }

  assert {
    condition     = azurerm_subnet.subnets["test_vnet_default"].service_endpoint_policy_ids != null
    error_message = "Virtual network subnet service_endpoint_policy_ids is null"
  }

  assert {
    condition     = azurerm_subnet.subnets["test_vnet_default"].delegation[0].name == "test-delegation"
    error_message = "Virtual network subnet delegations[0].name '${azurerm_subnet.subnets["test_vnet_default"].delegation[0].name}' does not match expected value 'test-delegation'"
  }

  assert {
    condition     = azurerm_subnet.subnets["test_vnet_default"].delegation[0].service_delegation[0].name == "Microsoft.ApiManagement/service"
    error_message = "Virtual network subnet delegations[0].service_delegation[0].name '${azurerm_subnet.subnets["test_vnet_default"].delegation[0].service_delegation[0].name}' does not match expected value 'Microsoft.ApiManagement/service'"
  }

  assert {
    condition     = azurerm_subnet.subnets["test_vnet_default"].delegation[0].service_delegation[0].actions[0] == "Microsoft.Network/networkinterfaces/*"
    error_message = "Virtual network subnet delegations[0].service_delegation[0].actions[0] '${azurerm_subnet.subnets["test_vnet_default"].delegation[0].service_delegation[0].actions[0]}' does not match expected value 'Microsoft.Network/networkinterfaces/*'"
  }

  assert {
    condition     = azurerm_subnet_route_table_association.route_table_associations["test_vnet_default_test"].route_table_id == "/subscriptions/abcd1234-5678-90ab-cdef-1234567890ab/resourceGroups/ExampleResourceGroup/providers/Microsoft.Network/routeTables/ExampleRouteTable"
    error_message = "Virtual network subnet route_table_associations[0].route_table_id '${azurerm_subnet_route_table_association.route_table_associations["test_vnet_default_test"].route_table_id}' does not match expected value '/subscriptions/abcd1234-5678-90ab-cdef-1234567890ab/resourceGroups/ExampleResourceGroup/providers/Microsoft.Network/routeTables/ExampleRouteTable'"
  }
}
