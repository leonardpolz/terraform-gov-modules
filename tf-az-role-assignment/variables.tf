variable "role_assignments" {
  type = set(object({
    tf_id                                  = string
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
  }))

  default = []
}
