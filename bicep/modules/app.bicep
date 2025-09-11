// This module will deploy an application to an AKS Cluster using GitOps

// =====================================
// === Parameters ===
// =====================================

param location string
param aksClusterName string
param fluxExtensionName string

// =====================================
// === Resources ===
// =====================================

// Reference the existing AKS cluster to scope the extension
resource aks 'Microsoft.ContainerService/managedClusters@2024-01-01' existing = {
  name: aksClusterName
}

// Define the GitOps Flux extension
resource fluxExtension 'Microsoft.KubernetesConfiguration/extensions@2023-09-01' = {
  scope: aks
  name: fluxExtensionName
  properties: {
    extensionType: 'Microsoft.Flux'
    autoUpgradeMinorVersion: true
    scope: 'Cluster'
    configurationSettings: {
      'helm.versions': 'v3.12.3'
      'kustomize.versions': 'v5.1.1'
      'source-controller.version': 'v1.1.2'
    }
    configurationProtectedSettings: {
      'helm.secretRef': 'github-token'
    }
    sourceControlConfiguration: {
      repositoryUrl: 'https://github.com/Azure/gitops-flux2-kustomize-helm'
      referenceType: 'Branch'
      branch: 'main'
      clusterType: 'connectedCluster'
      syncIntervalInSeconds: 30

      // Refer to a simple program for an NGINX demo app
      repositorySubDirectory: './examples/hello-world'
    }
  }
}

// =====================================
// === Outputs ===
// =====================================

output fluxExtensionId string = fluxExtension.id
