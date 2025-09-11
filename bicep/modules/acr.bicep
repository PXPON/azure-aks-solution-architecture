// This module will deploy an Azure Container Registry to
// store and manage Docker container images

// =====================================
// === Parameters ===
// =====================================
param acrName string
param location string
param acrSku string = 'Base'

// =====================================
// === Resources ===
// =====================================

// Define the Azure Container Registry
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    // Enabling an admin user to be quick and simple
    // Switch to a Managed Identity in production
    adminUserEnabled: true
  }
}

// =====================================
// === Outputs ===
// =====================================

output acrLoginServer string = acr.properties.loginServer
