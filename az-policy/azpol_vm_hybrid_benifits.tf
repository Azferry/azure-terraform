
/*
Policy Rule: Append the licenseType of Windows_Server at the time of deployment of a virtual machine. Rule looks at the 
"Microsoft.Compute/imageOffer" or "Microsoft.Compute/imagePublisher" fields vaule to determine which vms get the append value.

Resource Types: "Microsoft.Compute/virtualMachines", "Microsoft.Compute/VirtualMachineScaleSets"
*/

resource "azurerm_policy_definition" "vm_benefits_policy" {
  name         = "VM - Enable Hybrid Benefits on Windows VM"
  policy_type  = "Custom"
  mode         = "Indexed"
  management_group_name = data.azurerm_management_group.mg.name ## Optional if you want to store the policy at the same location
  display_name = "VM - Enable Hybrid Benefits on Windows Virtual Machines"
  description = "Appends the value for hybrid benifits for windows virtual machines"

  metadata = <<METADATA
  {
    "category": "Compute"
  }
  METADATA


  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "in": [
            "Microsoft.Compute/virtualMachines",
            "Microsoft.Compute/VirtualMachineScaleSets"
          ]
        },
        {
          "anyOf": [
            {
              "allOf": [
                {
                  "field": "Microsoft.Compute/imagePublisher",
                  "equals": "MicrosoftWindowsServer"
                },
                {
                  "field": "Microsoft.Compute/imageOffer",
                  "equals": "WindowsServer"
                } 
              ]
            },
            {
              "allOf": [
                {
                  "field": "Microsoft.Compute/imagePublisher",
                  "equals": "MicrosoftWindowsServer"
                },
                {
                  "field": "Microsoft.Compute/imageOffer",
                  "equals": "WindowsServerSemiAnnual"
                } 
              ]
            },
            {
              "allOf": [
                {
                  "field": "Microsoft.Compute/imagePublisher",
                  "equals": "MicrosoftWindowsServerHPCPack"
                },
                {
                  "field": "Microsoft.Compute/imageOffer",
                  "equals": "WindowsServerHPCPack"
                } 
              ]
            },
            {
              "allOf": [
                {
                  "field": "Microsoft.Compute/imagePublisher",
                  "equals": "MicrosoftVisualStudio"
                },
                {
                  "field": "Microsoft.Compute/imageOffer",
                  "in": [
                    "VisualStudio",
                    "Windows"
                  ]
                } 
              ]
            }
          ]
        },
        {
          "field": "Microsoft.Compute/licenseType",
          "notEquals": "Windows_Server"
        }
      ]
    },
    "then": {
      "effect": "append",
      "details": [
        {
          "field": "Microsoft.Compute/licenseType",
          "value": "Windows_Server"
        }
      ]
    }
  }  
  POLICY_RULE
  
  # parameters = <<PARAMETERS
  #   {

  #   }
  # PARAMETERS
}

resource "azurerm_management_group_policy_assignment" "vm_benefits_assign_policy" {
  name                 = "hybrid-benefits-vm"
  policy_definition_id = azurerm_policy_definition.vm_benefits_policy.id
  management_group_id    = data.azurerm_management_group.mg.id  ## Optional if you want to store the policy at the same location
  display_name =  "VM - Enable Hybrid Benefits on Windows Virtual Machines"
  metadata = <<METADATA
  {
  "category": "compute"
  }
  METADATA

  lifecycle {
    ignore_changes = [
      not_scopes
    ]
  }
}



