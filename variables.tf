variable "transit" {
  type = map(object({
    cloud                            = string,
    transit_cidr                     = string,
    region_name                      = string,
    asn                              = number,
    account                          = optional(string),
    firenet                          = optional(bool),
    az_support                       = optional(bool),
    az1                              = optional(string),
    az2                              = optional(string),
    bgp_ecmp                         = optional(bool),
    bgp_lan_interfaces               = optional(list(string)),
    bgp_manual_spoke_advertise_cidrs = optional(string),
    bgp_polling_time                 = optional(number),
    connected_transit                = optional(bool),
    customer_managed_keys            = optional(bool),
    egress_enabled                   = optional(bool),
    enable_active_standby_preemptive = optional(bool),
    enable_advertise_transit_cidr    = optional(bool),
    enable_bgp_over_lan              = optional(bool),
    enable_egress_transit_firenet    = optional(bool),
    enable_encrypt_volume            = optional(bool),
    enable_firenet                   = optional(bool),
    enable_multi_tier_transit        = optional(bool),
    enable_s2c_rx_balancing          = optional(bool),
    enable_transit_firenet           = optional(bool),
    ha_bgp_lan_interfaces            = optional(list(string)),
    ha_cidr                          = optional(string),
    ha_gw                            = optional(bool),
    ha_region                        = optional(string),
    hybrid_connection                = optional(bool),
    insane_mode                      = optional(bool),
    insane_mode                      = optional(bool),
    instance_size                    = optional(string),
    lan_cidr                         = optional(string),
    learned_cidr_approval            = optional(bool),
    learned_cidrs_approval_mode      = optional(string),
    legacy_transit_vpc               = optional(bool),
    name                             = optional(string),
    resource_group                   = optional(string),
    segmentation                     = optional(bool),
    single_az_ha                     = optional(bool),
    single_ip_snat                   = optional(bool),
    tags                             = optional(map(string)),
    tunnel_detection_time            = optional(number),
  }))
}

locals {
  transit = defaults(var.transit, {
    # egress_enabled                   = true
    enable_transit_firenet = false
    firenet                = false
    segmentation           = true
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



