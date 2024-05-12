variable "private_dns_zones" {
  type = set(object({
    tf_id = string

    name                = string
    resource_group_name = string
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
      tf_id   = string
      name    = string
      ttl     = number
      records = set(string)
      tags    = optional(map(string))
    })))
  }))
}
