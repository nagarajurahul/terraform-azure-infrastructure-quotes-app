Error Observed – App Service Plan Throttling

```
module.app_service.azurerm_service_plan.service_plan: Still creating... [06m00s elapsed]

│ Error: creating App Service Plan (Subscription: "Subsciption-ID")
│ Resource Group Name: "rg-quotesapp-prod"
│ Server Farm Name: "service-plan-quotesapp-prod"):
│ unexpected status 429 (429 Too Many Requests) with response:
│ {"Code":"429","Message":"App Service Plan Create operation is throttled for subscription ... Please contact support if issue persists."}
```

Notes:
This happened because the free subscription tier hit throttling limits while creating the App Service Plan. The deployment failed with HTTP 429 Too Many Requests. In a production environment, using a paid subscription with higher quotas or contacting Azure support would prevent this issue.

---
Error Observed – App Service Plan Quota Limitation

```
│   with module.app_service.azurerm_service_plan.service_plan,
│   on modules/app-service/main.tf line 1, in resource "azurerm_service_plan" "service_plan":
│    1: resource "azurerm_service_plan" "service_plan" {
│
│ creating App Service Plan (Subscription: "Subscription-ID"
│ Resource Group Name: "rg-quotesapp-prod"
│ Server Farm Name: "service-plan-quotesapp-prod"): performing CreateOrUpdate: unexpected status 401 (401 Unauthorized)
│ with response: {"Code":"Unauthorized","Message":"Operation cannot be completed without additional quota. Current Limit (Premium0V3 VMs): 0 ..."}
╵
Releasing state lock. This may take a few moments...
```
Notes:
This error occurred because the subscription had no quota for PremiumV3 App Service Plans (Premium0V3 VMs: 0). The deployment was blocked due to quota restrictions. In production, the fix would be to request a quota increase from Azure or use a lower SKU (e.g., B1/SKU in Standard tier) for testing.

---
Error Observed – Provider Inconsistent Result (Virtual Network)

```
module.network.azurerm_virtual_network.vnet: Creating...
╷
│ Error: Provider produced inconsistent result after apply
│
│ When applying changes to module.network.azurerm_virtual_network.vnet,
│ provider "registry.terraform.io/hashicorp/azurerm" produced an
│ unexpected new value: Root object was present, but now absent.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
Releasing state lock. This may take a few moments...
```

Notes:
This error occurred because of a Terraform AzureRM provider bug, where the state of the azurerm_virtual_network resource became inconsistent after creation. It is not an issue with the configuration itself.

Workarounds / Mitigation:

- Upgraded to the latest version of the AzureRM provider (hashicorp/azurerm).

- Cleaned state and retried deployment using: 
```
terraform init -upgrade
terraform apply
```
- For production use, if this persists, raise an issue on the AzureRM provider GitHub tracker




---
Error Observed – Resource Already Exists (Virtual Network)
```
module.network.azurerm_virtual_network.vnet: Creating...
╷
│ Error: A resource with the ID "/subscriptions/subscriptionid/resourceGroups/rg-quotesapp-prod/providers/Microsoft.Network/virtualNetworks/vnet-quotesapp-prod" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_virtual_network" for more information.
│
│   with module.network.azurerm_virtual_network.vnet,
│   on modules/network/main.tf line 1, in resource "azurerm_virtual_network" "vnet":
│    1: resource "azurerm_virtual_network" "vnet" {
╵
Releasing state lock. This may take a few moments...
```
Notes:
This happened because a Virtual Network with the same name already existed in the resource group before Terraform attempted to create it. Terraform cannot manage existing resources unless they are imported into state.

Workarounds / Mitigation:

- Import the existing VNet into Terraform state:

- terraform import azurerm_virtual_network.vnet "/subscriptions/<sub_id>/resourceGroups/rg-quotesapp-prod/providers/Microsoft.Network/virtualNetworks/vnet-quotesapp-prod"

- Or, if it was created unintentionally, delete the VNet manually in the Azure portal and re-run terraform apply.



---
Error Observed – SQL Server Provisioning Disabled in Region
```
│ Error: creating Server (Subscription: "Subscription-ID"
│ Resource Group Name: "rg-quotesapp-prod"
│ Server Name: "sqlserver-quotesapp-prod"): polling after CreateOrUpdate: polling failed: the Azure API returned the following error:
│
│ Status: "ProvisioningDisabled"
│ Message: "Provisioning is restricted in this region. Please choose a different region. For exceptions to this rule please open a support request with Issue type of 'Service and subscription limits'."
```

Notes: This error occurred because SQL Database provisioning was disabled in the selected region for the subscription. Free-tier or sandbox subscriptions often block SQL creation in certain regions to preserve capacity.

Workarounds / Mitigation:

- Deploy SQL Server in a different supported region (e.g., East US, Central US, West Europe).
- Or, if the region is required, open an Azure support request to request a quota/region exception.


---
Provider error
```
│ Error: Provider produced inconsistent result after apply
│
│ When applying changes to module.network.azurerm_nat_gateway.nat, provider "provider[\"registry.terraform.io/hashicorp/azurerm\"]" produced an
│ unexpected new value: Root object was present, but now absent.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent result after apply
│
│ When applying changes to module.network.azurerm_subnet.db, provider "provider[\"registry.terraform.io/hashicorp/azurerm\"]" produced an unexpected
│ new value: Root object was present, but now absent.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
Releasing state lock. This may take a few moments...
```


---
VNet Lock
```
module.network.azurerm_virtual_network.vnet: Creating...
╷
│ Error: waiting for provisioning state of Virtual Network (Subscription: "Subscription-ID"
│ Resource Group Name: "rg-quotesapp-prod"
│ Virtual Network Name: "vnet-quotesapp-prod"): retrieving Virtual Network (Subscription: "Subscription-ID"
│ Resource Group Name: "rg-quotesapp-prod"
│ Virtual Network Name: "vnet-quotesapp-prod"): unexpected status 404 (404 Not Found) with error: ResourceNotFound: The Resource 'Microsoft.Network/virtualNetworks/vnet-quotesapp-prod' under resource group 'rg-quotesapp-prod' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
│
│   with module.network.azurerm_virtual_network.vnet,
│   on modules/network/main.tf line 1, in resource "azurerm_virtual_network" "vnet":
│    1: resource "azurerm_virtual_network" "vnet" {
│
╵
Releasing state lock. This may take a few moments...
```