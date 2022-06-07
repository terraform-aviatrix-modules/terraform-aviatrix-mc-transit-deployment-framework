# How to use outputs
This module creates all resources for your core cloud network; the transit layer. However, in order for it to be of use, you need to attach spokes, VPN's, SDWAN, etc. This page provides guidance how to address the information in the deployment framework outputs.

### Example deployment
For the examples below, we will assume that the below environment was deployed. 3 transits, with Firenet in different clouds:

```
module "framework" {
  source  = "terraform-aviatrix-modules/mc-transit-deployment-framework/aviatrix"
  version = "v0.0.3"

  default_transit_accounts = {
    aws   = "AWS-Account",
    azure = "Azure-Account",
    gcp   = "GCP-Account",
  }

  default_firenet_firewall_image = {
    aws   = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1",
    azure = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1",
    gcp   = "Palo Alto Networks VM-Series Next-Generation Firewall BUNDLE1",
  }

  transit_firenet = {

    #Transit firenet in AWS, using default_firewall_image
    transit1a = {          
      transit_cloud       = "aws",
      transit_cidr        = "10.1.0.0/23",
      transit_region_name = "eu-central-1",
      transit_asn         = 65101,
      firenet             = true,
    },

    #Transit in Azure
    transit2 = {
      transit_cloud       = "azure",
      transit_cidr        = "10.1.2.0/23",
      transit_region_name = "West Europe",
      transit_asn         = 65102,
      firenet             = true,
    },

    #Transit firenet in GCP, using default_firewall_image
    transit3 = {
      transit_cloud       = "gcp",
      transit_cidr        = "10.1.4.0/23",
      transit_lan_cidr    = "10.99.1.0/24",
      transit_egress_cidr = "10.99.2.0/24",
      transit_region_name = "us-east1",
      transit_asn         = 65103,
      firenet             = true,
    },    
  }
}
```
Bear in mind that in this example, "transit1", "transit2" and "transit3" are the KEYS of our transit_firenet map. This is important, as these will also be the keys to reference to our outputs.

### Common attributes
Some attributes are commonly used. This section shows how to easily access them from the output.

Generic example:
```
module.framework.<output_name>["<instance_key>"].attribute
```

VPC ID, for transit1:
```
module.framework.transit["transit1"].vpc.vpc_id
```

Transit gateway name, for transit2:
```
module.framework.transit["transit2"].transit_gateway.gw_name
```

### Attach a spoke
In order to attach a spoke gateway, we only need the name of the transit gateway we want to attach to. Lets say we want to attach it to transit1, which is in the same region:
```
module "spoke1" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.2.1"

  cloud      = "aws"
  name       = "spoke1"
  cidr       = "10.1.100.0/24"
  region     = "eu-central-1"
  account    = "AWS-Account"
  transit_gw = module.framework.transit["transit1"].transit_gateway.gw_name
}
```

Alternatively, if we don't know which transit to use, we can also use the region_transit_map output and take the first transit on the list in that region. (Depends on the architecture whether this is a desireable approach, e.g. if any region only has max. one transit gw)

```
module "spoke1" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.2.1"

  cloud      = "aws"
  name       = "spoke1"
  cidr       = "10.1.100.0/24"
  region     = "eu-central-1"
  account    = "AWS-Account"
  transit_gw = module.framework.region_transit_map["eu-central-1"][0]
}
```

### Attach an external device connection
In order to create an external device connection on a transit, we need the name of the transit gateway name, the VPC ID as well as the gateway's AS number. Lets say we want to build it on transit3:

```
resource "aviatrix_transit_external_device_conn" "test" {
  vpc_id            = module.framework.transit["transit3"].vpc.vpc_id
  gw_name           = module.framework.transit["transit3"].transit_gateway.gw_name
  bgp_local_as_num  = module.framework.transit["transit3"].transit_gateway.local_as_number
  connection_name   = "my_conn"
  connection_type   = "bgp"
  bgp_remote_as_num = "345"
  remote_gateway_ip = "172.12.13.14"
}
```

### Getting the management IP's of the NGFW's in a firenet
In this case we want to access information of the firenet NGFW instances created in this module. Lets say the firenet instances in transit1.

```
output "transit1_management_ips" {
  value = module.framework.firenet["transit1"].aviatrix_firewall_instance.*.public_ip
}
```