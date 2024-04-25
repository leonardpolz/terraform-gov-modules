module "private_endpoint" {
  //source = "git::https://github.com/leonardpolz/terraform-governance-framework-core-modules.git//tf-az-private-endpoint?ref=v1.0.0"
  source = "../tf-az-private-endpoint"
  private_endpoints = [{
    tf_id = "example"
    name_config = {
      values = {
        workload_name = "exampleprivateendpoint"
        environment   = "tst"
      }
    }

    role_assignments = [
      {
        principal_id         = "00000000-0000-0000-0000-000000000000"
        role_definition_name = "Contributor"
      },
      {
        principal_id         = "11111111-1111-1111-1111-111111111111"
        role_definition_name = "Reader"
      }
    ]

    tags = {
      terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
      deployed_by              = "Leonard Polz"
      hidden-title             = "Test Private Endpoint"
    }

    resource_group_name = "test-rg"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"

    private_service_connection = {
      private_connection_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network/subnets/snet-mock-subnet"
    }
  }]
}

output "private_endpoint_config" {
  value = module.private_endpoint.private_endpoint_config_map
}

