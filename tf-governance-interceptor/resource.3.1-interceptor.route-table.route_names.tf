## Resource Route Table Rule Names
# ================================
# Functionality: Generate & validate route table rule names based on global and/or resource specific settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_route_table_route_interceptor = local.pl_output_resource_virtual_network_interceptor
}

locals {
  route_table_route_name_config_list = flatten([
    for rt_id, rt in local.input_resource_route_table_route_interceptor : [
      for r in try(rt.routes, []) : merge(
        r.name_config, {
          tf_id         = "${rt_id}_${r.tf_id}"
          naming_mode   = try(r.name_config.parent_name, null) != null ? "child_naming" : "default_naming"
          resource_type = "Microsoft.Network/routeTables/routes"
          parent_name   = r.name_config.parent_name
        }
      ) if try(r.nc_bypass, null) == null
    ] if rt.resource_type == "Microsoft.Network/routeTables"
  ])

  route_table_route_name_config_map = { for nc in local.route_table_route_name_config_list : nc.tf_id => nc }
}

module "validate_name_configs_route_table_route" {
  source = "./validators"
  name_config_map = {
    for r_id, nc in local.route_table_route_name_config_map : r_id => {
      name_segments = nc.name_segments

      ## Override global required name segments with resource specific required name segments 
      required_name_segments = try(local.resource_settings[nc.resource_type][nc.naming_mode].required_name_segments, local.global_settings[nc.naming_mode].required_name_segments)

      parent_name   = nc.parent_name
      naming_mode   = nc.naming_mode
      resource_type = nc.resource_type
    }
  }
}

locals {
  route_table_route_name_combination_map = {
    for r_id, nc in module.validate_name_configs_route_table_route.validated_name_config_map : r_id => {
      combination = [

        ## Override global name segment order with resource specific name segment order and add resource_type name segment 
        for ns in try(
          local.resource_settings[nc.resource_type][nc.naming_mode].name_segment_order,
          local.global_settings[nc.naming_mode].name_segment_order
        )
        : merge(
          nc.name_segments,
          {
            resource_abbreviation = local.resource_settings[nc.resource_type].abbreviation
            parent_name           = nc.parent_name
          }
        )[ns]
      ]

      naming_mode   = nc.naming_mode
      resource_type = nc.resource_type
    }
  }

  route_table_route_name_result_map = {

    ## Concatenate name segments with delimiter
    for r_id, nc in local.route_table_route_name_combination_map : r_id => join(
      try(
        local.resource_settings[nc.resource_type][nc.naming_mode].delimiter,
        local.global_settings[nc.naming_mode].delimiter,
      ), nc.combination
    )
  }
}

## Outputs
locals {
  output_resource_route_table_route_interceptor_names = local.route_table_route_name_result_map
}
