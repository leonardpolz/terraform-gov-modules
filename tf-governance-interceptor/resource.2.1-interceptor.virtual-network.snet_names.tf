## Resource Virtual Network Subnet Names
# ================================
# Functionality: Generate & validate nested virtual network subnet names based on global and/or resource specific settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_virtual_network_subnet_interceptor = local.pl_output_resource_private_endpoint_interceptor
}

locals {
  subnet_name_config_list = flatten([
    for vnet_id, vnet in local.input_resource_virtual_network_subnet_interceptor : [
      for snet in try(vnet.subnets, null) != null ? vnet.subnets : [] : merge(snet.name_config, {

        tf_id         = "${vnet_id}_${snet.tf_id}"
        naming_mode   = try(snet.name_config.parent_name, null) != null ? "child_naming" : "default_naming"
        resource_type = "Microsoft.Network/virtualNetworks/subnets"
        parent_name   = snet.name_config.parent_name
      }) if try(snet.nc_bypass, null) == null
    ] if vnet.resource_type == "Microsoft.Network/virtualNetworks"
  ])

  subnet_name_config_map = { for nc in local.subnet_name_config_list : nc.tf_id => nc }
}

module "validate_name_configs_subnet" {
  source = "./validators"
  name_config_map = {
    for snet_id, nc in local.subnet_name_config_map : snet_id => {
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
  subnet_name_combination_map = {
    for snet_id, nc in module.validate_name_configs_subnet.validated_name_config_map : snet_id => {
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

  subnet_name_result_map = {

    ## Concatenate name segments with delimiter
    for snet_id, nc in local.subnet_name_combination_map : snet_id => join(
      try(
        local.resource_settings[nc.resource_type][nc.naming_mode].delimiter,
        local.global_settings[nc.naming_mode].delimiter,
      ), nc.combination
    )
  }
}

## Outputs
locals {
  output_resource_virtual_network_subnet_interceptor_names = local.subnet_name_result_map
}
