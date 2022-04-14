variable "transit_firenet" {
  type = map(object({

    #Transit arguments
    transit_cloud                            = string,
    transit_cidr                             = string,
    transit_region_name                      = string,
    transit_asn                              = number,
    transit_account                          = optional(string),
    transit_az_support                       = optional(bool),
    transit_az1                              = optional(string),
    transit_az2                              = optional(string),
    transit_bgp_ecmp                         = optional(bool),
    transit_bgp_lan_interfaces               = optional(list(string)),
    transit_bgp_manual_spoke_advertise_cidrs = optional(string),
    transit_bgp_polling_time                 = optional(number),
    transit_connected_transit                = optional(bool),
    transit_customer_managed_keys            = optional(bool),
    transit_egress_enabled                   = optional(bool),
    transit_enable_active_standby_preemptive = optional(bool),
    transit_enable_advertise_transit_cidr    = optional(bool),
    transit_enable_bgp_over_lan              = optional(bool),
    transit_enable_egress_transit_firenet    = optional(bool),
    transit_enable_encrypt_volume            = optional(bool),
    transit_enable_firenet                   = optional(bool),
    transit_enable_multi_tier_transit        = optional(bool),
    transit_enable_s2c_rx_balancing          = optional(bool),
    transit_enable_transit_firenet           = optional(bool),
    transit_ha_bgp_lan_interfaces            = optional(list(string)),
    transit_ha_cidr                          = optional(string),
    transit_ha_gw                            = optional(bool),
    transit_ha_region                        = optional(string),
    transit_hybrid_connection                = optional(bool),
    transit_insane_mode                      = optional(bool),
    transit_insane_mode                      = optional(bool),
    transit_instance_size                    = optional(string),
    transit_lan_cidr                         = optional(string),
    transit_learned_cidr_approval            = optional(bool),
    transit_learned_cidrs_approval_mode      = optional(string),
    transit_legacy_transit_vpc               = optional(bool),
    transit_name                             = optional(string),
    transit_resource_group                   = optional(string),
    transit_segmentation                     = optional(bool),
    transit_single_az_ha                     = optional(bool),
    transit_single_ip_snat                   = optional(bool),
    transit_tags                             = optional(map(string)),
    transit_tunnel_detection_time            = optional(number),

    #Firenet arguments
    firenet                                      = optional(bool),
    firenet_attached                             = optional(bool),
    firenet_bootstrap_bucket_name_1              = optional(string),
    firenet_bootstrap_bucket_name_2              = optional(string),
    firenet_bootstrap_storage_name_1             = optional(string),
    firenet_bootstrap_storage_name_2             = optional(string),
    firenet_custom_fw_names                      = optional(list(string)),
    firenet_east_west_inspection_excluded_cidrs  = optional(list(string)),
    firenet_egress_cidr                          = optional(string),
    firenet_egress_enabled                       = optional(bool),
    firenet_egress_static_cidrs                  = optional(list(string)),
    firenet_fail_close_enabled                   = optional(bool),
    firenet_file_share_folder_1                  = optional(string),
    firenet_file_share_folder_2                  = optional(string),
    firenet_firewall_image_id                    = optional(string),
    firenet_firewall_image_version               = optional(string),
    firenet_fw_amount                            = optional(number),
    firenet_iam_role_1                           = optional(string),
    firenet_iam_role_2                           = optional(string),
    firenet_inspection_enabled                   = optional(bool),
    firenet_instance_size                        = optional(string),
    firenet_keep_alive_via_lan_interface_enabled = optional(bool),
    firenet_mgmt_cidr                            = optional(string),
    firenet_password                             = optional(string),
    firenet_storage_access_key_1                 = optional(string),
    firenet_storage_access_key_2                 = optional(string),
    firenet_tags                                 = optional(map(string)),
    firenet_use_gwlb                             = optional(bool),
    firenet_user_data_1                          = optional(string),
    firenet_user_data_2                          = optional(string),
    firenet_username                             = optional(string),
  }))
}

variable "transit_accounts" {
  description = "Default accounts for deploying transit architecture."
  type        = map(string)
  default     = {}
}

locals {
  transit = defaults(var.transit_firenet, {
    transit_segmentation           = true
    transit_enable_transit_firenet = false
    firenet                        = false
  })

  firewall_image = {
    aws   = "",
    azure = "Check Point CloudGuard IaaS Single Gateway R80.40 - Pay As You Go (NGTP)"
  }

  cloudlist = ["aws", "azure", "ali", "oci", "gcp"]
}



