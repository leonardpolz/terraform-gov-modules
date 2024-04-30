module "configuration_interceptor" {
  source = "../tf-governance-interceptor-facade"
  configurations = [for sqlmi in var.mssql_managed_instances : {
    tf_id                = sqlmi.tf_id
    resource_type        = "Microsoft.Sql/managedInstances"
    resource_config_json = jsonencode(sqlmi)
    }
  ]
}

locals {
  managed_instance_map = module.configuration_interceptor.configuration_map
}

resource "azurerm_mssql_managed_instance" "managed_instances" {
  for_each                       = local.managed_instance_map
  administrator_login            = each.value.administrator_login
  administrator_login_password   = each.value.administrator_login_password
  license_type                   = each.value.license_type
  location                       = each.value.location
  name                           = each.value.nc_bypass != null ? each.value.nc_bypass : each.value.name
  resource_group_name            = each.value.resource_group_name
  sku_name                       = each.value.sku_name
  storage_size_in_gb             = each.value.storage_size_in_gb
  subnet_id                      = try(each.value.connectivity_settings.subnet_id_bypass, null) != null ? each.value.connectivity_settings.subnet_id_bypass : module.virtual_networks.subnets["${each.key}_${each.key}"].id
  vcores                         = each.value.vcores
  collation                      = each.value.collation
  dns_zone_partner_id            = each.value.dns_zone_partner_id
  maintenance_configuration_name = each.value.maintenance_configuration_name
  minimum_tls_version            = each.value.minimum_tls_version
  proxy_override                 = each.value.proxy_override
  public_data_endpoint_enabled   = each.value.public_data_endpoint_enabled
  storage_account_type           = each.value.storage_account_type
  timezone_id                    = each.value.timezone_id
  tags                           = each.value.tags

  identity {
    type = "SystemAssigned"
  }
}
