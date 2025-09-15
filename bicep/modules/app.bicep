// This module will deploy an application to an AKS Cluster using GitOps

// =====================================
// === Parameters ===
// =====================================

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
    configurationSettings: {}
  }
}

// Define a Flux configuration to sync from a Git repo
resource fluxConfig 'Microsoft.KubernetesConfiguration/fluxConfigurations@2023-05-01' = {
  scope: aks
  name: 'hello-world'
  properties: {
    scope: 'cluster'
    namespace: 'flux-system'
    sourceKind: 'GitRepository'
    gitRepository: {
      url: 'https://github.com/Azure/gitops-flux2-kustomize-helm'
      repositoryRef: {
        branch: 'main'
      }
      syncIntervalInSeconds: 30
    }
    kustomizations: {
      app: {
        path: './examples/hello-world'
        prune: true
        syncIntervalInSeconds: 30
      }
    }
  }
  dependsOn: [
    fluxExtension
  ]
}

// =====================================
// === Outputs ===
// =====================================

output fluxExtensionId string = fluxExtension.id
