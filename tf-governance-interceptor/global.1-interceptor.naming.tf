## Global Naming Interceptor
## =========================
## Functionality: Generate & validate names for resources based on the naming settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_global_naming_interceptor = local.pl_input_global_interceptor
}

locals {
  name_config_map = {
    for key, c in local.input_global_naming_interceptor : key => merge(c.name_config, {

      ## Determine naming mode, if parent_name is set, then child_naming_mode is used
      naming_mode   = try(c.name_config.parent_name, null) != null ? "child_naming" : "default_naming"
      resource_type = c.resource_type
      parent_name   = c.name_config.parent_name

      ## Only generate names if the resource supports naming
    }) if(try(c.nc_bypass, null) == null && try(c.name_config, null) != null)
  }
}

module "validate_name_configs" {
  source = "./validators"
  name_config_map = {
    for key, nc in local.name_config_map : key => {
      name_segments = try(nc.name_segments, null)

      ## Override global required name segments with resource specific required name segments 
      required_name_segments = try(local.resource_settings[nc.resource_type][nc.naming_mode].required_name_segments, local.global_settings[nc.naming_mode].required_name_segments)

      naming_mode   = nc.naming_mode
      resource_type = nc.resource_type
      parent_name   = nc.parent_name
    }
  }
}

locals {
  name_combination_map = {
    for key, nc in module.validate_name_configs.validated_name_config_map : key => {
      combination = [

        ## Override global name segment order with resource specific name segment order and add resource_type name segment 
        for ns in try(
          local.resource_settings[nc.resource_type][nc.naming_mode].name_segment_order,
          local.global_settings[nc.naming_mode].name_segment_order
          ) : merge(
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

  name_result_map = {

    ## Concatenate name segments with delimiter
    for key, nc in local.name_combination_map : key => join(
      try(
        local.resource_settings[nc.resource_type][nc.naming_mode].delimiter,
        local.global_settings[nc.naming_mode].delimiter,
      ), nc.combination
    )
  }

  intercepted_naming_configuration_map = {

    ## Inject name into configuration
    for key, c in local.input_global_naming_interceptor : key => merge(c, {

      ## If nc_bypass is set, then use the name from the nc_bypass, if a resource has no name_bypass set, than null is used (e.g. while using role_assignments etc.) 
      name = try(c.nc_bypass, null) != null ? c.nc_bypass : try(c.name_config, null) != null ? local.name_result_map[c.tf_id] : null
    })
  }
}

## Outputs
locals {
  output_global_naming_interceptor = local.intercepted_naming_configuration_map
}
