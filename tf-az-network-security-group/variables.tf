variable "network_security_groups" {
  type = set(object({
    tf_id       = string
    parent_name = optional(string)

    name_config = object({
      values = map(string)
    })

    nc_bypass = optional(string)

    resource_group_name = string
    location            = optional(string)
    tags                = optional(map(string))

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

  default = []
}