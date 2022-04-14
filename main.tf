module "transit" {
  for_each = var.transit
  source   = "/mnt/c/Users/Dennis/Aviatrix/repositories/Modules/terraform-aviatrix-mc-transit"
  #source   = "terraform-aviatrix-modules/mc-transit/aviatrix"
  #version  = "2.0.0"

  cloud                            = each.value.cloud
  cidr                             = each.value.transit_cidr
  region                           = each.value.region_name
  local_as_number                  = each.value.asn
  account                          = coalesce(local.transit[each.key].account, lookup(local.account, each.value.cloud, null))
  az_support                       = local.transit[each.key].az_support
  az1                              = local.transit[each.key].az1
  az2                              = local.transit[each.key].az2
  bgp_ecmp                         = local.transit[each.key].bgp_ecmp
  bgp_lan_interfaces               = local.transit[each.key].bgp_lan_interfaces
  bgp_manual_spoke_advertise_cidrs = local.transit[each.key].bgp_manual_spoke_advertise_cidrs
  bgp_polling_time                 = local.transit[each.key].bgp_polling_time
  connected_transit                = local.transit[each.key].connected_transit
  customer_managed_keys            = local.transit[each.key].customer_managed_keys
  enable_active_standby_preemptive = local.transit[each.key].enable_active_standby_preemptive
  enable_advertise_transit_cidr    = local.transit[each.key].enable_advertise_transit_cidr
  enable_bgp_over_lan              = local.transit[each.key].enable_bgp_over_lan
  enable_egress_transit_firenet    = local.transit[each.key].enable_egress_transit_firenet
  enable_encrypt_volume            = local.transit[each.key].enable_encrypt_volume
  enable_firenet                   = local.transit[each.key].enable_firenet
  enable_multi_tier_transit        = local.transit[each.key].enable_multi_tier_transit
  enable_s2c_rx_balancing          = local.transit[each.key].enable_s2c_rx_balancing
  enable_segmentation              = local.transit[each.key].segmentation
  enable_transit_firenet           = local.transit[each.key].enable_transit_firenet
  ha_bgp_lan_interfaces            = local.transit[each.key].ha_bgp_lan_interfaces
  ha_cidr                          = local.transit[each.key].ha_cidr
  ha_gw                            = local.transit[each.key].ha_gw
  ha_region                        = local.transit[each.key].ha_region
  hybrid_connection                = local.transit[each.key].hybrid_connection
  insane_mode                      = local.transit[each.key].insane_mode
  instance_size                    = local.transit[each.key].instance_size
  lan_cidr                         = local.transit[each.key].lan_cidr
  learned_cidr_approval            = local.transit[each.key].learned_cidr_approval
  learned_cidrs_approval_mode      = local.transit[each.key].learned_cidrs_approval_mode
  legacy_transit_vpc               = local.transit[each.key].legacy_transit_vpc
  name                             = local.transit[each.key].name
  resource_group                   = local.transit[each.key].resource_group
  single_az_ha                     = local.transit[each.key].single_az_ha
  single_ip_snat                   = local.transit[each.key].single_ip_snat
  tags                             = local.transit[each.key].tags
  tunnel_detection_time            = local.transit[each.key].tunnel_detection_time
}

module "firenet" {
  for_each = { for k, v in module.transit : k => module.transit[k] if local.transit[k].enable_transit_firenet } #Filter transits that have firenet enabled
  source   = "terraform-aviatrix-modules/mc-firenet/aviatrix"
  version  = "1.0.0"

  transit_module = module.transit[each.key]
  firewall_image = lookup(local.firewall_image, local.transit[each.key].cloud, null)
}

#Create full mesh peering intra-cloud  
module "transit-peerings-intra-cloud" {
  for_each = toset(local.cloudlist)
  source   = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version  = "1.0.5"

  transit_gateways = [for k, v in module.transit : module.transit[k].transit_gateway.gw_name if local.transit[k].cloud == each.value]
  excluded_cidrs   = ["0.0.0.0/0", ]
}

#Create full mesh peering inter-cloud and prepend path to prefer intra-cloud over inter-cloud, for traffic originated outside of the Aviatrix transit (e.g. DC VPN connected to multiple transits).
module "transit-peerings-inter-cloud" {
  for_each = toset(local.cloudlist)
  source   = "git@github.com:terraform-aviatrix-modules/terraform-aviatrix-mc-transit-peering-advanced.git"

  set1 = { for k, v in module.transit : module.transit[k].transit_gateway.gw_name => module.transit[k].transit_gateway.local_as_number if local.transit[k].cloud == each.value }                                                                 #Create list of all transit within specified cloud
  set2 = { for k, v in module.transit : module.transit[k].transit_gateway.gw_name => module.transit[k].transit_gateway.local_as_number if !contains(slice(local.cloudlist, 0, index(local.cloudlist, each.value) + 1), local.transit[k].cloud) } #Create list of all transit NOT in specified cloud

  as_path_prepend = true
  excluded_cidrs  = ["0.0.0.0/0", ]
}
