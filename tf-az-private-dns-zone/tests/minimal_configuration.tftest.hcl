provider "azurerm" {
  features {}
}

run "plan" {
  command = plan

  variables {
    private_dns_zones = [{
      tf_id = "test_pdz"

      tags = {
        terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
        deployed_by              = "Leonard Polz"
        hidden-title             = "Test Private DNS Zone"
      }

      name                = "test.local"
      resource_group_name = "test-rg"
    }]
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].name == "test.local"
    error_message = "Private DNS Zone name '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].name}' does not match expected value 'test.local'"
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].resource_group_name == "test-rg"
    error_message = "Private DNS Zone resource_group_name '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].resource_group_name}' does not match expected value 'test-rg'"
  }
}
