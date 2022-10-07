terraform {
  experiments = [module_variable_optional_attrs]

  required_providers {
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "~> 2.24.0"
    }
  }
  required_version = ">= 1.1.0"
}
