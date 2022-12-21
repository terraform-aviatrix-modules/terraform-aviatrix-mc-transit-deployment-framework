#This module builds out all transits
module "transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.4.0"

  for_each = var.transit_firenet

  cloud                            = each.value.transit_cloud
  cidr                             = each.value.transit_cidr
  region                           = each.value.transit_region_name
  local_as_number                  = each.value.transit_asn
  account                          = coalesce(each.value.transit_account, lookup(var.default_transit_accounts, each.value.transit_cloud, null))
  az_support                       = each.value.transit_az_support
  az1                              = each.value.transit_az1
  az2                              = each.value.transit_az2
  bgp_ecmp                         = each.value.transit_bgp_ecmp
  bgp_lan_interfaces               = each.value.transit_bgp_lan_interfaces
  bgp_manual_spoke_advertise_cidrs = each.value.transit_bgp_manual_spoke_advertise_cidrs
  bgp_polling_time                 = each.value.transit_bgp_polling_time
  connected_transit                = each.value.transit_connected_transit
  customer_managed_keys            = each.value.transit_customer_managed_keys
  enable_active_standby_preemptive = each.value.transit_enable_active_standby_preemptive
  enable_advertise_transit_cidr    = each.value.transit_enable_advertise_transit_cidr
  enable_bgp_over_lan              = each.value.transit_enable_bgp_over_lan
  enable_egress_transit_firenet    = each.value.transit_enable_egress_transit_firenet
  enable_encrypt_volume            = coalesce(each.value.transit_enable_encrypt_volume, lower(each.value.transit_cloud) == "aws" ? true : false)
  enable_firenet                   = each.value.transit_enable_firenet
  enable_multi_tier_transit        = each.value.transit_enable_multi_tier_transit
  enable_s2c_rx_balancing          = each.value.transit_enable_s2c_rx_balancing
  enable_segmentation              = each.value.transit_enable_egress_transit_firenet ? false : each.value.transit_segmentation
  enable_transit_firenet           = each.value.transit_enable_transit_firenet || each.value.firenet
  gw_name                          = each.value.transit_gw_name
  ha_bgp_lan_interfaces            = each.value.transit_ha_bgp_lan_interfaces
  ha_cidr                          = each.value.transit_ha_cidr
  ha_gw                            = each.value.transit_ha_gw
  ha_region                        = each.value.transit_ha_region
  hybrid_connection                = each.value.transit_hybrid_connection
  insane_mode                      = each.value.transit_insane_mode
  instance_size                    = each.value.transit_instance_size
  lan_cidr                         = each.value.transit_lan_cidr
  learned_cidr_approval            = each.value.transit_learned_cidr_approval
  learned_cidrs_approval_mode      = each.value.transit_learned_cidrs_approval_mode
  legacy_transit_vpc               = each.value.transit_legacy_transit_vpc
  name                             = each.value.transit_name
  resource_group                   = each.value.transit_resource_group
  single_az_ha                     = each.value.transit_single_az_ha
  single_ip_snat                   = each.value.transit_single_ip_snat
  tags                             = each.value.transit_tags
  tunnel_detection_time            = each.value.transit_tunnel_detection_time
  availability_domain              = each.value.transit_availability_domain
  ha_availability_domain           = each.value.transit_ha_availability_domain
  fault_domain                     = each.value.transit_fault_domain
  ha_fault_domain                  = each.value.transit_ha_fault_domain
  enable_preserve_as_path          = each.value.transit_enable_preserve_as_path
  enable_gateway_load_balancer     = each.value.transit_enable_gateway_load_balancer
  bgp_lan_interfaces_count         = each.value.transit_bgp_lan_interfaces_count
  private_mode_lb_vpc_id           = each.value.transit_private_mode_lb_vpc_id
  private_mode_subnets             = each.value.transit_private_mode_subnets
  allocate_new_eip                 = each.value.transit_allocate_new_eip
  eip                              = each.value.transit_eip
  ha_eip                           = each.value.transit_ha_eip
  azure_eip_name_resource_group    = each.value.transit_azure_eip_name_resource_group
  ha_azure_eip_name_resource_group = each.value.transit_ha_azure_eip_name_resource_group
  enable_vpc_dns_server            = each.value.transit_enable_vpc_dns_server
}

