provider "azurerm" {
  features {}
}

run "plan" {
  command = plan

  variables {
    private_endpoints = [
      {
        tf_id = "test_pep"

        name_config = {
          values = {
            workload_name = "testendpoint"
            environment   = "test"
          }
        }

        nc_bypass = "test-pep"

        tags = {
          terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
          deployed_by              = "Leonard Polz"
          hidden-title             = "Test Private Endpoint"
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

        resource_group_name = "test-rg"
        location            = "germanywestcentral"
        subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"

        custom_network_interface_name = "test-nic"
        private_dns_zone_group = {
          name = "test-dns-zone-group"
          private_dns_zone_ids = [
            "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/privateDnsZones/myprivatedns.zone"
          ]
        }

        private_service_connection = {
          name                           = "test-service-connection"
          private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"
          subresource_names              = ["test"]
          request_message                = "test"
        }

        ip_configuration = {
          name               = "test-ip-config"
          private_ip_address = "0.0.0.0"
          subresource_name   = "test"
          member_name        = "test"
        }
      },
      {
        tf_id = "test_pep"

        name_config = {
          values = {
            workload_name = "testendpoint"
            environment   = "test"
          }
        }

        nc_bypass = "test-pep"

        tags = {
          terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
          deployed_by              = "Leonard Polz"
          hidden-title             = "Test Private Endpoint"
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

        resource_group_name = "test-rg"
        location            = "germanywestcentral"
        subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"

        custom_network_interface_name = "test-nic"
        private_dns_zone_group = {
          name = "test-dns-zone-group"
          private_dns_zone_ids = [
            "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/privateDnsZones/myprivatedns.zone"
          ]
        }

        private_service_connection = {
          name                           = "test-service-connection"
          private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"
          subresource_names              = ["test"]
          request_message                = "test"
        }

        ip_configuration = {
          name               = "test-ip-config"
          private_ip_address = "0.0.0.0"
          subresource_name   = "test"
          member_name        = "test"
        }
      }
    ]
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].name == "test-pep"
    error_message = "Private endpoint name '${azurerm_private_endpoint.private_endpoints["test_pep"].name}' does not match expected value 'test-pep'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].resource_group_name == "test-rg"
    error_message = "Private endpoint resource_group_name '${azurerm_private_endpoint.private_endpoints["test_pep"].resource_group_name}' does not match expected value 'test-rg'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].location == "germanywestcentral"
    error_message = "Private endpoint location '${azurerm_private_endpoint.private_endpoints["test_pep"].location}' does not match expected value 'germanywestcentral'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].subnet_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"
    error_message = "Private endpoint subnet_id '${azurerm_private_endpoint.private_endpoints["test_pep"].subnet_id}' does not match expected value '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].private_dns_zone_group[0].name == "test-dns-zone-group"
    error_message = "Private endpoint dns_zone_group.name '${azurerm_private_endpoint.private_endpoints["test_pep"].private_dns_zone_group[0].name}' does not match expected value 'test-dns-zone-group'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].private_dns_zone_group[0].private_dns_zone_ids[0] == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/privateDnsZones/myprivatedns.zone"
    error_message = "Private endpoint dns_zone_group.private_dns_zone_ids[0] '${azurerm_private_endpoint.private_endpoints["test_pep"].private_dns_zone_group[0].private_dns_zone_ids[0]}' does not match expected value '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/privateDnsZones/myprivatedns.zone'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].name == "test-service-connection"
    error_message = "Private endpoint private_service_connection.name '${azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].name}' does not match expected value 'test-service-connection'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].private_connection_resource_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"
    error_message = "Private endpoint private_service_connection.private_connection_resource_id '${azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].private_connection_resource_id}' does not match expected value '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].subresource_names[0] == "test"
    error_message = "Private endpoint private_service_connection.subresource_names[0] '${azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].subresource_names[0]}' does not match expected value 'test'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].request_message == "test"
    error_message = "Private endpoint private_service_connection.request_message '${azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].request_message}' does not match expected value 'test'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].ip_configuration[0].name == "test-ip-config"
    error_message = "Private endpoint ip_configuration.name '${azurerm_private_endpoint.private_endpoints["test_pep"].ip_configuration[0].name}' does not match expected value 'test-ip-config'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].ip_configuration[0].private_ip_address == "0.0.0.0"
    error_message = "Private endpoint ip_configuration.private_ip_address '${azurerm_private_endpoint.private_endpoints["test_pep"].ip_configuration[0].private_ip_address}' does not match expected value '0.0.0.0'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].ip_configuration[0].subresource_name == "test"
    error_message = "Private endpoint ip_configuration.subresource_name '${azurerm_private_endpoint.private_endpoints["test_pep"].ip_configuration[0].subresource_name}' does not match expected value 'test'"
  }

  assert {
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].ip_configuration[0].member_name == "test"
    error_message = "Private endpoint ip_configuration.member_name '${azurerm_private_endpoint.private_endpoints["test_pep"].ip_configuration[0].member_name}' does not match expected value 'test'"
  }
}
