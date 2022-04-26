# Peering

## Peering Mode
The selected peering mode determines how the Aviatrix transit gateways are peered together using the [transit peering resource](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_transit_gateway_peering). 

### Changing peering mode
Changing between modes requires a rebuild of all peerings and the advised way to accomplish this is by setting peering to none, applying the changes and after that set it to the desired peering mode.

## Available peering modes
Below a detailed explaination what the purpose for each peering mode is.

### Full Mesh
Full mesh peering, automatically creates a transit peering between all available Aviatrix transit gateways, that were create within this module. Be default default routes will be excluded from propagating over these peerings.

### Optimized Full Mesh (default)
Just like with full mesh peering, optimized full mesh automatically creates a transit peering between all available Aviatrix transit gateways, that were create within this module. By default, default routes will be excluded from propagating over these peerings as well. The difference is however, that any inter-cloud peerings (e.g. from AWS to Azure) are automatically AS Path prepended with 1 additional AS.

The reason for the AS Path prepending is to optimize traffic patterns that originate outside of the Aviatrix dataplane. E.g. a datacenter that is connected to Aviatrix transit gateways in multiple clouds, through an IPSEC connection. Without prepending, the paths to a remote region (where the datacenter does not have a direct connection to) look equal, regardless of traversing a single cloud or multiple cloud providers networks.

As you can see in the example below, where no prepending is applied, both the purple and orange paths to AWS US are equal in length and thus equally desireable. The orange path however is clearly undesirable from a cost perspective, as traffic has to traverse through Azure, incurring unwanted egress charges. On top of that, it's unlikely that the path from the Azure region in Europe provides a better quality path than the path that the AWS region in Europe provides, as that traffic stays on the AWS backbone.

<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-deployment-framework/blob/main/img/optimized-peering-no-prepending.png?raw=true" title="No prepending">

In order to prevent the above scenario, we need to make the path between different clouds, less desireable than within a single cloud. In order to achieve this, AS Path prepending is applied on any inter-cloud peering as shown in blue.

<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit-deployment-framework/blob/main/img/optimized-peering-with-prepending.png?raw=true" title="With prepending">

This makes the orange path less desireable, as it's length is now longer than the purple path. As such our traffic now follows the optimized purple path. The orange path will still remain available for high-availability, were the purple path to become unavailable. This design has one side effect though. Because the inter-cloud path is now prepended, traffic between Azure and AWS in the Europe region would consider the path over the datacenter just as desireable as the direct path, because they would equal to a length of 2. To negate this, make sure to prepend the AS Path for any prefixes announced towards the DC. That way, when the DC propagates them onto the BGP peering with the other region, the path length will be longer than the direct path.

### Custom
When the above peering modes lack the required flexibility for your peering use case, the custom peering mode can be used to insert a peering map with all specific required peerings. All arguments available in the [transit peering resource](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_transit_gateway_peering) can be used here, as this is a direct wrapper around this resource.
As this is aimed for totally customized use, no defaults are assumed here. Which means, no networks CIDR's are filtered by default (e.g. 0.0.0.0/0).

This map could look like this for example where we only want 2 peerings to be created (module is named "framework" in this example):
```
  peering_map = {
    peering1 : {
      gw1_name                            = module.framework.transit["transit1"].transit_gateway.gw_name,
      gw2_name                            = module.framework.transit["transit2"].transit_gateway.gw_name,
      enable_peering_over_private_network = true,
    },
    peering2 : {
      gw1_name                        = module.framework.transit["transit1"].transit_gateway.gw_name,
      gw2_name                        = module.framework.transit["transit3"].transit_gateway.gw_name,
      gateway1_excluded_network_cidrs = ["0.0.0.0/0",]
      gateway2_excluded_network_cidrs = ["0.0.0.0/0",]
    },
  }
```

List of arguments accepted |
:--- |
gw1_name |
gw2_name |
gw1_excluded_cidrs |
gw2_excluded_cidrs |
gw1_excluded_tgw_connections |
gw2_excluded_tgw_connections |
prepend_as_path1 |
prepend_as_path2 |
enable_single_tunnel_mode |
tunnel_count |
enable_peering_over_private_network |
enable_insane_mode_encryption_over_internet |

### None
In case no peering is desired or when all peering configuration is done outside of this module, you can set peering_mode to none.

## Pruning
When using full_mesh or optimized_full_mesh peering, sometimes you need to make an exception for a specific peering. In stead of having to switch from a full mesh to defining all peerings custom, you can use the pruning capability to prevent certain peerings from being created. This allows you to create those peerings manually with specific settings (e.g. use private connection for a few peers while rest uses public internet).
Be aware that the peering mode is exclusive, meaning you cannot combine custom peering with full_mesh or optimized_full_mesh together. So if you need to create specific peerings in addition to using full_mesh or optimized_full_mesh, you need to configure those peerings outside of this module. This list takes map values with the KEY of each transit entry. So no need to provide the actual transit name. The module will execute the lookup automatically.

Example, which prevents transit1 to peer with transit2 and transit3, while using full_mesh or optimized_full_mesh peering mode:
```
  peering_prune_list = [
    { "transit1" : "transit2" },
    { "transit1" : "transit3" },
  ]
```