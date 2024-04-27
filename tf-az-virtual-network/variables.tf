variable "virtual_networks" {
  type = set(object({
    tf_id       = string
    parent_name = optional(string)

    name_config = object({
      values = map(string)
    })

    nc_bypass = optional(string)

    resource_group_name     = string
    address_space           = set(string)
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
        }), {
        name_config = {
          values = {}
        }
      })

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

  default = []
}
