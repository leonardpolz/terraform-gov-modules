variable "role_assignments" {
  type = list(object({
    tf_id                                  = string
    parent_name                            = optional(string)
    scope                                  = string
    principal_id                           = string
    name                                   = optional(string)
    role_definition_id                     = optional(string)
    role_definition_name                   = optional(string)
    condition                              = optional(string)
    condition_version                      = optional(string)
    delegated_managed_identity_resource_id = optional(string)
    description                            = optional(string)
    skip_service_principal_aad_check       = optional(bool)

    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      delete = optional(string)
    }))
  }))

  default = []
}
