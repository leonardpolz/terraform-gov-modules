## Resource Virtual Network Peering Names 
# ================================
# Functionality: Generate & validate nested virtual network peering names based on global and/or resource specific settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_virtual_network_peering_interceptor = local.pl_output_resource_private_endpoint_interceptor
}

locals {
  vnet_peering_name_config_list = flatten([
    for vnet_id, vnet in local.input_resource_virtual_network_peering_interceptor : [
      for vnetp in try(vnet.virtual_network_peerings, []) : merge(
        vnetp.name_config, {
          tf_id         = "${vnet_id}_${vnetp.tf_id}"
          naming_mode   = try(vnetp.name_config.parent_name, null) != null ? "child_naming" : "default_naming"
          resource_type = "Microsoft.Network/virtualNetworks/virtualNetworkPeerings"
          parent_name   = vnetp.name_config.parent_name
        }
      ) if try(vnetp.nc_bypass, null) == null
    ] if vnet.resource_type == "Microsoft.Network/virtualNetworks"
  ])

  vnet_peering_name_config_map = { for nc in local.vnet_peering_name_config_list : nc.tf_id => nc }
}

module "validate_name_configs_vnet_peering" {
  source = "./validators"
  name_config_map = {
    for vnetp_id, nc in local.vnet_peering_name_config_map : vnetp_id => {
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
  vnet_peering_name_combination_map = {
    for vnetp_id, nc in module.validate_name_configs_vnet_peering.validated_name_config_map : vnetp_id => {
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

  vnet_peering_name_result_map = {

    ## Concatenate name segments with delimiter
    for vnetp_id, nc in local.vnet_peering_name_combination_map : vnetp_id => join(
      try(
        local.resource_settings[nc.resource_type][nc.naming_mode].delimiter,
        local.global_settings[nc.naming_mode].delimiter,
      ), nc.combination
    )
  }
}

## Outputs
locals {
  output_resource_virtual_network_peering_interceptor_names = local.vnet_peering_name_result_map
}
