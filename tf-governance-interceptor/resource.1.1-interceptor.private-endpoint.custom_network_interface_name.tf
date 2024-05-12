## Resource Private Endpoint Network Interface Interceptor
# ================================
# Functionality: Generate & validate network interface names based on global and/or resource specific settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_private_endpoint_network_interface_interceptor = local.pl_input_resource_interceptor
}

locals {
  network_interface_name_config_map = {
    for pep_id, pep in local.input_resource_private_endpoint_network_interface_interceptor : pep_id => merge(
      try(pep.custom_network_interface_name_config, {}), {

        ## Naming mode is always child_naming for network interfaces
        parent_name   = try(pep.nc_bypass, null) != null ? pep.nc_bypass : pep.name
        naming_mode   = "child_naming"
        resource_type = "Microsoft.Network/virtualNetworks/networkInterfaces"
    }) if try(pep.nc_bypass, null) == null && pep.resource_type == "Microsoft.Network/privateEndpoints"
  }
}

module "validate_name_configs_network_interface" {
  source = "./validators"
  name_config_map = {
    for pep_id, nc in local.network_interface_name_config_map : pep_id => {
      name_segments = try(nc.name_segments, null)

      ## Override global required name segments with resource specific required name segments 
      required_name_segments = try(local.resource_settings[nc.resource_type][nc.naming_mode].required_name_segments, local.global_settings[nc.naming_mode].required_name_segments)

      parent_name   = nc.parent_name
      naming_mode   = nc.naming_mode
      resource_type = nc.resource_type
    }
  }
}

locals {
  network_interface_name_combination_map = {
    for pep_id, nc in module.validate_name_configs_network_interface.validated_name_config_map : pep_id => {
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

  network_interface_name_result_map = {

    ## Concatenate name segments with delimiter
    for pep_id, nc in local.network_interface_name_combination_map : pep_id => join(
      try(
        local.resource_settings[nc.resource_type][nc.naming_mode].delimiter,
        local.global_settings[nc.naming_mode].delimiter,
      ), nc.combination
    )
  }
}

## Outputs
locals {
  output_resource_private_endpoint_network_interface_interceptor_names = local.network_interface_name_result_map
}

