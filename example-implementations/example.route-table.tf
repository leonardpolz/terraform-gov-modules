module "route_table" {
  // source = "git::https://github.com/leonardpolz/terraform-governance-framework-core-modules.git//tf-az-route-table?ref=v1.0.0"
  source = "../tf-az-route-table"
  route_tables = [{
    tf_id = "example_route_table"

    name_config = {
      values = {
        workload_name = "example"
        environment   = "tst"
      }
    }

    tags = {
      terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
      deployed_by              = "Leonard Polz"
      hidden-title             = "Test Route Table"
    }

    resource_group_name = "example_rg"

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

    routes = [{
      tf_id = "example_route"

      name_config = {
        values = {
          workload_name = "example"
          environment   = "tst"
        }
      }

      address_prefix         = "0.0.0.0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "8.8.8.8"
    }]
  }]
}

output "route_table_config" {
    value = module.route_table.route_table_config_map
}
