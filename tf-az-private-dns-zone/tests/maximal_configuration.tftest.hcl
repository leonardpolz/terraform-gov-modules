provider "azurerm" {
  features {}
}

run "plan" {
  command = plan

  variables {
    private_dns_zones = [
      {
        tf_id = "test_pdz"

        tags = {
          terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
          deployed_by              = "Leonard Polz"
          hidden-title             = "Test Private DNS Zone"
        }

        name                = "test.local"
        resource_group_name = "test-rg"

        role_assignments = [
          {
            principal_id       = "00000000-0000-0000-0000-000000000000"
            role_definition_id = "00000000-0000-0000-0000-000000000001"
          },
          {
            principal_id       = "00000000-0000-0000-0000-000000000000"
            role_definition_id = "00000000-0000-0000-0000-000000000002"
          }
        ]

        soa_record = {
          email        = "test.email"
          expire_time  = 3600
          minimum_ttl  = 300
          refresh_time = 900
          retry_time   = 600
          ttl          = 3600
          tags = {
            test = "test"
          }
        }

        a_records = [
          {
            tf_id               = "test_a_record"
            name                = "test.a.record"
            resource_group_name = "test-rg"
            ttl                 = 3600
            records             = ["10.10.10.10"]
          },
          {
            tf_id               = "test_a_record_2"
            name                = "test"
            resource_group_name = "test-rg"
            ttl                 = 3600
            records             = ["0.0.0.1"]
          }
        ]
      },
      {
        tf_id = "test_pdz_2"

        tags = {
          terraform_repository_uri = "https://github.com/leonardpolz/terraform-governance-framework-core-modules.git"
          deployed_by              = "Leonard Polz"
          hidden-title             = "Test Private DNS Zone"
        }

        name                = "test.local"
        resource_group_name = "test-rg"

        role_assignments = [
          {
            principal_id       = "00000000-0000-0000-0000-000000000000"
            role_definition_id = "00000000-0000-0000-0000-000000000001"
          },
          {
            principal_id       = "00000000-0000-0000-0000-000000000000"
            role_definition_id = "00000000-0000-0000-0000-000000000002"
          }
        ]

        soa_record = {
          email        = "test.email"
          expire_time  = 3600
          minimum_ttl  = 300
          refresh_time = 900
          retry_time   = 600
          ttl          = 3600
          tags = {
            test = "test"
          }
        }

        a_records = [
          {
            tf_id               = "test_a_record"
            name                = "test.a.record"
            resource_group_name = "test-rg"
            ttl                 = 3600
            records             = ["10.10.10.10"]
          },
          {
            tf_id               = "test_a_record_2"
            name                = "test"
            resource_group_name = "test-rg"
            ttl                 = 3600
            records             = ["0.0.0.1"]
          }
        ]
      }
    ]
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].name == "test.local"
    error_message = "Private DNS Zone name '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].name}' does not match expected value 'test.local'"
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].resource_group_name == "test-rg"
    error_message = "Private DNS Zone resource_group_name '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].resource_group_name}' does not match expected value 'test-rg'"
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].email == "test.email"
    error_message = "Private DNS Zone soa_record.email '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].email}' does not match expected value 'test.email'"
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].expire_time == 3600
    error_message = "Private DNS Zone soa_record.expire_time '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].expire_time}' does not match expected value '3600'"
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].minimum_ttl == 300
    error_message = "Private DNS Zone soa_record.minimum_ttl '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].minimum_ttl}' does not match expected value '300'"
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].refresh_time == 900
    error_message = "Private DNS Zone soa_record.refresh_time '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].refresh_time}' does not match expected value '900'"
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].retry_time == 600
    error_message = "Private DNS Zone soa_record.retry_time '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].retry_time}' does not match expected value '600'"
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].ttl == 3600
    error_message = "Private DNS Zone soa_record.ttl '${azurerm_private_dns_zone.private_dns_zones["test_pdz"].soa_record[0].ttl}' does not match expected value '3600'"
  }

  assert {
    condition     = azurerm_private_dns_a_record.a_records["test_pdz_test_a_record"].name == "test.a.record"
    error_message = "Private DNS A Record name '${azurerm_private_dns_a_record.a_records["test_pdz_test_a_record"].name}' does not match expected value 'test.a.record'"
  }

  assert {
    condition     = azurerm_private_dns_a_record.a_records["test_pdz_test_a_record"].ttl == 3600
    error_message = "Private DNS A Record ttl '${azurerm_private_dns_a_record.a_records["test_pdz_test_a_record"].ttl}' does not match expected value '3600'"
  }
}
