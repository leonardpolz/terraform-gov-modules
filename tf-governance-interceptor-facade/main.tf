module "governance_interceptor" {
  source = "git::https://github.com/leonardpolz/terraform-governance-framework-interceptor-module-example?ref=v1.0.5"
  #source         = "../../terraform-governance-framework-interceptor-module-example"
  configurations = var.configurations
}
