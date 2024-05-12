## Resource Virtual Network Interceptor
# ================================
# Functionality: Generate & validate nested virtual network configuration based on global and/or resource specific settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_virtual_network_interceptor = local.pl_output_resource_private_endpoint_interceptor
}

locals {
  intercepted_virtual_network_configuration_map_snet = {
    for vnet_id, c in local.input_resource_virtual_network_interceptor : vnet_id => merge(
      c, c.resource_type != "Microsoft.Network/virtualNetworks" ? {} : {
        subnets = {
          for snet in try(c.subnets, null) != null ? c.subnets : [] : snet.tf_id => merge(
            snet, {

              ## Inject subnet name into configuration
              ## Reference from resource.2.1-interceptor.virtual-network.snet_names.tf
              name = snet.nc_bypass != null ? snet.nc_bypass : local.output_resource_virtual_network_subnet_interceptor_names["${vnet_id}_${snet.tf_id}"]

              delegations = [
                for del_index, del in try(snet.delegations, null) != null ? snet.delegations : [] : merge(
                  del, {

                    ## Inject subnet delegation name into configuration
                    ## Reference from resource.2.2-interceptor.virtual-network.snet_delegation_names.tf
                    name = del.nc_bypass != null ? del.nc_bypass : local.output_resource_virtual_network_subnet_delegation_interceptor_names["${vnet_id}_${snet.tf_id}_${del_index}"]
                  }
                )
              ]

              network_security_group_settings = merge(
                snet.network_security_group_settings, {
                  tags = merge(
                    try(snet.network_security_group_settings.tags, null) != null ? snet.network_security_group_settings.tags : {}, merge(
                      c.tags, {

                        ## Inject network security group hidden title into configuration to help traceability of parent resource
                        ## Reference from resource.2.1-interceptor.virtual-network.snet_names.tf
                        hidden-title = "Network Security Group for Subnet ${c.name}/${snet.nc_bypass != null ? snet.nc_bypass : local.output_resource_virtual_network_subnet_interceptor_names["${vnet_id}_${snet.tf_id}"]}"
                      }
                    )
                  )
                }
              )
            }
          )
        }
      }
    )
  }

  intercepted_virtual_network_configuration_map_vnetp = {
    for vnet_id, c in local.intercepted_virtual_network_configuration_map_snet : vnet_id => merge(
      c, c.resource_type != "Microsoft.Network/virtualNetworks" ? {} : {
        virtual_network_peerings = {
          for vnetp in try(c.virtual_network_peerings, null) != null ? c.virtual_network_peerings : [] : vnetp.tf_id => merge(
            vnetp, {

              ## Inject virtual network peering name into configuration
              ## Reference from resource.2.3-interceptor.virtual-network.vnetp_names.tf
              name = vnetp.nc_bypass != null ? vnetp.nc_bypass : local.output_resource_virtual_network_peering_interceptor_names["${vnet_id}_${vnetp.tf_id}"]
            }
          )
        }
      }
    )
  }

  intercepted_virtual_network_configuration_map = local.intercepted_virtual_network_configuration_map_vnetp
}

## Outputs
locals {
  output_resource__virtual_network_interceptor = local.intercepted_virtual_network_configuration_map
}
