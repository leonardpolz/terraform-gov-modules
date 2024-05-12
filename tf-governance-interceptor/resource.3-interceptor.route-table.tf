## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_route_table_interceptor = local.pl_output_resource_virtual_network_interceptor
}

locals {
  intercepted_route_table_configuration_map_route = {
    for rt_id, c in local.input_resource_route_table_interceptor : rt_id => merge(
      c, c.resource_type != "Microsoft.Network/routeTables" ? {} : {
        routes = {
          for r in try(c.routes, null) != null ? c.routes : [] : r.tf_id => merge(
            r, {

              ## Inject route name into configuration
              ## Reference from resource.3.1-interceptor.route-table.route_names.tf
              name = r.nc_bypass != null ? r.nc_bypass : local.output_resource_route_table_route_interceptor_names["${rt_id}_${r.tf_id}"]
            }
          )
        }
      }
    )
  }

  output_resource__route_table_interceptor = local.intercepted_route_table_configuration_map_route
}

## Outputs
locals {
  output_resource_route_table_interceptor = local.output_resource__route_table_interceptor
}

