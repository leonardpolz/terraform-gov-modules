variable "resource_groups" {
  type = set(object({
    tf_id = string

    name_config = object({
      parent_name   = optional(string)
      name_segments = map(string)
    })

    nc_bypass = optional(string)

    location   = optional(string)
    managed_by = optional(string)
    tags       = optional(map(string))

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
