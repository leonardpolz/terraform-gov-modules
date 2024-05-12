provider "azurerm" {
  features {}
}

run "plan" {
  command = plan

  variables {
    mssql_managed_instances = [{
      tf_id = "example"
      name_config = {
        name_segments = {
          environment   = "tst"
          workload_name = "example-managed-instance"
        }
      }

      nc_bypass = "example-managed-instance"

      tags = {
        terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
        deployed_by              = "Leonard Polz"
        hidden-title             = "Test Managed Instance"
      }

      administrator_login          = "admin"
      administrator_login_password = "Password123!"
      resource_group_name          = "example-resource-group"
      storage_size_in_gb           = "32"
      vcores                       = "8"

      connectivity_settings = {
        private_endpoints = [{
          tf_id = "example_pep"

          private_endpoint_config = {
            subnet_id = "/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet"
          }
        }]
      }
    }]
  }

  assert {
    condition     = azurerm_mssql_managed_instance.managed_instances["example"].name == "example-managed-instance"
    error_message = "Managed Instance name '${azurerm_mssql_managed_instance.managed_instances["example"].name}' does not match expected value 'example-managed-instance'"
  }

  assert {
    condition     = azurerm_mssql_managed_instance.managed_instances["example"].administrator_login == "admin"
    error_message = "Managed Instance administrator_login '${azurerm_mssql_managed_instance.managed_instances["example"].administrator_login}' does not match expected value 'admin'"
  }

  assert {
    condition     = azurerm_mssql_managed_instance.managed_instances["example"].administrator_login_password == "Password123!"
    error_message = "Managed Instance administrator_login_password '${azurerm_mssql_managed_instance.managed_instances["example"].administrator_login_password}' does not match expected value 'Password123!'"
  }

  assert {
    condition     = azurerm_mssql_managed_instance.managed_instances["example"].resource_group_name == "example-resource-group"
    error_message = "Managed Instance resource_group_name '${azurerm_mssql_managed_instance.managed_instances["example"].resource_group_name}' does not match expected value 'example-resource-group'"
  }

  assert {
    condition     = azurerm_mssql_managed_instance.managed_instances["example"].storage_size_in_gb == 32
    error_message = "Managed Instance storage_size_in_gb '${azurerm_mssql_managed_instance.managed_instances["example"].storage_size_in_gb}' does not match expected value '32'"
  }

  assert {
    condition     = azurerm_mssql_managed_instance.managed_instances["example"].vcores == 8
    error_message = "Managed Instance vcores '${azurerm_mssql_managed_instance.managed_instances["example"].vcores}' does not match expected value '8'"
  }
}
