terraform {
  experiments = [module_variable_optional_attrs]

  required_providers {
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = ">=2.21.2"
    }
  }
  required_version = ">= 0.13"
}
