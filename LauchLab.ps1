<#
.SYNOPSIS
This script launches the lab by sourcing the labFunctions.ps1 script.

.DESCRIPTION
The LauchLab.ps1 script is used to start the lab by sourcing the labFunctions.ps1 script. The labFunctions.ps1 script contains the necessary functions and variables required for the lab.

.PARAMETER None
This script does not accept any parameters.

.EXAMPLE
.\LauchLab.ps1
This command will launch the lab by sourcing the labFunctions.ps1 script.

.NOTES
Author: Tristan Morel
Date: 22/04/2024
#>

. .\labFunctions.ps1
Remove-AllVMs

# Variables for the VM creation (need to be changed or asked to the users)
$dcName = "srv-DC-TTemps"
$vmOS = "WS2022DC"
$ipAddressDC = "192.168.100.2"
$defaultGateway = "192.168.100.1"
$credentialsDC = New-Credential -login "Administrateur" -pass 'Pa$$w0rd'
# Variable for the AD creation
$domainName = "lab.local"
$domainNetBIOS = "LAB"
$domainAdmin = "Administrateur"
$domainAdminPassword = 'Pa$$w0rd'
# Define the DHCP scope parameters
$dhcpScopeStartRange = "192.168.100.100" # Change this to the start of the IP address range for the DHCP scope
$dhcpScopeEndRange = "192.168.100.200" # Change this to the end of the IP address range for the DHCP scope
$dhcpScopeSubnetMask = "255.255.255.0" # Change this to the subnet mask for the DHCP scope
$dhcpScopeName = "MyDHCPScope" # Change this to the name of the DHCP scope
$dhcpScopeDescription = "My DHCP Scope" # Change this to the description of the DHCP scope
$dhcpServer = "$dcName.$domainName" # Change this to the FQDN of your DHCP server

# Check if the VM already exists
Write-Verbose "Checking if the VM already exists..." -Verbose
if (-not(Get-VM -Name $dcName -ErrorAction SilentlyContinue)) {
    Write-Verbose "VM does not exist, creating it..." -Verbose
    New-VM-TTemps -vmName $dcName -vmOS $vmOS
}
else {
    Write-Verbose "VM already exists, starting it..." -Verbose
    Start-VM -Name $dcName
}

# Wait until the vm is fully start
Wait-VM -Name $dcName

# script change name and change ip 
$scriptChangeIPandName = {
    $currentName = (Get-WmiObject -Class Win32_ComputerSystem).Name
    if ($currentName -ne $Using:dcName) {
        try {
            Write-Verbose "Changing the computer name to $Using:dcName..." -Verbose
            Rename-Computer -NewName $Using:dcName -Force
        }
        catch {
            Write-Error "Error when changing the computer name. Details: $_"
        }
    }
    
    $networkInterface = (Get-NetAdapter | Where-Object {$_.InterfaceAlias -eq "Ethernet 2"}).Name

    try {
        Write-Verbose "Changing the IP address to $Using:ipAddressDC..." -Verbose
        $ipAddress = Get-NetIPAddress -InterfaceAlias $networkInterface -IPAddress $Using:ipAddressDC -ErrorAction SilentlyContinue
        if ($ipAddress) {
            Remove-NetIPAddress -InterfaceAlias $networkInterface -IPAddress $Using:ipAddressDC -Confirm:$false
        }
        Write-Verbose "Adding the IP address to the network interface..." -Verbose 
        New-NetIPAddress -InterfaceAlias $networkInterface -IPAddress $Using:ipAddressDC -PrefixLength 24 -AddressFamily IPv4
        $route = Get-NetRoute -InterfaceAlias $networkInterface -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue
        if ($route) {
            Remove-NetRoute -InterfaceAlias $networkInterface -DestinationPrefix '0.0.0.0/0' -Confirm:$false
        }
        Write-Verbose "Adding the default gateway to the network interface..." -Verbose
        New-NetRoute -InterfaceAlias $networkInterface -DestinationPrefix 0.0.0.0/0 -NextHop $Using:defaultGateway
        # Add DNS server
        Write-Verbose "Adding DNS server" -Verbose
        Set-DnsClientServerAddress -InterfaceAlias $networkInterface -ServerAddresses $Using:ipAddressDC
    }
    catch {
        Write-Error "Error when changing the IP address. Details: $_"
    }
    Restart-Computer -Force
}
Invoke-Command -VMName $dcName -ScriptBlock $scriptChangeIPandName -Credential $credentialsDC
# Wait until the vm is fully start
Wait-VM -Name $dcName

