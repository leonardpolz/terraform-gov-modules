

module "mssql_managed_instance" {
  //source = "git::https://github.com/leonardpolz/terraform-governance-framework-core-modules.git//tf-az-mssql-managed-instance?ref=v1.0.0"
  source = "../tf-az-mssql-managed-instance"
  mssql_managed_instances = [{

    tf_id = "example"
    name_config = {
      values = {
        workload_name = "example-managed-instance"
        environment   = "tst"
      }
    }

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

    # role_assignments = [
    #   {
    #     principal_id         = "00000000-0000-0000-0000-000000000000"
    #     role_definition_name = "Contributor"
    #   },
    #   {
    #     principal_id         = "11111111-1111-1111-1111-111111111111"
    #     role_definition_name = "Reader"
    #   }
    # ]

  }]
}

output "mssql_managed_instance_config_map" {
  value = module.mssql_managed_instance.mssql_managed_instance_config_map
}
