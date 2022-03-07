# azure-terraform

Terraform code examples

## How to run

```Powershell
cd .\az-policy
terraform init
terraform apply
```

## Store Remote State

### Create a storage account

```powershell
$RESOURCE_GROUP_NAME="<RESOURCE GROUP NAME>"
$STORAGE_ACCOUNT_NAME="<STORAGE ACCOUNT NAME>"
$CONTAINER_NAME="tfstate"

az group create --name $RESOURCE_GROUP_NAME --location westus3

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
$RESOURCE_GROUP_NAME="<RESOURCE GROUP NAME>"
$STORAGE_ACCOUNT_NAME="<STORAGE ACCOUNT NAME>"
$CONTAINER_NAME="tfstate"

$ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

$env:ARM_ACCESS_KEY=$ACCOUNT_KEY
```

```powershell
terraform init `
  -backend-config="resource_group_name=<RESOURCE GROUP NAME>" `
  -backend-config="storage_account_name=<STORAGE ACCOUNT NAME>" `
  -backend-config="container_name=tf-state" `
  -backend-config="key=<STATE FILE NAME>.tfstate"
```
