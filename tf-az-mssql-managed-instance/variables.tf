variable "mssql_managed_instances" {
  type = set(object({
    tf_id = string

    name_config = object({
      parent_name   = optional(string)
      name_segments = map(string)
    })

    nc_bypass = optional(string)

    administrator_login            = string
    administrator_login_password   = string
    license_type                   = optional(string)
    location                       = optional(string)
    resource_group_name            = string
    sku_name                       = optional(string)
    storage_size_in_gb             = string
    vcores                         = string
    collation                      = optional(string)
    dns_zone_partner_id            = optional(string)
    maintenance_configuration_name = optional(string)
    minimum_tls_version            = optional(string)
    proxy_override                 = optional(string)
    public_data_endpoint_enabled   = optional(string)
    storage_account_type           = optional(string)
    timezone_id                    = optional(string)
    tags                           = optional(map(string))

    role_assignments = optional(set(object({
      tf_id                                  = optional(string)
      principal_id                           = string
      name                                   = optional(string)
      role_definition_id                     = optional(string)
      role_definition_name                   = optional(string)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      description                            = optional(string)
      skip_service_principal_aad_check       = optional(bool)
    })))

    connectivity_settings = optional(object({
      subnet_id_bypass = optional(string)

      route_table_config = optional(object({
        parent_name = optional(string)

        name_config = optional(object({
          values = map(string)
        }))

        nc_bypass = optional(string)

        resource_group_name           = optional(string)
        location                      = optional(string)
        disable_bgp_route_propagation = optional(bool)
        tags                          = optional(map(string))


        routes = optional(set(object({
          tf_id = string

          name_config = object({
            values = map(string)
          })

          nc_bypass = optional(string)

          address_prefix         = string
          next_hop_type          = string
          next_hop_in_ip_address = optional(string)
        })))

        role_assignments = optional(set(object({
          tf_id                                  = optional(string)
          principal_id                           = string
          name                                   = optional(string)
          role_definition_id                     = optional(string)
          role_definition_name                   = optional(string)
          condition                              = optional(string)
          condition_version                      = optional(string)
          delegated_managed_identity_resource_id = optional(string)
          description                            = optional(string)
          skip_service_principal_aad_check       = optional(bool)
        })))
      }))

      virtual_network_config = optional(object({
        name_config = optional(object({
          values = map(string)
        }))

        nc_bypass = optional(string)

        resource_group_name     = optional(string)
        address_space           = optional(set(string))
        location                = optional(string)
        bgp_community           = optional(string)
        edge_zone               = optional(string)
        flow_timeout_in_minutes = optional(number)
        tags                    = optional(map(string))

        ddos_protection_plan = optional(object({
          id     = string
          enable = bool
        }))

        encryption = optional(object({
          enforcement = optional(string)
        }))

        dns_servers = optional(set(string))

        subnets = optional(set(object({
          tf_id = string

          name_config = object({
            values = map(string)
          })

          nc_bypass                                     = optional(string)
          address_prefixes                              = set(string)
          private_endpoint_network_policies_enabled     = optional(bool)
          private_link_service_network_policies_enabled = optional(bool)
          service_endpoints                             = optional(set(string))
          service_endpoint_policy_ids                   = optional(set(string))

          delegations = optional(set(object({
            name_config = object({
              values = map(string)
            })

            nc_bypass = optional(string)

            service_delegation = object({
              name    = string
              actions = optional(set(string))
            })
          })))

          network_security_group_settings = optional(object({
            name_config = object({
              values = map(string)
            })

            nc_bypass = optional(string)

            resource_group_name = optional(string)
            location            = optional(string)

            security_rules = optional(list(object({
              tf_id = string

              name_config = object({
                values = map(string)
              })

              nc_bypass = optional(string)

              description                                = string
              protocol                                   = string
              source_port_range                          = optional(string)
              source_port_ranges                         = optional(list(string))
              source_address_prefix                      = optional(string)
              source_address_prefixes                    = optional(list(string))
              source_application_security_group_ids      = optional(list(string))
              destination_port_range                     = optional(string)
              destination_port_ranges                    = optional(list(string))
              destination_address_prefix                 = optional(string)
              destination_address_prefixes               = optional(list(string))
              destination_application_security_group_ids = optional(list(string))
              access                                     = string
              priority                                   = string
              direction                                  = string
            })))

            role_assignments = optional(set(object({
              tf_id                                  = optional(string)
              principal_id                           = string
              name                                   = optional(string)
              role_definition_id                     = optional(string)
              role_definition_name                   = optional(string)
              condition                              = optional(string)
              condition_version                      = optional(string)
              delegated_managed_identity_resource_id = optional(string)
              description                            = optional(string)
              skip_service_principal_aad_check       = optional(bool)
            })))
          }))

          route_table_associations = optional(list(object({
            tf_id          = string
            route_table_id = string
          })))
        })))

        virtual_network_peerings = optional(set(object({
          tf_id = string

          name_config = object({
            values = map(string)
          })

          nc_bypass                    = optional(string)
          remote_virtual_network_id    = string
          allow_virtual_network_access = optional(bool)
          allow_forwarded_traffic      = optional(bool)
          use_remote_gateways          = optional(bool)
          triggers                     = optional(map(string))
        })))

        role_assignments = optional(set(object({
          tf_id                                  = optional(string)
          principal_id                           = string
          name                                   = optional(string)
          role_definition_id                     = optional(string)
          role_definition_name                   = optional(string)
          condition                              = optional(string)
          condition_version                      = optional(string)
          delegated_managed_identity_resource_id = optional(string)
          description                            = optional(string)
          skip_service_principal_aad_check       = optional(bool)
        })))
      }))

      sqlmi_subnet_config = optional(object({
        name_config = optional(object({
          values = map(string)
        }))

        nc_bypass                                     = optional(string)
        address_prefixes                              = optional(set(string))
        private_endpoint_network_policies_enabled     = optional(bool)
        private_link_service_network_policies_enabled = optional(bool)
        service_endpoints                             = optional(set(string))
        service_endpoint_policy_ids                   = optional(set(string))

        delegations = optional(set(object({
          name_config = object({
            values = map(string)
          })

          nc_bypass = optional(string)

          service_delegation = object({
            name    = string
            actions = optional(set(string))
          })
        })))

        network_security_group_settings = optional(object({
          name_config = object({
            values = map(string)
          })

          nc_bypass = optional(string)

          resource_group_name = optional(string)
          location            = optional(string)

          security_rules = optional(list(object({
            tf_id = string

            name_config = object({
              values = map(string)
            })

            nc_bypass = optional(string)

            description                                = string
            protocol                                   = string
            source_port_range                          = optional(string)
            source_port_ranges                         = optional(list(string))
            source_address_prefix                      = optional(string)
            source_address_prefixes                    = optional(list(string))
            source_application_security_group_ids      = optional(list(string))
            destination_port_range                     = optional(string)
            destination_port_ranges                    = optional(list(string))
            destination_address_prefix                 = optional(string)
            destination_address_prefixes               = optional(list(string))
            destination_application_security_group_ids = optional(list(string))
            access                                     = string
            priority                                   = string
            direction                                  = string
          })))

          role_assignments = optional(set(object({
            tf_id                                  = optional(string)
            principal_id                           = string
            name                                   = optional(string)
            role_definition_id                     = optional(string)
            role_definition_name                   = optional(string)
            condition                              = optional(string)
            condition_version                      = optional(string)
            delegated_managed_identity_resource_id = optional(string)
            description                            = optional(string)
            skip_service_principal_aad_check       = optional(bool)
          })))
        }))

        route_table_associations = optional(list(object({
          tf_id          = string
          route_table_id = string
        })))
      }))

      private_endpoints = optional(set(object({
        tf_id = string

        private_endpoint_config = object({
          name_config = optional(object({
            values = map(string)
          }))

          nc_bypass = optional(string)

          resource_group_name = optional(string)
          location            = optional(string)
          subnet_id           = string

          custom_network_interface_name_config = optional(object({
            values = map(string)
          }))

          custom_network_interface_nc_bypass = optional(string)

          tags = optional(map(string))

          private_dns_zone_group = optional(object({
            name_config = optional(object({
              values = map(string)
            }))

            nc_bypass = optional(string)

            private_dns_zone_ids = set(string)
          }))

          private_service_connection = optional(object({
            name_config = optional(object({
              values = map(string)
            }))

            nc_bypass = optional(string)

            is_manual_connection = optional(bool, false)
            request_message      = optional(string)
          }))

          ip_configuration = optional(object({
            name_config = optional(object({
              values = map(string)
            }))

            nc_bypass = optional(string)

            private_ip_address = string
            member_name        = optional(string)
          }))

          role_assignments = optional(set(object({
            tf_id                                  = optional(string)
            principal_id                           = string
            name                                   = optional(string)
            role_definition_id                     = optional(string)
            role_definition_name                   = optional(string)
            condition                              = optional(string)
            condition_version                      = optional(string)
            delegated_managed_identity_resource_id = optional(string)
            description                            = optional(string)
            skip_service_principal_aad_check       = optional(bool)
          })))
        })

        private_endpoint_dns_zone_config = optional(object({
          resource_group_name = optional(string)
          tags                = optional(map(string))

          role_assignments = optional(set(object({
            tf_id                                  = optional(string)
            principal_id                           = string
            name                                   = optional(string)
            role_definition_id                     = optional(string)
            role_definition_name                   = optional(string)
            condition                              = optional(string)
            condition_version                      = optional(string)
            delegated_managed_identity_resource_id = optional(string)
            description                            = optional(string)
            skip_service_principal_aad_check       = optional(bool)
          })))

          soa_record = optional(object({
            email        = string
            expire_time  = optional(number)
            minimum_ttl  = optional(number)
            refresh_time = optional(number)
            retry_time   = optional(number)
            ttl          = optional(number)
            tags         = optional(map(string))
          }))

          a_records = optional(set(object({
            tf_id               = string
            name                = string
            resource_group_name = optional(string)
            ttl                 = number
            records             = set(string)
            tags                = optional(map(string))
          })))
        }))
      })))
    }))
  }))
}