#This module builds out firenet, only on transits for which Firenet is enabled.
module "firenet" {
  source  = "terraform-aviatrix-modules/mc-firenet/aviatrix"
  version = "1.4.0"

  for_each = { for k, v in var.transit_firenet : k => v if v.firenet } #Filter transits that have firenet enabled

  transit_module = module.transit[each.key]

  attached                             = each.value.firenet_attached
  bootstrap_bucket_name_1              = each.value.firenet_bootstrap_bucket_name_1
  bootstrap_bucket_name_2              = each.value.firenet_bootstrap_bucket_name_2
  bootstrap_storage_name_1             = each.value.firenet_bootstrap_storage_name_1
  bootstrap_storage_name_2             = each.value.firenet_bootstrap_storage_name_2
  custom_fw_names                      = each.value.firenet_custom_fw_names
  east_west_inspection_excluded_cidrs  = each.value.firenet_east_west_inspection_excluded_cidrs
  egress_cidr                          = each.value.firenet_egress_cidr
  egress_enabled                       = each.value.firenet_egress_enabled
  egress_static_cidrs                  = each.value.firenet_egress_static_cidrs
  file_share_folder_1                  = each.value.firenet_file_share_folder_1
  file_share_folder_2                  = each.value.firenet_file_share_folder_2
  firewall_image                       = coalesce(each.value.firenet_firewall_image, lookup(var.default_firenet_firewall_image, each.value.transit_cloud, null))
  firewall_image_id                    = each.value.firenet_firewall_image_id
  firewall_image_version               = each.value.firenet_firewall_image_version
  fw_amount                            = each.value.firenet_fw_amount
  iam_role_1                           = each.value.firenet_iam_role_1
  iam_role_2                           = each.value.firenet_iam_role_2
  inspection_enabled                   = each.value.firenet_inspection_enabled
  instance_size                        = each.value.firenet_instance_size
  keep_alive_via_lan_interface_enabled = each.value.firenet_keep_alive_via_lan_interface_enabled
  mgmt_cidr                            = each.value.firenet_mgmt_cidr
  password                             = each.value.firenet_password
  storage_access_key_1                 = each.value.firenet_storage_access_key_1
  storage_access_key_2                 = each.value.firenet_storage_access_key_2
  tags                                 = each.value.firenet_tags
  user_data_1                          = each.value.firenet_user_data_1
  user_data_2                          = each.value.firenet_user_data_2
  username                             = each.value.firenet_username
}

### Peering for full_mesh peering mode ###
#Create full mesh peering 
module "full_mesh_peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.8"

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
  version = "1.0.8"

  for_each = local.peering_mode == "full_mesh_optimized" ? toset(local.cloudlist) : []

  transit_gateways = [for k, v in module.transit : v.transit_gateway.gw_name if var.transit_firenet[k].transit_cloud == each.value && v.transit_gateway.enable_egress_transit_firenet == false] #Filter out egress transits
  excluded_cidrs   = var.excluded_cidrs
  prune_list       = local.peering_prune_list
}

#Create full mesh peering inter-cloud between 2 sets of gateways and prepend path to prefer intra-cloud over inter-cloud, for traffic originated outside of the Aviatrix transit (e.g. DC VPN connected to multiple transits).
module "full_mesh_optimized_peering_inter_cloud" {
  source  = "terraform-aviatrix-modules/mc-transit-peering-advanced/aviatrix"
  version = "1.0.0"

  for_each = local.peering_mode == "full_mesh_optimized" ? toset(local.cloudlist) : []

  set1 = { for k, v in module.transit : v.transit_gateway.gw_name => v.transit_gateway.local_as_number if var.transit_firenet[k].transit_cloud == each.value && v.transit_gateway.enable_egress_transit_firenet == false }                                                                 #Create list of all transit within specified cloud and filter out egress transits
  set2 = { for k, v in module.transit : v.transit_gateway.gw_name => v.transit_gateway.local_as_number if !contains(slice(local.cloudlist, 0, index(local.cloudlist, each.value) + 1), var.transit_firenet[k].transit_cloud) && v.transit_gateway.enable_egress_transit_firenet == false } #Create list of all transit NOT in specified cloud and filter out egress transits

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
