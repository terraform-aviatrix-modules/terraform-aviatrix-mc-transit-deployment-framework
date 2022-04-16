# terraform-aviatrix-mc-transit-adoption-framework

### Description
This module composes the mc-transit, mc-firenet and peering modules together to provide a reference transit layer implementation.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.0 | 0.15-1.x | 6.6 | >= 2.21.2

Check [release notes](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-adoption-framework/blob/master/RELEASE_NOTES.md) for more details.
Check [Compatibility list](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-adoption-framework/blob/master/COMPATIBILITY.md) for older versions.

### Usage Example
```
module "framework" {
  source  = "terraform-aviatrix-modules/mc-transit-adoption-framework/aviatrix"
  version = "v1.0.0"

  default_transit_accounts = {
    aws   = "AWS",
    azure = "Azure",
    gcp   = "GCP",
    oci   = "OCI",
    ali   = "ALI",
  }

  default_firewall_image = {
    aws   = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1",
    azure = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1",
    gcp   = "Palo Alto Networks VM-Series Next-Generation Firewall BUNDLE1",
    oci   = "Palo Alto Networks VM-Series Bundle1 - 4 OCPUs",
  }

  transit_firenet = {
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
    transit3 = {
      cloud               = "gcp",
      transit_cidr        = "10.1.4.0/23",
      transit_lan_cidr    = "10.99.1.0/24",
      transit_egress_cidr = "10.99.2.0/24",
      region_name         = "us-east1",
      asn                 = 65103,
      firenet             = true
    },    
  }
}
```

### Variables
The following variables are required:

key | value
:--- | :---
transit_firenet | A map with all relevant transit and firenet arguments. See [Transit-Firenet map arguments](#transit-firenet-map-arguments) to see which arguments are supported and mandatory.

The following variables are optional:

key | default | value 
:---|:---|:---
default_transit_accounts** | | Map of default access accounts to be used to deploy the transit Firenet infrastructure.
default_firewall_image** | | Map of default firewall images for deploying Firenet.
excluded_cidrs | ["0.0.0.0/0", ] | List of CIDR's to exlude in peerings (not used for custom peerings).
peering_mode | full_mesh_optimized | Choose between full_mesh, full_mesh_optimized, custom or none.
peering_list | [] | If peering_mode is custom, this list of peerings will be built. Example: [{gw1_name : gw2_name},]

**Any defaults that are not configured, need to be explicitly set in the transit_firenet variable for each entry, _if_ used (e.g. firewall_image does not require to be set if firenet is not deployed).

### Transit Firenet map arguments
The following arguments are mandatory in the transit firenet map variable:

key | value
:--- | :---
transit_cloud | Cloud in which this entry needs to be deployed. Valid values are: aws, azure, gcp, ali, oci.
transit_cidr | The CIDR for creating the transit (firenet) VPC/VNET/VCN.
transit_region_name | The name of the region in which this entry needs to be deployed.
transit_asn | A global unique AS Number for the transit gateway.

The following arguments are optional in the transit firenet map variable:
Any options set here will override the default_* variables for that particular instance.

key | default | value 
:---|:---|:---
transit_account | | **
transit_az_support | | 
transit_az1 | | 
transit_az2 | | 
transit_bgp_ecmp | | 
transit_bgp_lan_interfaces | | 
transit_bgp_manual_spoke_advertise_cidrs | | 
transit_bgp_polling_time | | 
transit_connected_transit | | 
transit_customer_managed_keys | | 
transit_egress_enabled | | 
transit_enable_active_standby_preemptive | | 
transit_enable_advertise_transit_cidr | | 
transit_enable_bgp_over_lan | | 
transit_enable_egress_transit_firenet | | 
transit_enable_encrypt_volume | | 
transit_enable_firenet | | 
transit_enable_multi_tier_transit | | 
transit_enable_s2c_rx_balancing | | 
transit_enable_transit_firenet | | 
transit_ha_bgp_lan_interfaces | | 
transit_ha_cidr | | 
transit_ha_gw | | 
transit_ha_region | | 
transit_hybrid_connection | | 
transit_insane_mode | | 
transit_insane_mode | | 
transit_instance_size | | 
transit_lan_cidr | | 
transit_learned_cidr_approval | | 
transit_learned_cidrs_approval_mode | | 
transit_legacy_transit_vpc | | 
transit_name | | 
transit_resource_group | | 
transit_segmentation | | 
transit_single_az_ha | | 
transit_single_ip_snat | | 
transit_tags | | 
transit_tunnel_detection_time | | 
firenet | false | 
firenet_attached | | 
firenet_bootstrap_bucket_name_1 | | 
firenet_bootstrap_bucket_name_2 | | 
firenet_bootstrap_storage_name_1 | | 
firenet_bootstrap_storage_name_2 | | 
firenet_custom_fw_names | | 
firenet_east_west_inspection_excluded_cidrs | | 
firenet_egress_cidr | | 
firenet_egress_enabled | | 
firenet_egress_static_cidrs | | 
firenet_fail_close_enabled | | 
firenet_file_share_folder_1 | | 
firenet_file_share_folder_2 | | 
firenet_firewall_image | | 
firenet_firewall_image_id | | 
firenet_firewall_image_version | | 
firenet_fw_amount | | 
firenet_iam_role_1 | | 
firenet_iam_role_2 | | 
firenet_inspection_enabled | | 
firenet_instance_size | | 
firenet_keep_alive_via_lan_interface_enabled | | 
firenet_mgmt_cidr | | 
firenet_password | | 
firenet_storage_access_key_1 | | 
firenet_storage_access_key_2 | | 
firenet_tags | | 
firenet_use_gwlb | | 
firenet_user_data_1 | | 
firenet_user_data_2 | | 
firenet_username | | 

### Outputs
This module will return the following outputs:

key | description
:---|:---
\<keyname> | \<description of object that will be returned in this output>
