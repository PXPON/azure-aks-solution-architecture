// This file will orchestrate the deployemnt of the AKS soluiton architecture
// It will call the individual modules of each component

// =====================================
// === Parameters ===
// =====================================

@description('The name of the application or solution')
param solutionName string = 'aks-demo'

@description('The Azure region to deploy the resources')
param location string = resourceGroup().location

@description('The SKu for the ACR')
param acrSku string = 'Basic'

// =====================================
// === Variables ===
// =====================================

var acrName = 'acr${uniqueString(resourceGroup().id)}'
var aksClusterName = '${solutionName}-aks'
var fluxExtensionName = '${solutionName}-lux'
var vnetName = '${solutionName}-vnet'
var subnetName = '${solutionName}-subnet'

// =====================================
// === Module Deployemnts ===
// =====================================

// Deploy the Azure Container Registry
module acr 'modules/acr.bicep' = {
  name: 'acr-deployment'
  params: {
    acrName: acrName
    location: location
    acrSku: acrSku
  }
}

// Deploy the Virtual Network
module network 'modules/network.bicep' = {
  name: 'network-deployment'
  params: {
    location: location
    vnetName: vnetName
    subnetName: subnetName
  }
}

// Deploy the AKS Cluster
module aks 'modules/aks.bicep' = {
  name: 'aks-deployemnt'
  params: {
    acrLoginServer: acr.outputs.acrLoginServer
    aksClusterName: aksClusterName
    location: location
    subnetId: network.outputs.subnetId
  }
}

// =====================================
// === Outputs ===
// =====================================

// Return the Public IP adress of the AKS Ingress Controller
output aksClusterNameOutput string = aks.outputs.aksClusterId
