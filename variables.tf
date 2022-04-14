variable "transit" {
  type = map(object({
    cloud          = string,
    transit_cidr   = string,
    region_name    = string,
    asn            = number,
    account        = optional(string),
    segmentation   = optional(bool),
    firenet        = optional(bool),
    egress_enabled = optional(bool),
    az_support     = optional(bool),
    insane_mode    = optional(bool),
  }))

  default = {}
}

locals {
  transit = defaults(var.transit, {
    account        = ""
    segmentation   = true
    firenet        = false
    egress_enabled = true
    az_support     = true
    insane_mode    = false
  })

  firewall_image = {
    aws   = "",
    azure = "Check Point CloudGuard IaaS Single Gateway R80.40 - Pay As You Go (NGTP)"
  }

  account = {
    aws   = "AWS",
    azure = "Azure"
  }

  cloudlist = ["aws", "azure", "ali", "oci", "gcp"]
}
