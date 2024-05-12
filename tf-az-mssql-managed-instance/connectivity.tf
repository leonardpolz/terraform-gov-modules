module "route_tables" {
  source = "../tf-az-route-table"
  route_tables = [
    for key, sqlmi in local.managed_instance_map : merge(
      try(sqlmi.connectivity_settings.route_table_config, {}), {
        tf_id = key
        name_config = try(sqlmi.connectivity_settings.route_table_config.name_config, null) != null ? sqlmi.connectivity_settings.route_table_config.name_config : {
          name_segments = {}
          parent_name   = sqlmi.name
        }

        resource_group_name           = try(sqlmi.connectivity_settings.route_table_config.resource_group_name, null) != null ? sqlmi.connectivity_settings.route_table_config.resource_group_name : sqlmi.resource_group_name
        disable_bgp_route_propagation = false
    }) if try(sqlmi.connectivity_settings.subnet_id.bypass, null) == null
  ]
}

locals {
  sqlmi_subnet_configs = {
    for key, sqlmi in local.managed_instance_map : key => merge(
      try(sqlmi.connectivity_settings.sqlmi_subnet_config, {}), {
        tf_id = key
        name_config = {
          name_segments = try(sqlmi.connectivity_settings.sqlmi_subnet_config.name_config.name_segments, null) != null ? sqlmi.connectivity_settings.sqlmi_subnet_config.name_config.name_segments : {}
          parent_name   = sqlmi.name
        }

        route_table_associations = concat(
          try(sqlmi.connectivity_settings.sqlmi_subnet_config.route_table_associations, []), [
            {
              tf_id          = "sqlmi_rt"
              route_table_id = module.route_tables.route_tables[key].id
            }
          ]
        )

        delegations = concat(
          try(sqlmi.connectivity_settings.sqlmi_subnet_config.delegations, []), [
            {
              tf_id = "sqlmi_delegation"

              name_config = {
                name_segments = {}
                parent_name   = sqlmi.name
              }

              service_delegation = {
                name    = "Microsoft.Sql/managedInstances"
                actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
              }
            }
          ]
        )
      }
    )
  }
}

module "virtual_networks" {
  source = "../tf-az-virtual-network"
  virtual_networks = [
    for key, sqlmi in local.managed_instance_map : merge(
      try(sqlmi.connectivity_settings.virtual_network_config, {}), {
        tf_id = key
        name_config = {
          name_segments = try(sqlmi.connectivity_settings.virtual_network_config.name_config.name_segments, null) != null ? sqlmi.connectivity_settings.virtual_network_config.name_config.name_segments : {}
          parent_name   = sqlmi.name
        }

        subnets = [
          local.sqlmi_subnet_configs[key]
        ]

        resource_group_name = try(sqlmi.connectivity_settings.virtual_network_config.resource_group_name, null) != null ? sqlmi.connectivity_settings.virtual_network_config.resource_group_name : sqlmi.resource_group_name
    }) if try(sqlmi.connectivity_settings.subnet_id.bypass, null) == null
  ]

  depends_on = [module.route_tables]
}

locals {
  private_endpoint_list = flatten([
    for key, sqlmi in local.managed_instance_map : [
      for pep in sqlmi.connectivity_settings.private_endpoints : merge(
        pep, {
          tf_id       = "${sqlmi.tf_id}_${pep.tf_id}"
          sqlmi_tf_id = key
        }
      )
    ] if try(sqlmi.connectivity_settings.private_endpoints, null) != null
  ])
}

module "private_endpoints" {
  source = "../tf-az-private-endpoint"

  private_endpoints = [
    for key, pep in local.private_endpoint_list : merge(
      pep.private_endpoint_config, {
        tf_id = pep.tf_id

        name_config = try(pep.private_endpoint_config.name_config, null) != null ? pep.private_endpoint_config.name_config : {
          tf_id       = pep.tf_id
          parent_name = azurerm_mssql_managed_instance.managed_instances[pep.sqlmi_tf_id].name
        }

        resource_group_name = try(pep.private_endpoint_config.resource_group_name, null) != null ? pep.private_endpoint_config.resource_group_name : azurerm_mssql_managed_instance.managed_instances[pep.sqlmi_tf_id].resource_group_name
        location            = try(pep.private_endpoint_config.location, null) != null ? pep.private_endpoint_config.location : azurerm_mssql_managed_instance.managed_instances[pep.sqlmi_tf_id].location


        private_service_connection = merge(
          try(pep.private_endpoint_config.private_service_connection, {}), {
            private_connection_resource_id = azurerm_mssql_managed_instance.managed_instances[pep.sqlmi_tf_id].id
            subresource_names              = ["managedInstance"]
          }
        )

        ip_configuration = pep.private_endpoint_config.ip_configuration == null ? null : merge(
          pep.private_endpoint_config.ip_configuration, {
            subresource_name   = "managedInstance"
            private_ip_address = try(pep.private_endpoint_config.ip_configuration.private_ip_address, "")
          }
        )
      }
    )
  ]
}

locals {
  managed_instance_fqdns = distinct([
    for key, pep in local.private_endpoint_list : split(".", azurerm_mssql_managed_instance.managed_instances[pep.sqlmi_tf_id].fqdn)
  ])
}

module "private_dns_zone" {
  source = "../tf-az-private-dns-zone"
  private_dns_zones = [
    for key, pep in local.private_endpoint_list : merge(
      pep.private_endpoint_dns_zone_config, {
        tf_id = pep.tf_id

        name                = "${local.managed_instance_fqdns[key][0]}.privatelink.${local.managed_instance_fqdns[key][2]}.database.windows.net"
        resource_group_name = try(pep.private_endpoint_dns_zone_config.resource_group_name, null) != null ? pep.private_endpoint_dns_zone_config.resource_group_name : azurerm_mssql_managed_instance.managed_instances[pep.sqlmi_tf_id].resource_group_name
        location            = try(pep.private_endpoint_dns_zone_config.location, null) != null ? pep.private_endpoint_dns_zone_config.location : azurerm_mssql_managed_instance.managed_instances[pep.sqlmi_tf_id].location

        a_records = concat(
          try(pep.private_endpoint_dns_zone_config.a_records, []), [
            {
              tf_id = "${pep.tf_id}_sqlmi_record"
              name  = "@"
              ttl   = 300
              records = [
                module.private_endpoints.private_endpoints[pep.tf_id].private_service_connection[0].private_ip_address
              ]
            }
          ]
        )
      }
    )
  ]
}
