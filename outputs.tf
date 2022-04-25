#Omit all firenet details from transit output (as entire output gets marked sensitive as a result of firenet details)
output "transit" {
  value = (
    { for k, v in module.transit : k => {
      vpc             = v.vpc,
      transit_gateway = v.transit_gateway,
      }
    }
  )
}

output "firenet" {
  value     = module.firenet
  sensitive = true
}

output "region_transit_map" {
  value = local.region_transit_map
}
