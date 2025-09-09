param (
    [Parameter(Mandatory=$true)]
    [string]$resourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$vmName,

    [Parameter(Mandatory=$true)]
    [string]$newVMSize
)

Connect-AzAccount -Identity

try {
    Write-Output "Deallocating VM '$vmName' in resource group '$resourceGroupName'..."
    Stop-AzVM -resourceGroupName $resourceGroupName -Name $vmName -Force

    Write-Output "VM '$vmName' deallocated. Resizing to '$newVMSize'..."
    $vm = Get-AzVM -resourceGroupName $resourceGroupName -Name $vmName
    $vm.HardwareProfile.VmSize = $newVMSize
    Update-AzVM -VM $vm -resourceGroupName $resourceGroupName

    Write-Output "VM '$vmName' successfully resized to '$newVMSize'. Starting VM..."
    Start-AzVM -resourceGroupName $resourceGroupName -Name $vmName

    Write-Output "VM '$vmName' started successfully."
}
catch {
    Write-Error "An error occurred during VM resizing: $($_.Exception.Message)"
    throw $_.Exception # Re-throw to indicate runbook failure
}