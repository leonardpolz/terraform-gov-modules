## Description: This file is the main entry point for the interceptor pipeline. It orchestrates the interceptor pipeline by calling the interceptor files in the correct order.
################################################################################################################################################################################

## Import settings from external module
## Modify this source if you like to use your own settings module
module "governance_framework_settings" {
  source = "../../terraform-governance-framework-settings"
}

locals {
  global_settings   = module.governance_framework_settings.settings.global_settings
  resource_settings = module.governance_framework_settings.settings.resource_settings
}


## Load generic configuration passed into the interceptor
locals {
  configuration_map = {
    for c in var.configurations : c.tf_id => {
      tf_id = c.tf_id,
      resource_config = merge(
        jsondecode(c.resource_config_json),
        {
          tf_id         = c.tf_id,
          resource_type = c.resource_type
        }
      )
    }
  }
}

# __________.__              .__  .__                
# \______   \__|_____   ____ |  | |__| ____   ____   
#  |     ___/  \____ \_/ __ \|  | |  |/    \_/ __ \  
#  |    |   |  |  |_> >  ___/|  |_|  |   |  \  ___/  
#  |____|   |__|   __/ \___  >____/__|___|  /\___  > 
#              |__|        \/             \/     \/ 

## Interceptor Pipeline, Global Interceptors are followed by Resource Specific Interceptors
## Functionality: Chain of Responsibility, each interceptor modifies the configuration if the configuration matches the resource type

# Inputs
locals {
  pl_input_map = { for c in local.configuration_map : c.tf_id => c.resource_config }
}


# Global Interceptor Pipeline
# ============================
locals {
  # Inputs
  pl_input_global_interceptor = local.pl_input_map

  # 1 Interceptor: Naming, Reference from global.1-interceptor.naming.tf 
  pl_output_global_naming_interceptor = local.output_global_naming_interceptor

  # 2 Interceptor: Tagging, Reference from global.2-interceptor.tagging.tf
  pl_output_global_tagging_interceptor = local.output_global_tagging_interceptor

  # 3 Interceptor: Default Configuration, Reference from global.3-interceptor.global.default-config.tf
  pl_output_global_default_configuration = local.output_global_configuration_interceptor

  # Outputs
  pl_global_interceptor_outputs = local.pl_output_global_default_configuration
}

# Resource Specific Interceptors
# ==============================
locals {
  # Inputs
  pl_input_resource_interceptor = local.pl_global_interceptor_outputs

  # 4 Interceptor: Private Endpoint, resource.1-interceptor.private-endpoint.tf 
  pl_output_resource_private_endpoint_interceptor = local.output_resource__private_endpoint_interceptor

  # 5 Interceptor: Virtual Network, resource.2-interceptor.virtual-network.tf 
  pl_output_resource_virtual_network_interceptor = local.output_resource__virtual_network_interceptor

  # 6 Interceptor: Route Table, resource.3-interceptor.route-table.tf 
  pl_output_resource_route_table_interceptor = local.output_resource__route_table_interceptor

  # 7 Interceptor: Network Security Group, resource.4-interceptor.network-security-group.tf 
  pl_output_resource_network_security_group_interceptor = local.output_resource_network_security_group_interceptor

  # 8 Interceptor: MSSQL Managed Instance, resource.5-interceptor.mssql-managed-instance.tf
  pl_output_resource_mssql_managed_instance_interceptor = local.output_resource_mssql_managed_instance_interceptor

  # Outputs
  pl_resource_interceptor_outputs = local.pl_output_resource_network_security_group_interceptor
}

## Outputs
locals {
  pl_output_map = local.pl_resource_interceptor_outputs
}

locals {
  result_map = local.pl_output_map
}
