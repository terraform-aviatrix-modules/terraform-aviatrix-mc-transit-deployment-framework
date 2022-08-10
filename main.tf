#This module builds out all transits
module "transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.2.0"

  for_each = var.transit_firenet

  cloud                            = each.value.transit_cloud
  cidr                             = each.value.transit_cidr
  region                           = each.value.transit_region_name
  local_as_number                  = each.value.transit_asn
  account                          = coalesce(local.transit[each.key].transit_account, lookup(var.default_transit_accounts, each.value.transit_cloud, null))
  az_support                       = local.transit[each.key].transit_az_support
  az1                              = local.transit[each.key].transit_az1
  az2                              = local.transit[each.key].transit_az2
  bgp_ecmp                         = local.transit[each.key].transit_bgp_ecmp
  bgp_lan_interfaces               = local.transit[each.key].transit_bgp_lan_interfaces
  bgp_manual_spoke_advertise_cidrs = local.transit[each.key].transit_bgp_manual_spoke_advertise_cidrs
  bgp_polling_time                 = local.transit[each.key].transit_bgp_polling_time
  connected_transit                = local.transit[each.key].transit_connected_transit
  customer_managed_keys            = local.transit[each.key].transit_customer_managed_keys
  enable_active_standby_preemptive = local.transit[each.key].transit_enable_active_standby_preemptive
  enable_advertise_transit_cidr    = local.transit[each.key].transit_enable_advertise_transit_cidr
  enable_bgp_over_lan              = local.transit[each.key].transit_enable_bgp_over_lan
  enable_egress_transit_firenet    = local.transit[each.key].transit_enable_egress_transit_firenet
  enable_encrypt_volume            = coalesce(local.transit[each.key].transit_enable_encrypt_volume, lower(each.value.transit_cloud) == "aws" ? true : false)
  enable_firenet                   = local.transit[each.key].transit_enable_firenet
  enable_multi_tier_transit        = local.transit[each.key].transit_enable_multi_tier_transit
  enable_s2c_rx_balancing          = local.transit[each.key].transit_enable_s2c_rx_balancing
  enable_segmentation              = local.transit[each.key].transit_enable_egress_transit_firenet ? false : local.transit[each.key].transit_segmentation
  enable_transit_firenet           = local.transit[each.key].transit_enable_transit_firenet || local.transit[each.key].firenet
  gw_name                          = local.transit[each.key].transit_gw_name
  ha_bgp_lan_interfaces            = local.transit[each.key].transit_ha_bgp_lan_interfaces
  ha_cidr                          = local.transit[each.key].transit_ha_cidr
  ha_gw                            = local.transit[each.key].transit_ha_gw
  ha_region                        = local.transit[each.key].transit_ha_region
  hybrid_connection                = local.transit[each.key].transit_hybrid_connection
  insane_mode                      = local.transit[each.key].transit_insane_mode
  instance_size                    = local.transit[each.key].transit_instance_size
  lan_cidr                         = local.transit[each.key].transit_lan_cidr
  learned_cidr_approval            = local.transit[each.key].transit_learned_cidr_approval
  learned_cidrs_approval_mode      = local.transit[each.key].transit_learned_cidrs_approval_mode
  legacy_transit_vpc               = local.transit[each.key].transit_legacy_transit_vpc
  name                             = local.transit[each.key].transit_name
  resource_group                   = local.transit[each.key].transit_resource_group
  single_az_ha                     = local.transit[each.key].transit_single_az_ha
  single_ip_snat                   = local.transit[each.key].transit_single_ip_snat
  tags                             = local.transit[each.key].transit_tags
  tunnel_detection_time            = local.transit[each.key].transit_tunnel_detection_time
  availability_domain              = local.transit[each.key].transit_availability_domain
  ha_availability_domain           = local.transit[each.key].transit_ha_availability_domain
  fault_domain                     = local.transit[each.key].transit_fault_domain
  ha_fault_domain                  = local.transit[each.key].transit_ha_fault_domain
  enable_preserve_as_path          = local.transit[each.key].transit_enable_preserve_as_path
  enable_gateway_load_balancer     = local.transit[each.key].transit_enable_gateway_load_balancer
  bgp_lan_interfaces_count         = local.transit[each.key].transit_bgp_lan_interfaces_count
  private_mode_lb_vpc_id           = local.transit[each.key].transit_private_mode_lb_vpc_id
  private_mode_subnet_zone         = local.transit[each.key].transit_private_mode_subnet_zone
  ha_private_mode_subnet_zone      = local.transit[each.key].transit_ha_private_mode_subnet_zone
  private_mode_subnets             = local.transit[each.key].transit_private_mode_subnets
}

#This module builds out firenet, only on transits for which Firenet is enabled.
module "firenet" {
  source  = "terraform-aviatrix-modules/mc-firenet/aviatrix"
  version = "1.2.0"

  for_each = { for k, v in module.transit : k => v if local.transit[k].firenet } #Filter transits that have firenet enabled

  transit_module = module.transit[each.key]

