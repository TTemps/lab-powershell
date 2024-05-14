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
function dcNameGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcNameLabel = New-Object System.Windows.Forms.Label
    $dcNameLabel.Location = New-Object System.Drawing.Point(10, 20)
    $dcNameLabel.Size = New-Object System.Drawing.Size(100, 20)
    $dcNameLabel.Text = 'DC Name:'
    $form.Controls.Add($dcNameLabel)
    
    $dcNameTextBox = New-Object System.Windows.Forms.TextBox
    $dcNameTextBox.Location = New-Object System.Drawing.Point(150, 20)
    $dcNameTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcNameTextBox.Text = 'srv-DC-TTemps'
    $form.Controls.Add($dcNameTextBox)
    return $dcNameTextBox
}
function dcOSGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcOSLabel = New-Object System.Windows.Forms.Label
    $dcOSLabel.Location = New-Object System.Drawing.Point(10, 50)
    $dcOSLabel.Size = New-Object System.Drawing.Size(100, 20)
    $dcOSLabel.Text = 'DC OS:'
    $form.Controls.Add($dcOSLabel)

    $dcOSComboBox = New-Object System.Windows.Forms.ComboBox
    $dcOSComboBox.Location = New-Object System.Drawing.Point(150, 50)
    $dcOSComboBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcOSComboBox.Text = 'ModeleW22DC'
        # Get the names of all files in the folder and add them to the ComboBox
    $folderPath = '.\Masters'
    Get-ChildItem -Path $folderPath -File | ForEach-Object {
        if ($_.Name -match 'Modele(.*)\.vhdx') {
            $dcOSComboBox.Items.Add($_.Name -replace '\.vhdx$')
        }
        
    }
    $form.Controls.Add($dcOSComboBox)
    return $dcOSComboBox
}
function dcIPGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcIPLabel = New-Object System.Windows.Forms.Label
    $dcIPLabel.Location = New-Object System.Drawing.Point(10, 80)
    $dcIPLabel.Size = New-Object System.Drawing.Size(100, 20)
    $dcIPLabel.Text = 'DC IP Address:'
    $form.Controls.Add($dcIPLabel)
    
    $dcIPTextBox = New-Object System.Windows.Forms.TextBox
    $dcIPTextBox.Location = New-Object System.Drawing.Point(150, 80)
    $dcIPTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcIPTextBox.Text = '192.168.100.2'
    $form.Controls.Add($dcIPTextBox)
    return $dcIPTextBox
}
function dcGatewayGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcGatewayLabel = New-Object System.Windows.Forms.Label
    $dcGatewayLabel.Location = New-Object System.Drawing.Point(10, 110)
    $dcGatewayLabel.Size = New-Object System.Drawing.Size(100, 20)
    $dcGatewayLabel.Text = 'DC Gateway:'
    $form.Controls.Add($dcGatewayLabel)
    
    $dcGatewayTextBox = New-Object System.Windows.Forms.TextBox
    $dcGatewayTextBox.Location = New-Object System.Drawing.Point(150, 110)
    $dcGatewayTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcGatewayTextBox.Text = '192.168.100.1'
    $form.Controls.Add($dcGatewayTextBox)
    return $dcGatewayTextBox
}
function dcLocalAccGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcLocalAccountLabel = New-Object System.Windows.Forms.Label
    $dcLocalAccountLabel.Location = New-Object System.Drawing.Point(10, 140)
    $dcLocalAccountLabel.Size = New-Object System.Drawing.Size(100, 20)
    $dcLocalAccountLabel.Text = 'DC Local Account:'
    $form.Controls.Add($dcLocalAccountLabel)
    
    $dcLocalAccountTextBox = New-Object System.Windows.Forms.TextBox
    $dcLocalAccountTextBox.Location = New-Object System.Drawing.Point(150, 140)
    $dcLocalAccountTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcLocalAccountTextBox.Text = 'Administrateur'
    $form.Controls.Add($dcLocalAccountTextBox)
    return $dcLocalAccountTextBox
}function dcLocalPwdGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcLocalPasswordLabel = New-Object System.Windows.Forms.Label
    $dcLocalPasswordLabel.Location = New-Object System.Drawing.Point(10, 170)
    $dcLocalPasswordLabel.Size = New-Object System.Drawing.Size(120, 20)
    $dcLocalPasswordLabel.Text = 'DC Local Password:'
    $form.Controls.Add($dcLocalPasswordLabel)
    
    $dcLocalPasswordTextBox = New-Object System.Windows.Forms.TextBox
    $dcLocalPasswordTextBox.Location = New-Object System.Drawing.Point(150, 170)
    $dcLocalPasswordTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcLocalPasswordTextBox.Text = 'Pa$$w0rd'
    $form.Controls.Add($dcLocalPasswordTextBox)
    return $dcLocalPasswordTextBox
}
function dcDomainNameGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcDomainLabel = New-Object System.Windows.Forms.Label
    $dcDomainLabel.Location = New-Object System.Drawing.Point(10, 200)
    $dcDomainLabel.Size = New-Object System.Drawing.Size(100, 20)
    $dcDomainLabel.Text = 'DC Domain:'
    $form.Controls.Add($dcDomainLabel)
    
    $dcDomainTextBox = New-Object System.Windows.Forms.TextBox
    $dcDomainTextBox.Location = New-Object System.Drawing.Point(150, 200)
    $dcDomainTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcDomainTextBox.Text = 'lab.local'
    $form.Controls.Add($dcDomainTextBox)
    return $dcDomainTextBox
}
function dcNetBiosGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcNetBIOSLabel = New-Object System.Windows.Forms.Label
    $dcNetBIOSLabel.Location = New-Object System.Drawing.Point(10, 230)
    $dcNetBIOSLabel.Size = New-Object System.Drawing.Size(120, 20)
    $dcNetBIOSLabel.Text = 'DC NetBIOS Name:'
    $form.Controls.Add($dcNetBIOSLabel)
    
    $dcNetBIOSTextBox = New-Object System.Windows.Forms.TextBox
    $dcNetBIOSTextBox.Location = New-Object System.Drawing.Point(150, 230)
    $dcNetBIOSTextBox.Size = New-Object System.Drawing.Size(100, 20)
    $dcNetBIOSTextBox.Text = 'LAB'
    $form.Controls.Add($dcNetBIOSTextBox)
    return $dcNetBIOSTextBox
}
function dcAdminAccGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcAdminAccountLabel = New-Object System.Windows.Forms.Label
    $dcAdminAccountLabel.Location = New-Object System.Drawing.Point(10, 260)
    $dcAdminAccountLabel.Size = New-Object System.Drawing.Size(120, 20)
    $dcAdminAccountLabel.Text = 'DC Admin Account:'
    $form.Controls.Add($dcAdminAccountLabel)
    
    $dcAdminAccountTextBox = New-Object System.Windows.Forms.TextBox
    $dcAdminAccountTextBox.Location = New-Object System.Drawing.Point(150, 260)
    $dcAdminAccountTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcAdminAccountTextBox.Text = 'Administrateur'
    $form.Controls.Add($dcAdminAccountTextBox)
    return $dcAdminAccountTextBox
}
function dcAdminPwdGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcAdminPasswordLabel = New-Object System.Windows.Forms.Label
    $dcAdminPasswordLabel.Location = New-Object System.Drawing.Point(10, 290)
    $dcAdminPasswordLabel.Size = New-Object System.Drawing.Size(120, 20)
    $dcAdminPasswordLabel.Text = 'DC Admin Password:'
    $form.Controls.Add($dcAdminPasswordLabel)
    
    $dcAdminPasswordTextBox = New-Object System.Windows.Forms.TextBox
    $dcAdminPasswordTextBox.Location = New-Object System.Drawing.Point(150, 290)
    $dcAdminPasswordTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcAdminPasswordTextBox.Text = 'Pa$$w0rd'
    $form.Controls.Add($dcAdminPasswordTextBox)
    return $dcAdminPasswordTextBox
}
function dhcpScopeStartGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcDHCPScopeStartLabel = New-Object System.Windows.Forms.Label
    $dcDHCPScopeStartLabel.Location = New-Object System.Drawing.Point(10, 320)
    $dcDHCPScopeStartLabel.Size = New-Object System.Drawing.Size(120, 20)
    $dcDHCPScopeStartLabel.Text = 'DHCP Scope Start:'
    $form.Controls.Add($dcDHCPScopeStartLabel)
    
    $dcDHCPScopeStartTextBox = New-Object System.Windows.Forms.TextBox
    $dcDHCPScopeStartTextBox.Location = New-Object System.Drawing.Point(150, 320)
    $dcDHCPScopeStartTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcDHCPScopeStartTextBox.Text = '192.168.100.100'
    $form.Controls.Add($dcDHCPScopeStartTextBox)
    return $dcDHCPScopeStartTextBox
}
function dhcpScopeEndGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcDHCPScopeEndLabel = New-Object System.Windows.Forms.Label
    $dcDHCPScopeEndLabel.Location = New-Object System.Drawing.Point(10, 350)
    $dcDHCPScopeEndLabel.Size = New-Object System.Drawing.Size(120, 20)
    $dcDHCPScopeEndLabel.Text = 'DHCP Scope End:'
    $form.Controls.Add($dcDHCPScopeEndLabel)
    
    $dcDHCPScopeEndTextBox = New-Object System.Windows.Forms.TextBox
    $dcDHCPScopeEndTextBox.Location = New-Object System.Drawing.Point(150, 350)
    $dcDHCPScopeEndTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcDHCPScopeEndTextBox.Text = '192.168.100.200'
    $form.Controls.Add($dcDHCPScopeEndTextBox)
    return $dcDHCPScopeEndTextBox
}
function dhcpScopeMaskGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcDHCPScopeMaskLabel = New-Object System.Windows.Forms.Label
    $dcDHCPScopeMaskLabel.Location = New-Object System.Drawing.Point(10, 380)
    $dcDHCPScopeMaskLabel.Size = New-Object System.Drawing.Size(120, 20)
    $dcDHCPScopeMaskLabel.Text = 'DHCP Scope Mask:'
    $form.Controls.Add($dcDHCPScopeMaskLabel)
    
    $dcDHCPScopeMaskTextBox = New-Object System.Windows.Forms.TextBox
    $dcDHCPScopeMaskTextBox.Location = New-Object System.Drawing.Point(150, 380)
    $dcDHCPScopeMaskTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcDHCPScopeMaskTextBox.Text = '255.255.255.0'
    $form.Controls.Add($dcDHCPScopeMaskTextBox)
    return $dcDHCPScopeMaskTextBox
}
function dhcpScopeNameGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcDHCPScopeNameLabel = New-Object System.Windows.Forms.Label
    $dcDHCPScopeNameLabel.Location = New-Object System.Drawing.Point(10, 410)
    $dcDHCPScopeNameLabel.Size = New-Object System.Drawing.Size(120, 20)
    $dcDHCPScopeNameLabel.Text = 'DHCP Scope Name:'
    $form.Controls.Add($dcDHCPScopeNameLabel)
    
    $dcDHCPScopeNameTextBox = New-Object System.Windows.Forms.TextBox
    $dcDHCPScopeNameTextBox.Location = New-Object System.Drawing.Point(150, 410)
    $dcDHCPScopeNameTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcDHCPScopeNameTextBox.Text = 'LabScope'
    $form.Controls.Add($dcDHCPScopeNameTextBox)
    return $dcDHCPScopeNameTextBox
}
function dhcpScopeDescriptionGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $dcDHCPScopeDescriptionLabel = New-Object System.Windows.Forms.Label
    $dcDHCPScopeDescriptionLabel.Location = New-Object System.Drawing.Point(10, 440)
    $dcDHCPScopeDescriptionLabel.Size = New-Object System.Drawing.Size(120, 20)
    $dcDHCPScopeDescriptionLabel.Text = 'DHCP Scope Description:'
    $form.Controls.Add($dcDHCPScopeDescriptionLabel)
    
    $dcDHCPScopeDescriptionTextBox = New-Object System.Windows.Forms.TextBox
    $dcDHCPScopeDescriptionTextBox.Location = New-Object System.Drawing.Point(150, 440)
    $dcDHCPScopeDescriptionTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $dcDHCPScopeDescriptionTextBox.Text = 'LabScopeDescription'
    $form.Controls.Add($dcDHCPScopeDescriptionTextBox)
    return $dcDHCPScopeDescriptionTextBox
}
function vmSrvOSGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $vmSRVOSLabel = New-Object System.Windows.Forms.Label
    $vmSRVOSLabel.Location = New-Object System.Drawing.Point(10, 470)
    $vmSRVOSLabel.Size = New-Object System.Drawing.Size(120, 20)
    $vmSRVOSLabel.Text = 'VM SRV OS:'
    $form.Controls.Add($vmSRVOSLabel)
    
    $vmSRVOSComboBox = New-Object System.Windows.Forms.ComboBox
    $vmSRVOSComboBox.Location = New-Object System.Drawing.Point(150, 470)
    $vmSRVOSComboBox.Size = New-Object System.Drawing.Size(200, 20)
    $vmSRVOSComboBox.Text = 'ModeleW22DC'
        # Get the names of all files in the folder and add them to the ComboBox
    $folderPath = '.\Masters'
    Get-ChildItem -Path $folderPath -File | ForEach-Object {
        if ($_.Name -match 'Modele(.*)\.vhdx') {
            $vmSRVOSComboBox.Items.Add($_.Name -replace '\.vhdx$')
        }
        
    }
    $form.Controls.Add($vmSRVOSComboBox)
    return $vmSRVOSComboBox
}
function vmSrvNameGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $vmSRVNameLabel = New-Object System.Windows.Forms.Label
    $vmSRVNameLabel.Location = New-Object System.Drawing.Point(10, 500)
    $vmSRVNameLabel.Size = New-Object System.Drawing.Size(120, 20)
    $vmSRVNameLabel.Text = 'VM SRV Name:'
    $form.Controls.Add($vmSRVNameLabel)
    
    $vmSRVNameTextBox = New-Object System.Windows.Forms.TextBox
    $vmSRVNameTextBox.Location = New-Object System.Drawing.Point(150, 500)
    $vmSRVNameTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $vmSRVNameTextBox.Text = 'srv-VM-TTemps'
    $form.Controls.Add($vmSRVNameTextBox)
    return $vmSRVNameTextBox
}
function vmSrvNumGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $vmSRVNumbersLabel = New-Object System.Windows.Forms.Label
    $vmSRVNumbersLabel.Location = New-Object System.Drawing.Point(10, 530)
    $vmSRVNumbersLabel.Size = New-Object System.Drawing.Size(120, 20)
    $vmSRVNumbersLabel.Text = 'VM SRV Numbers:'
    $form.Controls.Add($vmSRVNumbersLabel)
    
    $vmSRVNumbersTextBox = New-Object System.Windows.Forms.TextBox
    $vmSRVNumbersTextBox.Location = New-Object System.Drawing.Point(150, 530)
    $vmSRVNumbersTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $vmSRVNumbersTextBox.Text = '1'
    $form.Controls.Add($vmSRVNumbersTextBox)
    return $vmSRVNumbersTextBox
}
function verboseGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $verboseCheckBox = New-Object System.Windows.Forms.CheckBox
    $verboseCheckBox.Location = New-Object System.Drawing.Point(10, 560)
    $verboseCheckBox.Size = New-Object System.Drawing.Size(120, 20)
    $verboseCheckBox.Text = 'Verbose'
    $form.Controls.Add($verboseCheckBox)
    return $verboseCheckBox
}
function progressBarGUI {
    param (
        [System.Windows.Forms.Form]$form
    )
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Point(10, 590)
    $progressBar.Size = New-Object System.Drawing.Size(70, 23)
    $progressBar.Style = 'Continuous'
    $progressBar.Visible = $true
    $form.Controls.Add($progressBar)
    return $progressBar
}
function checkAllFields {
    param (
        [System.Windows.Forms.Form]$form
    )
    $fields = $form.Controls | Where-Object { $_.GetType().Name -eq 'TextBox' -or $_.GetType().Name -eq 'ComboBox' }
    foreach ($field in $fields) {
        if ($field.Text -eq '') {
            [System.Windows.Forms.MessageBox]::Show('All fields must be filled.', 'Error', 'OK', 'Error')
            return $false
        }
    }
    return $true
}
function Get-OSVM {
    param (
        [string]$OSComboBox
    )
    switch ($OSComboBox) {
        "ModeleW22DC" { 
            $OS = "WS2022DC" 
        }
        "ModeleW10" { 
            $OS = "W10" 
        }
        "ModeleW11" { 
            $OS = "W11" 
        }
        "ModeleW22" { 
            $OS = "WS2022" 
        }
        Default {
            Write-Host "Invalid OS. Exiting..."
            Exit
        }
    }
    return $OS
}
