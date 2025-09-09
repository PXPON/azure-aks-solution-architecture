# Azure AKS Solution Architecture
This repository contains a comprehensive solution architecture for deploying a containerized application to Azure Kubernetes Service (AKS) using Infrastructure as Code (IaC) with Bicep.

# Project Overview
This project is a demonstration of designing and implementing a modern, scalable, and secure application platform on Microsoft Azure. The architecture is built entirely with Bicep to ensure repeatability and consistency, following the principles of IaC.

The deployed enviornment includes:
Virtual Network: A dedicated and isolated network for all resources.

Azure Container Registry (ACR): A private registry for storing and managing Docker container images.

Azure Kubernetes Service (AKS): A managed Kubernetes cluster for orchestrating containerized workloads.

GitOps (with Flux): The solution uses an AKS extension to enable automated application deployment directly from a Git repository, demonstrating a modern, declarative approach to Continuous Delivery.

# Architecture Diagram
(Coming soon)

# Bicep Deployment
The main.bicep file in this repository is a single, self-cotnained template that deploys the entire infrastructure. It demonstrates the ability to define a complete environment, from networking to application deployment, in one cohesive script.

