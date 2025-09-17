# Challenges Faced During Azure Quotes App Deployment

## 📌 SQL Access in Free Tier
Due to Azure Free Tier subscription limitations, it was not possible to create a VM in the same region as the App Service and SQL Database.  
Because of this, I executed the SQL schema creation and seed queries directly via the **Azure SQL Query Console** in the Azure Portal.

### Industry Best Practice
In a production-grade setup, the recommended approach is to:
- Create a dedicated **management subnet** within the same VNet.
- Deploy a **management/jump VM** inside that subnet.
- Use this VM to securely connect to the SQL Database **Private Endpoint** over **Azure Private Link**.
- **Disable all public SQL access** for strict PII protection.

This ensures compliance, proper network isolation, and secure access patterns in line with enterprise standards.

---

## 🚨 Error: App Service Plan Throttling
```hcl
module.app_service.azurerm_service_plan.service_plan: Still creating... [06m00s elapsed]

Error: creating App Service Plan (Subscription: "Subsciption-ID")
Resource Group Name: "rg-quotesapp-prod"
Server Farm Name: "service-plan-quotesapp-prod"):
unexpected status 429 (429 Too Many Requests)
```
**Notes:**  
This happened because the free subscription tier hit throttling limits while creating the App Service Plan.  
➡️ **Fix in Production:** Use a paid subscription with higher quotas or contact Azure support.

---

## 🚨 Error: App Service Plan Quota Limitation
```hcl
Error: creating App Service Plan (Subscription: "Subscription-ID"
Resource Group Name: "rg-quotesapp-prod"
Server Farm Name: "service-plan-quotesapp-prod"):
unexpected status 401 (401 Unauthorized)
Message: "Operation cannot be completed without additional quota. Current Limit (Premium0V3 VMs): 0 ..."
```
**Notes:**  
The subscription had **no quota** for PremiumV3 App Service Plans.  
➡️ **Fix in Production:** Request a **quota increase** or use a lower SKU (e.g., Standard B1) for testing.

---

## 🚨 Error: Provider Inconsistent Result (Virtual Network)
```hcl
Error: Provider produced inconsistent result after apply
```
**Notes:**  
This was a **Terraform AzureRM provider bug** where the state became inconsistent after creation.  
➡️ **Mitigation:**  
- Upgrade AzureRM provider: `terraform init -upgrade`  
- Retry deployment  
- If persists, raise issue on AzureRM GitHub

---

## 🚨 Error: Resource Already Exists (Virtual Network)
```hcl
Error: A resource with the ID ".../virtualNetworks/vnet-quotesapp-prod" already exists
```
**Notes:**  
A VNet with the same name already existed.  
➡️ **Fix Options:**  
- Import into Terraform state:  
  ```bash
  terraform import azurerm_virtual_network.vnet "/subscriptions/<sub_id>/resourceGroups/rg-quotesapp-prod/providers/Microsoft.Network/virtualNetworks/vnet-quotesapp-prod"
  ```
- Or manually delete in Portal and re-run apply.

---

## 🚨 Error: SQL Server Provisioning Disabled in Region
```hcl
Error: creating Server (Subscription: "Subscription-ID")
Message: "Provisioning is restricted in this region."
```
**Notes:**  
SQL Database provisioning was disabled in that region for free-tier subscriptions.  
➡️ **Fix in Production:** Deploy in another supported region or request exception from Azure support.

---

## 🚨 Error: Provider Inconsistent Result (NAT Gateway & Subnet)
```hcl
Error: Provider produced inconsistent result after apply
```
**Notes:**  
Again, a Terraform AzureRM provider bug.  
➡️ **Mitigation:** Upgrade provider and retry.

---

## 🚨 Error: VNet Lock Issue
```hcl
Error: waiting for provisioning state of Virtual Network ...
unexpected status 404 (404 Not Found)
```
**Notes:**  
A race condition where the VNet was not found during creation.  
➡️ **Mitigation:** Retry deployment after cleaning state.

---

# ✅ Summary
- **Free Tier Limitations:** Prevented creation of critical resources (VM, SQL in region, App Service Plan).  
- **Quota Restrictions:** Blocked Premium SKUs without quota increases.  
- **Terraform Bugs:** Caused inconsistent state issues with networking resources.  
- **Workarounds:** Used Azure SQL Console, retried with provider upgrades, considered imports/deletes for existing resources.

📖 **In Production:** These issues are mitigated by using a **paid subscription**, **requesting quota increases**, **following best practices for network isolation**, and **leveraging support channels for provider/region limitations**.
