// This module deploys a Virtual Network with a single subnet
// to support an AKS cluster deployment.

// =====================================
// === Parameters ===
// =====================================

param location string
param vnetName string
param subnetName string

// =====================================
// === Resources ===
// =====================================

// Define the Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.1.0/24'

          // Define ACR and Monitor endpoints
          serviceEndpoints: [
            {
              service: 'Microsoft.ContainerRegistry'
            }
            {
              service: 'Microsoft.Insights'
            }
          ]
        }
      }
    ]
  }
}

// =====================================
// === Outputs ===
// =====================================

output vnetId string = vnet.id
output subnetId string = vnet.properties.subnets[0].id
