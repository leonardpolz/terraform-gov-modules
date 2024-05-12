## Global Tagging Interceptor
## =========================
## Functionality: Generate & validate tags for resources based on the tagging settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_global_tagging_interceptor = local.pl_output_global_naming_interceptor
}

locals {
  ## Load Default Tags
  tagging_config_map = {
    for key, c in local.input_global_tagging_interceptor : key => {
      tf_id = c.tf_id
      tags  = c.tags

      ## Override resource specific default tags with global default tags
      default_tags = merge(
        local.global_settings.tagging.default_tags,
        try(local.resource_settings[c.resource_type].tagging.default_tags, {}),
      )

      ## Override resource specific required tags with global required tags
      required_tags = concat(
        local.global_settings.tagging.required_tags,
        try(local.resource_settings[c.resource_type].tagging.required_tags, []),
      )
    } if contains(["Microsoft.Authorization/roleAssignments"], c.resource_type) == false
  }

  tagging_result_map = {
    for key, tc in local.tagging_config_map : key => merge(
      tc, {

        ## Merge tags with default tags
        tags = merge(
          tc.tags,
          tc.default_tags
        )
      }
    )
  }
}

## Validate Required Tags
module "validate_tagging" {
  source             = "./validators"
  tagging_config_map = local.tagging_result_map
}

locals {
  intercepted_tagging_configuration_map = {

    ## Inject tags into configuration
    for key, c in local.input_global_tagging_interceptor : key => merge(c, {
      tags = contains(["Microsoft.Authorization/roleAssignments"], c.resource_type) == false ? local.tagging_result_map[c.tf_id].tags : null
    })
  }
}

## Outputs
locals {
  output_global_tagging_interceptor = local.intercepted_tagging_configuration_map
}
