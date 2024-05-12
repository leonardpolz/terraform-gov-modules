provider "azurerm" {
  features {}
}

run "plan" {
  command = plan

  variables {
    private_endpoints = [{
      tf_id = "test_pep"

      name_config = {
         name_segments = {
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

      resource_group_name = "test-rg"
      location            = "germanywestcentral"
      subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"

      private_service_connection = {
        private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"
      }
    }]
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
    condition     = azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].private_connection_resource_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"
    error_message = "Private endpoint private_service_connection.private_connection_resource_id '${azurerm_private_endpoint.private_endpoints["test_pep"].private_service_connection[0].private_connection_resource_id}' does not match expected value '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet'"
  }
}
