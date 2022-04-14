# terraform-aviatrix-mc-transit-adoption-framework

### Description
This module composes the mc-transit, mc-firenet and peering modules together to provide a reference transit layer implementation.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.0 | 0.13-1.x | 6.6 | >= 2.21.2

Check [release notes](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-adoption-framework/blob/master/RELEASE_NOTES.md) for more details.
Check [Compatibility list](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-adoption-framework/blob/master/COMPATIBILITY.md) for older versions.

### Usage Example
```
module "framework" {
  source  = "terraform-aviatrix-modules/mc-transit-adoption-framework/aviatrix"
  version = "v1.0.0"

  transit = {
    transit1 = {
      cloud        = "aws",
      transit_cidr = "10.1.0.0/23",
      region_name  = "eu-central-1",
      asn          = 65101,
      firenet      = true
    },
    transit2 = {
      cloud        = "azure",
      transit_cidr = "10.1.2.0/23",
      region_name  = "West Europe",
      asn          = 65102,
      #firenet      = true
    },
  }
}
```

### Variables
The following variables are required:

key | value
:--- | :---
transit | A map with all relevant transit arguments. See [Transit map arguments](#transit-map-arguments) to see which arguments are supported and mandatory.

The following variables are optional:

key | default | value 
:---|:---|:---
\<keyname> | \<default value> | \<description of value that should be provided in this variable>

### Transit map arguments
The following arguments are mandatory in the transit map variable:

key | value
:--- | :---
cloud | Cloud in which this entry needs to be deployed. Valid values are: aws, azure, gcp, ali, oci.
transit_cidr | The CIDR for creating the transit (firenet) VPC/VNET/VCN.
region_name | The name of the region in which this entry needs to be deployed.
asn | A global unique AS Number for the transit gateway.

The following arguments are optional in the transit map variable:

key | default | value 
:---|:---|:---
firenet | false | Toggle to true, to deploy Firenet in this entry.

### Outputs
This module will return the following outputs:

key | description
:---|:---
\<keyname> | \<description of object that will be returned in this output>
