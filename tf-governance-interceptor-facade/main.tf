module "governance_interceptor" {
  source         = "git::https://github.com/leonardpolz/terraform-governance-framework-interceptor-module-example?ref=v1.0.3"
  #source = "../../terraform-governance-framework-interceptor-module-example"
  configurations = var.configurations
}