## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_mssql_managed_instance_interceptor = local.pl_output_resource_network_security_group_interceptor
}

locals {
  intercepted_mssql_managed_instance_configuration_map = {
    for key, c in local.input_resource_mssql_managed_instance_interceptor : key => merge(
      c, c.resource_type != "Microsoft.Sql/managedInstances" ? {} : {
        connectivity_settings = merge(
          c.connectivity_settings, {
            route_table_config = merge(
              try(c.connectivity_settings.route_table_config, {}), {
                tags = merge(
                  try(c.connectivity_settings.route_table_config.tags, {}), merge(
                    c.tags, {

                      ## Inject route table hidden title into configuration to help traceability of parent resource
                      hidden-title = "Route Table for Managed Instance ${c.name}"
                    }
                  )
                )
              }
            )

            virtual_network_config = merge(
              try(c.connectivity_settings.virtual_network_config, {}), {
                address_space = try(c.connectivity_settings.virtual_network_config.address_space, null) != null ? c.connectivity_settings.virtual_network_config.address_space : ["10.0.0.0/24"]
                tags = merge(
                  try(c.connectivity_settings.virtual_network_config.tags, {}), merge(
                    c.tags, {

                      ## Inject virtual network hidden title into configuration to help traceability of parent resource
                      hidden-title = "Virtual Network for Managed Instance ${c.name}"
                    }
                  )
                )
              }
            )

            sqlmi_subnet_config = merge(
              try(c.connectivity_settings.sqlmi_subnet_config, {}), {
                name_config = try(c.connectivity_settings.sqlmi_subnet_config.name_config, null) != null ? c.connectivity_settings.sqlmi_subnet_config.name_config : {
                  values = {
                    workload_name = c.name
                  }
                },
                address_prefixes = try(c.connectivity_settings.sqlmi_subnet_config.address_space, null) != null ? c.connectivity_settings.sqlmi_subnet_config.address_space : ["10.0.0.0/25"]
              }
            )

            private_endpoints = [
              for pep in c.connectivity_settings.private_endpoints != null ? c.connectivity_settings.private_endpoints : [] : merge(
                pep, {
                  private_endpoint_config = merge(
                    pep.private_endpoint_config, {
                      tags = merge(
                        try(pep.private_endpoint_config.tags, {}), merge(
                          c.tags, {

                            ## Inject private endpoint hidden title into configuration to help traceability of parent resource
                            hidden-title = "Private Endpoint for Managed Instance ${c.name}"
                          }
                        )
                      )
                    }
                  )
                }
              )
            ]
          }
        )
      }
    )
  }
}

## Outputs
locals {
  output_resource_mssql_managed_instance_interceptor = local.intercepted_mssql_managed_instance_configuration_map
}
