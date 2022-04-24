module "framework" {
  source  = "terraform-aviatrix-modules/mc-transit-deployment-framework/aviatrix"
  version = "v1.0.0"

  default_transit_accounts = {
    azure = "Azure",
    oci   = "OCI",
    aws   = "AWS",
  }

  transit_firenet = yamldecode(file("transit.yml"))
}
