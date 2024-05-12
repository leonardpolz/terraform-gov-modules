# Resource Private Endpoint Interceptor
# ================================
# Functionality: Generate & validate nested private endpoint configuration based on global and/or resource specific settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_resource_private_endpoint_interceptor = local.pl_input_resource_interceptor
}

locals {

  private_endpoint_config_map_custom_network_interface_name = {
    for pep_id, c in local.input_resource_private_endpoint_interceptor : pep_id => merge(
      c, c.resource_type != "Microsoft.Network/privateEndpoints" ? {} : {

        ## Inject network interface name into configuration
        ## Reference from resource.1.1-interceptor.private-endpoint.custom_network_interface_name.tf
        custom_network_interface_name = try(c.custom_network_interface_nc_bypass, null) != null ? c.custom_network_interface_nc_bypass : try(local.output_resource_private_endpoint_network_interface_interceptor_names[pep_id], null)
      }
    )
  }

  intercepted_private_endpoint_configuration_map_private_dns_zone_group = {
    for pep_id, c in local.private_endpoint_config_map_custom_network_interface_name : pep_id => merge(
      c, c.resource_type != "Microsoft.Network/privateEndpoints" ? {} : {
        private_dns_zone_group = try(c.private_dns_zone_group, null) == null ? null : merge(c.private_dns_zone_group, {

          ## Inject private DNS zone group name into configuration 
          ## There always is only one private DNS zone group per private endpoint, why the name does not need to be configurable 
          name = c.private_dns_zone_group.nc_bypass != null ? c.private_dns_zone_group.nc_bypass : "pdzg-${c.nc_bypass != null ? c.nc_bypass : c.name}"
        })
      }
    )
  }

  intercepted_private_endpoint_configuration_map_private_service_connection = {
    for pep_id, c in local.intercepted_private_endpoint_configuration_map_private_dns_zone_group : pep_id => merge(
      c, c.resource_type != "Microsoft.Network/privateEndpoints" ? {} : {
        private_service_connection = try(c.private_service_connection, null) == null ? null : merge(c.private_service_connection, {

          ## Inject private service connection name into configuration
          ## There always is only one private service connection per private endpoint, why the name does not need to be configurable 
          name = c.private_service_connection.nc_bypass != null ? c.private_service_connection.nc_bypass : "psc-${c.nc_bypass != null ? c.nc_bypass : c.name}"
        })
      }
    )
  }

  intercepted_private_endpoint_configuration_map_ip_configuration = {
    for pep_id, c in local.intercepted_private_endpoint_configuration_map_private_service_connection : pep_id => merge(
      c, c.resource_type != "Microsoft.Network/privateEndpoints" ? {} : {
        ip_configuration = try(c.ip_configuration, null) == null ? null : merge(c.ip_configuration, {

          ## Inject IP configuration name into configuration
          ## There always is only one IP configuration per private endpoint, why the name does not need to be configurable 
          name = c.ip_configuration.nc_bypass != null ? c.ip_configuration.nc_bypass : "ipc-${c.nc_bypass != null ? c.nc_bypass : c.name}"
        })
      }
    )
  }

  intercepted_private_endpoint_configuration_map = local.intercepted_private_endpoint_configuration_map_ip_configuration
}

## Outputs
locals {
  output_resource__private_endpoint_interceptor = local.intercepted_private_endpoint_configuration_map
}
