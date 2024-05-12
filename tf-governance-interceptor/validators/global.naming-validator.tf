variable "name_config_map" {
  type = map(object({
    required_name_segments = map(object({
      regex_requirements = string
      nullable           = bool
    }))

    name_segments = optional(map(string), {})

    naming_mode   = string
    resource_type = string
    parent_name   = optional(string)
  }))

  // Validate that all name_configs meet the requirements of the required_name_segments 
  validation {
    condition = alltrue(
      flatten([
        for nc in var.name_config_map : [
          for name, rns in nc.required_name_segments : (rns.nullable && contains(keys(nc.name_segments), name) == false) || (contains(keys(nc.name_segments), name) && can(regex(rns.regex_requirements, nc.name_segments[name])))
        ]
      ])
    )

    error_message = "All name_configs must meet the requirements of the required_name_segments: ${join(", ", [
      for nc in var.name_config_map : jsonencode(nc.required_name_segments)
      ])}; Got: ${join(", ", [
      for nc in var.name_config_map : jsonencode(nc.name_segments)
    ])}"
  }

  default = {}
}

output "validated_name_config_map" {
  value = var.name_config_map
}
