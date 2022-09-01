# azure-terraform

Terraform code examples

## Requirements

* Access to an azure subscription to deploy resources
* Terraform installed locally - [Install](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* Azure CLI installed locally - [MS Documentation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Store Remote State

By default terraform creates and stores the state file locally. To store the state file remotely follow the directions below.

### Create a storage account

```powershell
az login
az account set --subscription <SUBSCRIPTION_NAME>

$RESOURCE_GROUP_NAME="<RESOURCE GROUP NAME>"
$STORAGE_ACCOUNT_NAME="<STORAGE ACCOUNT NAME>"
$CONTAINER_NAME="tfstate"
$AZ_REGION="westus3"

az group create --name $RESOURCE_GROUP_NAME --location $AZ_REGION

az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

$ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

## CLI ENV Var ##
#export ARM_ACCESS_KEY=$ACCOUNT_KEY

## Powershell ENV Var ##
$env:ARM_ACCESS_KEY=$ACCOUNT_KEY
```

### Terraform Init Remote State

```powershell
az login
az account set --subscription <SUBSCRIPTION_NAME>

$RESOURCE_GROUP_NAME="<RESOURCE GROUP NAME>"
$STORAGE_ACCOUNT_NAME="<STORAGE ACCOUNT NAME>"
$CONTAINER_NAME="<NAME OF SA CONTAINER>"

## User account will need access to the storage account
$ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

$env:ARM_ACCESS_KEY=$ACCOUNT_KEY
```

### Terraform Init for remote state

All commands should be ran in the same directory as where the terraform code is located.

```powershell
terraform init `
  -backend-config="resource_group_name=<RESOURCE GROUP NAME>" `
  -backend-config="storage_account_name=<STORAGE ACCOUNT NAME>" `
  -backend-config="container_name=<NAME OF SA CONTAINER>" `
  -backend-config="key=<STATE FILE NAME>.tfstate"
```

### Terraform Plan & Apply

All commands should be ran in the same directory as where the terraform code is located.

```Powershell
terraform plan

terraform apply
```
