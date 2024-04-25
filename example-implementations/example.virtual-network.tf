
module "virtual_network" {
  //source = "git::https://github.com/leonardpolz/terraform-governance-framework-core-modules.git//tf-az-virtual-network?ref=v1.0.0"
  source = "../tf-az-virtual-network"
  virtual_networks = [
    {
      tf_id = "test_vnet"

      name_config = {
        values = {
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

      dns_servers = ["8.8.8.8"]

        subnets = [{
          tf_id = "default"

          name_config = {
            values = {
                workload_name = "default"
            }
          }

          address_prefixes = ["0.0.0.0/24"]

          delegations = [{
            name_config = {
              values = {
                workload_name = "default"
              }
            }

            service_delegation = {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          }]
        }]

        virtual_network_peerings = [{
          tf_id = "test_vnet_peering"

          name_config = {
            values = {
              workload_name = "test-vnet-peering"
            }
          }

          remote_virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock-group/providers/Microsoft.Network/virtualNetworks/vnet-mock-network"
        }]
    },
  ]
}

output "virtual_network_config" {
    value = module.virtual_network.virtual_network_config_map
}