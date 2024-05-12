# Global Conifguration Interceptor
## ==============================
## Functionality: Generate & validate default configuration for resources based on the global configuration settings

## Inputs
locals {

  ## Reference from 0-main.tf
  input_global_configuration_interceptor = local.pl_output_global_tagging_interceptor
}

locals {

  filtered_default_configuration_map = {

    ## Inject default configuration into configuration
    for key, c in local.input_global_configuration_interceptor : key => {
      for key, value in c : key => value if value != null
    }
  }

  default_configuration_map = {
    for key, c in local.filtered_default_configuration_map : key => merge(
      merge(
        local.global_settings.config.default_config,
        try(local.resource_settings[c.resource_type].config.default_config, {})
      ), c
    )
  }
}

## Validate Required Configuration
module "validate_config" {
  source = "./validators"
  config_config_map = {
    for key, c in local.default_configuration_map : key => {
      required_config = merge(
        local.global_settings.config.required_config,
        try(local.resource_settings[c.resource_type].config.required_config, {})
      )

      config = jsonencode(c)
    }
  }
}

## Outputs
locals {
  output_global_configuration_interceptor = module.validate_config.validated_config_map
}
