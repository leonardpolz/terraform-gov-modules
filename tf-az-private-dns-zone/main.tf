module "configuration_interceptor" {
  source = "../tf-governance-interceptor-facade"
  configurations = [for pdz in var.private_dns_zones : {
    tf_id         = pdz.tf_id
    resource_type = "Microsoft.Network/privateDnsZones"
    resource_config_json = jsonencode(merge(pdz, {
      parent_name = "none"
      name_config = {
        values = {}
      }

      nc_bypass = pdz.name
    }))
    }
  ]
}

locals {
  private_dns_zone_map = {
    for pdz in var.private_dns_zones : pdz.tf_id => merge(
      pdz, {
      }
    )
  }
}

resource "azurerm_private_dns_zone" "private_dns_zones" {
  for_each            = local.private_dns_zone_map
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  tags                = each.value.tags

  dynamic "soa_record" {
    for_each = each.value.soa_record != null ? [each.value.soa_record] : []
    content {
      email        = soa_record.value.email
      expire_time  = soa_record.value.expire_time
      minimum_ttl  = soa_record.value.minimum_ttl
      refresh_time = soa_record.value.refresh_time
      retry_time   = soa_record.value.retry_time
      ttl          = soa_record.value.ttl
      tags         = soa_record.value.tags
    }
  }
}

module "role_assignments" {
  source = "../tf-az-role-assignment"
  role_assignments = flatten([
    for key, pdz in local.private_dns_zone_map : [
      for ra in pdz.role_assignments : merge(ra, {
        tf_id       = ra.tf_id != null ? ra.tf_id : "${key}_${ra.principal_id}_${ra.role_definition_name != null ? replace(ra.role_definition_name, " ", "_") : ra.role_definition_id}"
        parent_name = pdz.name
        scope       = azurerm_private_dns_zone.private_dns_zones[key].id
      })
    ] if pdz.role_assignments != null
  ])
}

locals {
  a_record_list = flatten([
    for key, pdz in local.private_dns_zone_map : [
      for ar in pdz.a_records != null ? pdz.a_records : [] : merge(
        ar, {
          tf_id     = "${key}_${ar.tf_id}"
          pdz_tf_id = key
        }
      )
    ]
  ])
}

resource "azurerm_private_dns_a_record" "a_records" {
  for_each            = { for ar in local.a_record_list : ar.tf_id => ar }
  name                = each.value.name
  resource_group_name = azurerm_private_dns_zone.private_dns_zones[each.value.pdz_tf_id].resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns_zones[each.value.pdz_tf_id].name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = each.value.tags
}
