<#
.SYNOPSIS
    Creates a new virtual machine using a specified name and operating system.

.DESCRIPTION
    The New-VM-TTemps function creates a new virtual machine by copying a master VHDX file to the VMs folder and configuring the necessary settings.
    It checks if the VMs folder and the Masters folder exist, if a VM with the same name already exists, and if the master VHDX file for the specified operating system exists.
    If all the checks pass, it creates a new VM, sets the guest services, sets the boot order, disables automatic snapshot creation, and starts the VM.

.PARAMETER vmName
    The name of the virtual machine to be created.

.PARAMETER vmOS
    The operating system of the virtual machine. Valid values are: W10, W11, WS2022, WS2022DC, WS2019, WS2019DC.

.EXAMPLE
    New-VM-TTemps -vmName "MyVM" -vmOS "W10"

.NOTES
    Author: Tristan Morel
    Date: 22/04/2022
#>
function New-VM-TTemps {
    param (
        [Parameter(Mandatory=$true)]
        [string]$vmName,
        [Parameter(Mandatory=$true)]
        [string]$vmOS # W10, W11, WS2022, WS2022DC, WS2019, WS2019DC
    )
    # Check if the Vms folder exists
    if (-not (Test-Path "$env:windir\VMs")) {
        New-Item -Path "$env:windir\VMs" -ItemType Directory
        Write-host "VMs folder created"
    }
    
    # Check if the Masters folder exists
    if (-not (Test-Path "Masters")) {
        Write-Host "Masters folder not found. Exiting..."
        Exit
    }
    # Check if a vmdisk named the same as the VM already exists
    if (Test-Path "$env:windir\VMs\$vmName.vhdx") {
        Write-Host "A VM with the same name already exists. Exiting..."
        Exit
    }
    # Check if the master file exists
switch ($vmOS) {
    "W10" { 
        if (Test-Path "Masters\ModeleW10.vhdx") {
            Copy-Item  -Path "Masters\ModeleW10.vhdx" -Destination "$env:windir\VMs\$vmName.vhdx" -Force
        } else {
            Write-Host "Master VHDX file not found. Exiting..."
            Exit
        }
    }
    "W11" {
        if (Test-Path "Masters\ModeleW11.vhdx") {
            Copy-Item  -Path "Masters\ModeleW11.vhdx" -Destination "$env:windir\VMs\$vmName.vhdx" -Force
        } else {
            Write-Host "Master VHDX file not found. Exiting..."
            Exit
        }
    }
    "WS2022" {
        if (Test-Path "Masters\ModeleW22.vhdx") {
            Copy-Item  -Path "Masters\ModeleW22.vhdx" -Destination "$env:windir\VMs\$vmName.vhdx" -Force
        } else {
            Write-Host "Master VHDX file not found. Exiting..."
            Exit
        }
    }
    "WS2022DC" {
        if (Test-Path "Masters\ModeleW22DC.vhdx") {
            Copy-Item  -Path "Masters\ModeleW22DC.vhdx" -Destination "$env:windir\VMs\$vmName.vhdx" -Force
        } else {
            Write-Host "Master VHDX file not found. Exiting..."
            Exit
        }
    }
    Default {
        Write-Host "Invalid OS. Exiting..."
        Exit
    }
}
    # Create a new VM
    New-VM -Name $vmName -Path "$env:windir\VMs" -VHDPath "$env:windir\VMs\$vmName.vhdx" -MemoryStartupBytes 1GB -Generation 2 -SwitchName "NOLAN" 
    # Set the guest services
    Enable-VMIntegrationService -VMName $vmName -Name "Guest Service Interface"
    # Set the boot order to boot from the virtual disk
    Set-VMFirmware -VMName $vmName -FirstBootDevice (Get-VMHardDiskDrive -VMName $vmName) 
    # Disable automatic snapshot creation for a VM
    Set-VM -Name $vmName -CheckpointType Disabled

    # Start the VM
    Start-VM -Name $vmName
}

<#
.SYNOPSIS
    Removes all virtual machines.