# script that ad feature and 
$scriptCreateAD = {
    
    $domainAdminSecurePassword = ConvertTo-SecureString -String $Using:domainAdminPassword -AsPlainText -Force
    $domainAdminCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Using:domainAdmin, $domainAdminSecurePassword

    try {
        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
        Install-ADDSForest -DomainName $Using:domainName -DomainNetBIOSName $Using:domainNetBIOS -SafeModeAdministratorPassword $domainAdminCreds.Password -Confirm:$false
    }
    catch {
        Write-Error "Error when installing the AD DS role. Details: $_"
    }
    Write-Host "AD DS role installed successfully."
}
Invoke-Command -VMName $dcName -ScriptBlock $scriptCreateAD -Credential $credentialsDC 

# New credential for the domain controller (changed because the domain is now created)
$credentialsDCDomain = New-Credential -login "$domainAdmin@$domainName" -pass "$domainAdminPassword"

# Wait until the vm is fully start
Wait-VM -Name $dcName

# Script that install dhcp feature and create a scope
$scriptCreateDHCP = {
    Write-Verbose "Installing DHCP feature" -Verbose
    # Install the DHCP Server feature
    try {
        Install-WindowsFeature -Name 'DHCP' -IncludeManagementTools -Verbose
    }
    catch {
        Write-Error "Error when installing the DHCP Server feature. Details: $_"
    }
    # Start the DHCP Server service
    Write-Verbose "Starting DHCP Server service" -Verbose
    try {
        Start-Service -Name 'DHCPServer' -Verbose
    }
    catch {
        Write-Error "Error when starting the DHCP Server service. Details: $_"
    }

    # Add the new DHCP scope
    try {
        Write-Verbose "Adding DHCP scope" -Verbose
        Add-DhcpServerv4Scope -StartRange $Using:dhcpScopeStartRange -EndRange $Using:dhcpScopeEndRange -SubnetMask $Using:dhcpScopeSubnetMask -Name $Using:dhcpScopeName -Description $Using:dhcpScopeDescription -Verbose
        # Authorize the DHCP server
        Write-Verbose "Authorizing DHCP server" -Verbose
        Add-DhcpServerInDC -DnsName $Using:dhcpServer -Verbose

        # Specify the DNS server for the DHCP scope
        $dnsServerIP = "$Using:ipAddressDC" # Change this to the IP address of your DNS server
        Write-Verbose "Setting DNS server for DHCP scope" -Verbose
        Set-DhcpServerv4OptionValue -DnsServer $dnsServerIP -Verbose

        # Add the DHCP console to the server
        Write-Verbose "Adding DHCP console to the server" -Verbose
        Add-WindowsFeature RSAT-DHCP -Verbose
        Write-Verbose "DHCP configured !" -Verbose
        Set-ItemProperty -Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
    }
    catch {
        Write-Error "Error when adding the DHCP scope. Details: $_"
    }
    
}
Invoke-Command -VMName $dcName -ScriptBlock $scriptCreateDHCP -Credential $credentialsDCDomain

$numbVm = 3

for ($i = 0; $i -lt $numbVm; $i++) {
    $nameVM = "srv-TTemps-$i" #TODO changer le nom 
    if (-not(Get-VM -Name $nameVM -ErrorAction SilentlyContinue)) {
        Write-Verbose "VM does not exist, creating it..." -Verbose
        New-VM-TTemps -vmName $nameVM -vmOS $vmOS
    }
    else {
        Write-Verbose "VM already exists, starting it..." -Verbose
        if ((Get-VM -Name $nameVM).State -eq "Off") {
            Start-VM -Name $nameVM
        }
    }
}
# get the lsit of every vm nammed "srv-TTemps-*"
$listVMs = Get-VM | Where-Object { $_.Name -like "srv-TTemps-*"}
foreach ($vm in $listVMs) {
    # Configure DHCP network settings
    Start-Sleep -Seconds 10
    $nameVM = $vm.Name
    Wait-VM -Name $nameVM
    $scriptConfigureDHCP = {
        Write-Verbose "Configuring network settings using DHCP..." -Verbose
        Write-Verbose "Joining the domain..." -Verbose
        try {
                # Try to join the domain
                Add-Computer -DomainName "lab.local" -Credential $Using:credentialsDCDomain -Restart -Force -NewName "$Using:nameVM"
        }
        catch [System.InvalidOperationException] {
            Write-Error "Failed to join the domain 'lab.local' from VM '$currentName'. Please check the domain name, network connectivity, DNS settings, and credentials."
        }
        catch {
            Write-Error "An unexpected error occurred: $_"
        }        
    }
    Invoke-Command -VMName $vm.Name -ScriptBlock $scriptConfigureDHCP -Credential $credentialsDC
}
$source = "C:\Users\Administrateur\Desktop\tp\Exo2\cop"
$destination = "C:\tp"
$vmName = "srv-DC-TTemps"

# Get all files in the source directory
$files = Get-ChildItem -Path $source -File -Recurse

# Copy each file
foreach ($file in $files) {
    $dest = Join-Path -Path $destination -ChildPath $file.Name
    Copy-VMFile -Name $vmName -SourcePath $file.FullName -DestinationPath $dest -FileSource Host
}