variable "config_config_map" {
  type = map(object({
    required_config = map(string)
    config          = string
  }))

  // Validate that all config_configs meet the requirements of the required_config
  validation {
    condition = alltrue(flatten([
      for cc in var.config_config_map : [
        for key, rc in cc.required_config : contains(keys(jsondecode(cc.config)), key) == null || jsondecode(cc.config)[key] == rc
      ]
    ]))

    error_message = "All required config must be present and have the correct value: ${join(", ", [
      for cc in var.config_config_map : jsonencode(cc.required_config)
      ])}; Got: ${join(", ", [
      for cc in var.config_config_map : jsonencode(jsondecode(cc.config))
    ])}"
  }

  default = {}
}

output "validated_config_map" {
  value = {
    for key, cc in var.config_config_map : key => jsondecode(cc.config)
  }
}
