
/*
Description: Creates a new EA subscription.
Premissions: The service principal used needs access to EA
Destroy:  The subscription will be put into a cancled state. but can be reactivated within 90 days. 
          After 90 days the subscription will be deleted. It is not possible to destroy a subscription that 
          contains resources. 
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


data "azurerm_billing_enrollment_account_scope" "account" {
  billing_account_name    = var.BillingAccount_Name
  enrollment_account_name = var.EnrollmentAccount_Name
}

resource "azurerm_subscription" "subscription" {
  subscription_name = var.Subscription_Name
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.account.id
}