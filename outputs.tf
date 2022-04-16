output "transit" {
  value     = module.transit
  sensitive = true
}

output "firenet" {
  value     = module.firenet
  sensitive = true
}

output "region_transit_map" {
  value = local.region_transit_map
}
