// The module deploys an Azure Kubernetes Service (AKS) 
// cluster within an existing Virtual Network.

// =====================================
// === Parameters ===
// =====================================

param location string
param aksClusterName string
param subnetId string
param acrLoginServer string

// =====================================
// === Resources ===
// =====================================

// Define the Azure Kubernetes Service (AKS) Cluster
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-10-01' = {
  name: aksClusterName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
  properties: {
    kubernetesVersion: '1.28.3'
    dnsPrefix: aksClusterName
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: subnetId
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      serviceCidr: '10.0.3.0/24'
      dnsServiceIP: '10.0.3.10'
      dockerBridgeCidr: '172.17.0.1/16'
    }
    aadProfile: {
      enableAzureRBAC: true
      managed: true
    }
    identity: {
      type: 'SystemAssigned'
    }
  }
}

// Add a role assignment for the AKS managed identity to pull from ACR

resource acrPullRole 'Microsoft.Authorization/roleAssignment@2022-04-01' = {
  name: guid(aksCluster.id, acrLoginServer)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft. Authorization/roleDefinitions', '7f951384-b040-41f4-9088-6c75ab420a89') // ACR Pull Role
    principalId: aksCluster.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// =====================================
// === Outputs ===
// =====================================
output aksClusterId string = aksCluster.id

