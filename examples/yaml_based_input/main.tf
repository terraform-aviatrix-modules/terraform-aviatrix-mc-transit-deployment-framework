module "framework" {
  source  = "terraform-aviatrix-modules/mc-transit-deployment-framework/aviatrix"
  version = "v0.0.4"

  default_transit_accounts = {
    azure = "Azure",
    oci   = "OCI",
    aws   = "AWS",
  }

  transit_firenet = yamldecode(file("transit.yml"))
}