  attached                             = local.transit[each.key].firenet_attached
  bootstrap_bucket_name_1              = local.transit[each.key].firenet_bootstrap_bucket_name_1
  bootstrap_bucket_name_2              = local.transit[each.key].firenet_bootstrap_bucket_name_2
  bootstrap_storage_name_1             = local.transit[each.key].firenet_bootstrap_storage_name_1
  bootstrap_storage_name_2             = local.transit[each.key].firenet_bootstrap_storage_name_2
  custom_fw_names                      = local.transit[each.key].firenet_custom_fw_names
  east_west_inspection_excluded_cidrs  = local.transit[each.key].firenet_east_west_inspection_excluded_cidrs
  egress_cidr                          = local.transit[each.key].firenet_egress_cidr
  egress_enabled                       = local.transit[each.key].firenet_egress_enabled
  egress_static_cidrs                  = local.transit[each.key].firenet_egress_static_cidrs
  file_share_folder_1                  = local.transit[each.key].firenet_file_share_folder_1
  file_share_folder_2                  = local.transit[each.key].firenet_file_share_folder_2
  firewall_image                       = coalesce(local.transit[each.key].firenet_firewall_image, lookup(var.default_firenet_firewall_image, local.transit[each.key].transit_cloud, null))
  firewall_image_id                    = local.transit[each.key].firenet_firewall_image_id
  firewall_image_version               = local.transit[each.key].firenet_firewall_image_version
  fw_amount                            = local.transit[each.key].firenet_fw_amount
  iam_role_1                           = local.transit[each.key].firenet_iam_role_1
  iam_role_2                           = local.transit[each.key].firenet_iam_role_2
  inspection_enabled                   = local.transit[each.key].firenet_inspection_enabled
  instance_size                        = local.transit[each.key].firenet_instance_size
  keep_alive_via_lan_interface_enabled = local.transit[each.key].firenet_keep_alive_via_lan_interface_enabled
  mgmt_cidr                            = local.transit[each.key].firenet_mgmt_cidr
  password                             = local.transit[each.key].firenet_password
  storage_access_key_1                 = local.transit[each.key].firenet_storage_access_key_1
  storage_access_key_2                 = local.transit[each.key].firenet_storage_access_key_2
  tags                                 = local.transit[each.key].firenet_tags
  user_data_1                          = local.transit[each.key].firenet_user_data_1
  user_data_2                          = local.transit[each.key].firenet_user_data_2
  username                             = local.transit[each.key].firenet_username
}

### Peering for full_mesh peering mode ###
#Create full mesh peering 
module "full_mesh_peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.6"

  count = local.peering_mode == "full_mesh" ? 1 : 0

  transit_gateways = [for k, v in module.transit : v.transit_gateway.gw_name if v.transit_gateway.enable_egress_transit_firenet == false] #Filter out egress transits
  excluded_cidrs   = var.excluded_cidrs
  prune_list       = local.peering_prune_list
}
##########################################

### Peering for full_mesh_optimized peering mode ###
#Create full mesh peering intra-cloud  
module "full_mesh_optimized_peering_intra_cloud" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.6"

  for_each = local.peering_mode == "full_mesh_optimized" ? toset(local.cloudlist) : []

  transit_gateways = [for k, v in module.transit : v.transit_gateway.gw_name if local.transit[k].transit_cloud == each.value && v.transit_gateway.enable_egress_transit_firenet == false] #Filter out egress transits
  excluded_cidrs   = var.excluded_cidrs
  prune_list       = local.peering_prune_list
}

#Create full mesh peering inter-cloud between 2 sets of gateways and prepend path to prefer intra-cloud over inter-cloud, for traffic originated outside of the Aviatrix transit (e.g. DC VPN connected to multiple transits).
module "full_mesh_optimized_peering_inter_cloud" {
  source  = "terraform-aviatrix-modules/mc-transit-peering-advanced/aviatrix"
  version = "1.0.0"

  for_each = local.peering_mode == "full_mesh_optimized" ? toset(local.cloudlist) : []

  set1 = { for k, v in module.transit : v.transit_gateway.gw_name => v.transit_gateway.local_as_number if local.transit[k].transit_cloud == each.value && v.transit_gateway.enable_egress_transit_firenet == false }                                                                 #Create list of all transit within specified cloud and filter out egress transits
  set2 = { for k, v in module.transit : v.transit_gateway.gw_name => v.transit_gateway.local_as_number if !contains(slice(local.cloudlist, 0, index(local.cloudlist, each.value) + 1), local.transit[k].transit_cloud) && v.transit_gateway.enable_egress_transit_firenet == false } #Create list of all transit NOT in specified cloud and filter out egress transits

  as_path_prepend = true
  excluded_cidrs  = var.excluded_cidrs
  prune_list      = local.peering_prune_list
}
##########################################

### Peering for custom peering mode ###
resource "aviatrix_transit_gateway_peering" "custom_peering" {
  for_each = local.peering_mode == "custom" ? var.peering_map : {}

  transit_gateway_name1                       = each.value.gw1_name
  transit_gateway_name2                       = each.value.gw2_name
  gateway1_excluded_network_cidrs             = each.value.gw1_excluded_cidrs
  gateway2_excluded_network_cidrs             = each.value.gw2_excluded_cidrs
  gateway1_excluded_tgw_connections           = each.value.gw1_excluded_tgw_connections
  gateway2_excluded_tgw_connections           = each.value.gw2_excluded_tgw_connections
  prepend_as_path1                            = each.value.prepend_as_path1
  prepend_as_path2                            = each.value.prepend_as_path2
  enable_single_tunnel_mode                   = each.value.enable_single_tunnel_mode
  tunnel_count                                = each.value.tunnel_count
  enable_peering_over_private_network         = each.value.enable_peering_over_private_network
  enable_insane_mode_encryption_over_internet = each.value.enable_insane_mode_encryption_over_internet
}
##########################################
