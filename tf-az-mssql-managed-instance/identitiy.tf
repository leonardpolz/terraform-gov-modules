# module "role_assignments" {
#   source = "../tf-az-role-assignment"
#   role_assignments = flatten([
#     for key, mi in local.managed_instance_map : [
#       for ra in mi.role_assignments != null ? mi.role_assignments : [] : merge(ra, {
#         tf_id = ra.tf_id != null ? ra.tf_id : "${key}_${ra.principal_id}_${ra.role_definition_name != null ? replace(ra.role_definition_name, " ", "_") : ra.role_definition_id}"
#         scope = azurerm_mssql_managed_instance.managed_instances[key].id
#       })
#     ]
#   ])
# }

# locals {
#   managed_instance_map_ad_auth = { for key, mi in local.managed_instance_map : key => mi if mi.ad_auth_config != null }
# }

# resource "azuread_directory_role" "directory_readers" {
#   count        = length(local.managed_instance_map_ad_auth) > 0 ? 1 : 0
#   display_name = "Directory Readers"
# }

# resource "azuread_directory_role_assignment" "directory_readers" {
#   for_each            = local.managed_instance_map_ad_auth
#   role_id             = azuread_directory_role.directory_readers.*.template_id[0]
#   principal_object_id = azurerm_mssql_managed_instance.managed_instances[each.key].identity.*.principal_id[0]
# }

# resource "azurerm_mssql_managed_instance_active_directory_administrator" "mi_admin" {
#   for_each                    = local.managed_instance_map_ad_auth
#   managed_instance_id         = azurerm_mssql_managed_instance.managed_instances[each.key].id
#   login_username              = each.value.ad_auth_config.login_username
#   object_id                   = each.value.ad_auth_config.object_id
#   tenant_id                   = each.value.ad_auth_config.tenant_id
#   azuread_authentication_only = each.value.ad_auth_config.azuread_authentication_only

#   dynamic "timeouts" {
#     for_each = each.value.ad_auth_config.timeouts != null ? [each.value.ad_auth_config.timeouts] : []
#     content {
#       create = timeouts.value.create
#       update = timeouts.value.update
#       read   = timeouts.value.read
#       delete = timeouts.value.delete
#     }
#   }

#   depends_on = [azuread_directory_role_assignment.directory_readers]
# }
