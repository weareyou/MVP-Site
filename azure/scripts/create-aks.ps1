param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $Region = 'westeurope',
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $ResourceGroupName,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $AksName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $AzureWindowsPassword
)

$aksVersion = "1.19.11"

# create AKS instance
Write-Host "--- Creating AKS Instance K8s version $aksVersion ---" -ForegroundColor Cyan

az aks create --resource-group $ResourceGroupName `
    --name $AksName `
    --kubernetes-version $aksVersion `
    --location $Region `
    --windows-admin-password $AzureWindowsPassword `
    --windows-admin-username azureuser `
    --vm-set-type VirtualMachineScaleSets `
    --node-count 1 `
    --generate-ssh-keys `
    --network-plugin azure `
    --enable-addons monitoring `
    --nodepool-name 'linux' `
    --node-vm-size Standard_D2s_v4 `
    --zones 1  

Write-Host "--- Complete: AKS Created ---" -ForegroundColor Green

# add windows server nodepool
Write-Host "--- Creating Windows Server Node Pool ---" -ForegroundColor Cyan

az aks nodepool add --resource-group $ResourceGroupName `
    --cluster-name $AksName `
    --os-type Windows `
    --name 'win' `
    --node-vm-size Standard_D4s_v4 `
    --node-count 1 `
    --zones 1

Write-Host "--- Complete: Windows Server Node Pool Created ---" -ForegroundColor Green

# authenticate AKS instance
Write-Host "--- Get credentials for k8s cluster ---" -ForegroundColor Cyan

az aks get-credentials --admin `
    --resource-group $ResourceGroupName `
    --name $AksName `
    --overwrite-existing

Write-Host "--- Complete: Credentials for k8s cluster retrieved ---" -ForegroundColor Green

#Way_2021!-SC10AKS