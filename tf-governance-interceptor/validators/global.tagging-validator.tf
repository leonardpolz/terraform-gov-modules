variable "tagging_config_map" {
  type = map(object({
    required_tags = set(string)
    tags          = map(string)
  }))

  validation {
    condition = alltrue(flatten([
      for tc in var.tagging_config_map : [
        for t in tc.required_tags : contains(keys(tc.tags), t)
      ]
    ]))

    error_message = "All required tags must be present: ${join(", ", flatten([
      for tc in var.tagging_config_map : [
        for key, t in tc.required_tags : key
      ]
      ]))}; Got: ${join(", ", flatten([
      for tc in var.tagging_config_map : [
        for key, t in tc.tags : key
      ]
    ]))}"
  }

  default = {}
}

output "validated_tagging_config_map" {
  value = var.tagging_config_map
}
