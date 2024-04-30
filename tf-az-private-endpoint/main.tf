module "configuration_interceptor" {
  source = "../tf-governance-interceptor-facade"
  configurations = [for pep in var.private_endpoints : {
    tf_id                = pep.tf_id
    resource_type        = "Microsoft.Network/privateEndpoints"
    resource_config_json = jsonencode(pep)
    }
  ]
}

locals {
  private_endpoint_map = {
    for pep in var.private_endpoints : pep.tf_id => merge(
      pep, {
        name                          = module.configuration_interceptor.configuration_map[pep.tf_id].name
        custom_network_interface_name = module.configuration_interceptor.configuration_map[pep.tf_id].custom_network_interface_name
        tags                          = module.configuration_interceptor.configuration_map[pep.tf_id].tags
        location                      = module.configuration_interceptor.configuration_map[pep.tf_id].location

        private_dns_zone_group = pep.private_dns_zone_group == null ? null : merge(
          pep.private_dns_zone_group, {
            name = module.configuration_interceptor.configuration_map[pep.tf_id].private_dns_zone_group.name
          }
        )

        private_service_connection = pep.private_service_connection == null ? null : merge(
          pep.private_service_connection, {
            name = module.configuration_interceptor.configuration_map[pep.tf_id].private_service_connection.name
        })

        ip_configuration = pep.ip_configuration == null ? null : merge(
          pep.ip_configuration, {
            name = module.configuration_interceptor.configuration_map[pep.tf_id].ip_configuration.name
          }
        )
      }
    )
  }
}

resource "azurerm_private_endpoint" "private_endpoints" {
  for_each                      = local.private_endpoint_map
  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = each.value.custom_network_interface_name
  tags                          = each.value.tags

  dynamic "private_dns_zone_group" {
    for_each = each.value.private_dns_zone_group != null ? [each.value.private_dns_zone_group] : []
    content {
      name                 = private_dns_zone_group.value.name
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }

  dynamic "private_service_connection" {
    for_each = each.value.private_service_connection != null ? [each.value.private_service_connection] : []
    content {
      name                              = private_service_connection.value.name
      is_manual_connection              = private_service_connection.value.is_manual_connection
      private_connection_resource_id    = private_service_connection.value.private_connection_resource_id
      private_connection_resource_alias = private_service_connection.value.private_connection_resource_alias
      subresource_names                 = private_service_connection.value.subresource_names
      request_message                   = private_service_connection.value.request_message
    }
  }

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration != null ? [each.value.ip_configuration] : []
    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = ip_configuration.value.subresource_name
      member_name        = ip_configuration.value.member_name
    }
  }
}

module "role_assignments" {
  source = "../tf-az-role-assignment"
  role_assignments = flatten([
    for key, pep in local.private_endpoint_map : [
      for ra in pep.role_assignments : merge(ra, {
        tf_id       = ra.tf_id != null ? ra.tf_id : "${key}_${ra.principal_id}_${ra.role_definition_name != null ? replace(ra.role_definition_name, " ", "_") : ra.role_definition_id}"
        parent_name = pep.name
        scope       = azurerm_private_endpoint.private_endpoints[key].id
      })
    ] if pep.role_assignments != null
  ])
}

