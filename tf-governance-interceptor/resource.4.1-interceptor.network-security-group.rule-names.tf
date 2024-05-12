## Resource Route Table Rule Names
# ================================
# Functionality: Generate & validate route table rule names based on global and/or resource specific settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_network_security_group_rule_interceptor = local.pl_output_resource_virtual_network_interceptor
}

locals {
  nsg_rule_name_config_list = flatten([
    for nsg_id, nsg in local.input_resource_network_security_group_rule_interceptor : [
      for sr in try(nsg.security_rules, []) : merge(
        sr.name_config, {
          tf_id         = "${nsg_id}_${sr.tf_id}"
          naming_mode   = try(sr.name_config.parent_name, null) != null ? "child_naming" : "default_naming"
          resource_type = "Microsoft.Network/networkSecurityGroups/securityRules"
          parent_name   = sr.name_config.parent_name
        }
      ) if try(sr.nc_bypass, null) == null
    ] if nsg.resource_type == "Microsoft.Network/networkSecurityGroups"
  ])

  nsg_rule_name_config_map = { for nc in local.nsg_rule_name_config_list : nc.tf_id => nc }
}

module "validate_name_configs_nsg_rule" {
  source = "./validators"
  name_config_map = {
    for sr_id, nc in local.nsg_rule_name_config_map : sr_id => {
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
  nsg_rule_name_combination_map = {
    for sr_id, nc in module.validate_name_configs_nsg_rule.validated_name_config_map : sr_id => {
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

  nsg_rule_name_result_map = {

    ## Concatenate name segments with delimiter
    for sr_id, nc in local.nsg_rule_name_combination_map : sr_id => join(
      try(
        local.resource_settings[nc.resource_type][nc.naming_mode].delimiter,
        local.global_settings[nc.naming_mode].delimiter,
      ), nc.combination
    )
  }
}

## Outputs
locals {
  output_resource_network_security_rule_interceptor_names = local.nsg_rule_name_result_map
}
