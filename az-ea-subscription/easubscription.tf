
/*
Description: Creates a new EA subscription.
Premissions: The service principal used needs access to EA
Destroy:  The subscription will be put into a cancled state. but can be reactivated within 90 days. 
          After 90 days the subscription will be deleted. It is not possible to destroy a subscription that 
          contains resources. 
Run with a TF Vars file: terraform apply -var-file="./example.tfvars"  
Run with inline vars: terraform apply -var="BillingAccount_Name=1234567890"
*/


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
}

/*
Create Subscription
*/
data "azurerm_billing_enrollment_account_scope" "account" {
  billing_account_name    = var.BillingAccount_Name
  enrollment_account_name = var.EnrollmentAccount_Name
}

resource "azurerm_subscription" "subscription" {
  subscription_name = var.Subscription_Name
  workload          = "Production"
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.account.id
}

/*
Move subscription to MG group
*/
# data "azurerm_subscription" "primary" {
#   subscription_id = "SUBID For testing"
# }
data "azurerm_management_group" "MgGroup" {
  name = var.Management_GroupName
}

resource "azurerm_management_group_subscription_association" "mg_move" {
  management_group_id = data.azurerm_management_group.MgGroup.id
  subscription_id     = azurerm_subscription.subscription.id
  # subscription_id = data.azurerm_subscription.primary.id
}

/*
Assign a user as owner
*/
data "azurerm_client_config" "clientConfig" {}

resource "azurerm_role_assignment" "assignUser" {
  # scope                = data.azurerm_subscription.primary.id
  scope                = azurerm_subscription.subscription.id
  role_definition_name = var.RoleName
  principal_id         = var.PrincipalId
}