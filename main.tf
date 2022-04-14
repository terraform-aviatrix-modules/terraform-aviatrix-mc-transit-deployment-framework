module "transit" {
  for_each = var.transit
  source   = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version  = "2.0.0"

  cloud                  = each.value.cloud
  cidr                   = each.value.transit_cidr
  region                 = each.value.region_name
  local_as_number        = each.value.asn
  account                = local.transit[each.key].account != "" ? local.transit[each.key].account : lookup(local.account, each.value.cloud, null)
  enable_segmentation    = local.transit[each.key].segmentation
  enable_transit_firenet = local.transit[each.key].firenet
  insane_mode            = local.transit[each.key].insane_mode
}

module "firenet" {
  for_each = { for k, v in module.transit : k => module.transit[k] if local.transit[k].firenet } #Filter transits that have firenet enabled
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
  source = "git@github.com:terraform-aviatrix-modules/terraform-aviatrix-mc-transit-peering-advanced.git"

  set1 = { for k, v in module.transit : module.transit[k].transit_gateway.gw_name => module.transit[k].transit_gateway.local_as_number if local.transit[k].cloud == each.value } #Create list of all transit within specified cloud
  set2 = { for k, v in module.transit : module.transit[k].transit_gateway.gw_name => module.transit[k].transit_gateway.local_as_number if !contains(slice(local.cloudlist, 0, index(local.cloudlist, each.value) + 1), local.transit[k].cloud) } #Create list of all transit NOT in specified cloud

  as_path_prepend = true
  excluded_cidrs  = ["0.0.0.0/0", ]
}