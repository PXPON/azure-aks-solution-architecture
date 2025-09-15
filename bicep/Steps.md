# Create the Resource Group

az group create --name rg-aksnginx --location westus2

# Create a Deployment Group

az deployment group create --resource-group rg-aksnginx --template-file bicep/main.bicep --parameters solutionName='aks-demo'