.DESCRIPTION
    The Remove-AllVMs function removes all virtual machines by shutting them down, deleting their virtual hard disk files, and removing the VMs and their associated files.

.EXAMPLE
    Remove-AllVMs

.NOTES
    Author: Tristan Morel
    Date: 22/04/2022
#>
function Remove-AllVMs {
    # Get all VMs
    $vms = Get-VM

    # Remove each VM
    foreach ($vm in $vms) {
        # Check if the VM is online
        if ($vm.State -eq 'Running') {
            # Shutdown the VM
            Stop-VM -VM $vm -Force
        }
        $vmPath = (Get-VM -Name $vm.name| Select-Object -Property Path).Path
        $path=(Get-VMHardDiskDrive $vm).Path
        Remove-Item -Path $path -Force -Recurse
        Remove-VM -VM $vm -Force
        Remove-Item -Path $vmPath -Force -Recurse
    }
}

<#
.SYNOPSIS
    Creates a new PSCredential object.

.DESCRIPTION
    The New-Credential function creates a new PSCredential object using the specified login and password.

.PARAMETER login
    The login name for the credential.

.PARAMETER pass
    The password for the credential.

.EXAMPLE
    $credentials = New-Credential -login "username" -pass "password"

.NOTES
    Author: Tristan Morel
    Date: 22/04/2022
#>
function New-Credential {
    param (
        [Parameter(Mandatory=$true)]
        [string]$login,
        [Parameter(Mandatory=$true)]
        [string]$pass
    )
    $securePassword = ConvertTo-SecureString -String $pass -AsPlainText -Force
    $credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $login, $securePassword
    return $credentials
}

<#
.SYNOPSIS
    Waits for a virtual machine to be ready.

.DESCRIPTION
    The Wait-VM function waits for a virtual machine to be ready by checking the operational status of the Heartbeat integration service.
    It waits for 20 seconds initially and then checks the operational status every 5 seconds until it is "OK".

.PARAMETER Name
    The name of the virtual machine to wait for.

.EXAMPLE
    Wait-VM -Name "MyVM"

.NOTES
    Author: Tristan Morel
    Date: 22/04/2022
#>
function Wait-VM {
    param($Name)
    Start-sleep -Seconds 20
    do {
        $heartbeatStatus = Get-VMIntegrationService -VMName $Name | Where-Object { $_.Name -eq "Heartbeat" }
        if ($heartbeatStatus.OperationalStatus -ne "OK") {
            Write-Verbose "$Name not ready. Waiting" -Verbose
            Start-Sleep -Seconds 5
        }
    } while ($heartbeatStatus.OperationalStatus -ne "OK")

    Write-Verbose "$Name is ready." -Verbose
}

<#
.SYNOPSIS
    Finds disabled user accounts in Active Directory and enables them.

.DESCRIPTION
    The Find-DisabledUser function searches for disabled user accounts in Active Directory, excluding the built-in accounts "Invité" and "krbtgt".
    It displays the disabled users in a grid view and allows the user to select one or more users to enable.
    If a user is selected, the function enables the selected user accounts.

.EXAMPLE
    Find-DisabledUser

.NOTES
    Author: Tristan Morel
    Date: 22/04/2022
#>
function Find-DisabledUser {
    try {
        Import-Module ActiveDirectory
    } 
    catch {
        # Handle the error if the ActiveDirectory module is not available
    }
    
    # Search for disabled user accounts
    $disabledUsers = Get-ADUser -Filter 'Enabled -eq $false' | Where-Object { $_.SamAccountName -ne 'Invité' -and $_.SamAccountName -ne 'krbtgt' } | Select-Object SamAccountName, Name, Enabled
    
    # Display the disabled users in a grid view and allow the user to select one or more users
    $selectedUsers = $disabledUsers | Out-GridView -Title "Select a user to enable" -PassThru
    
    # Check if a user was selected
    if ($selectedUsers) {
        foreach ($user in $selectedUsers) {
            # Enable the selected user account
            Enable-ADAccount -Identity $user.SamAccountName
    
            Write-Host "User $($user.SamAccountName) has been enabled."
        }
    } else {
        Write-Host "No user was selected."
    }
}
