## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_network_security_group_interceptor = local.pl_output_resource_route_table_interceptor
}

locals {
  intercepted_network_security_group_configuration_map_route = {
    for nsg_id, c in local.input_resource_network_security_group_interceptor : nsg_id => merge(
      c, c.resource_type != "Microsoft.Network/networkSecurityGroups" ? {} : {
        security_rules = {
          for sr in try(c.security_rules, null) != null ? c.security_rules : [] : sr.tf_id => merge(
            sr, {

              ## Inject network security rule name into configuration
              ## Reference from resource.4.1-interceptor.network-security-group.rule-names.tf
              name = sr.nc_bypass != null ? sr.nc_bypass : local.output_resource_network_security_rule_interceptor_names["${nsg_id}_${sr.tf_id}"]
            }
          )
        }
      }
    )
  }

  intercepted_network_security_group_configuration_map = local.intercepted_network_security_group_configuration_map_route
}

## Outputs
locals {
  output_resource_network_security_group_interceptor = local.intercepted_network_security_group_configuration_map
}
