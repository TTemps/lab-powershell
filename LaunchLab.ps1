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

function launchLab {
    param (
        #[System.ComponentModel.BackgroundWorker]$BackgroundWorker,
        [parameter(Mandatory=$true)]
        [string]$dcName,                        #srv-DC-TTemps
        [parameter(Mandatory=$true)]
        [string]$dcOS,                          #WS2022DC
        [parameter(Mandatory=$true)]
        [string]$ipAddressDC,                   #192.168.100.2
        [parameter(Mandatory=$true)]
        [string]$defaultGateway,                #192.168.100.1
        [parameter(Mandatory=$true)]
        [string]$localAccountLogin,             #Administrateur
        [parameter(Mandatory=$true)]
        [string]$localAccountPassword,          #Pa$$w0rd
        [parameter(Mandatory=$true)]
        [string]$domainName,                    #lab.local
        [parameter(Mandatory=$true)]
        [string]$domainNetBIOS,                 #LAB
        [parameter(Mandatory=$true)]
        [string]$domainAdmin,                   #Administrateur
        [parameter(Mandatory=$true)]
        [string]$domainAdminPassword,           #Pa$$w0rd
        [parameter(Mandatory=$true)]
        [string]$dhcpScopeStartRange,           #192.168.100.100
        [parameter(Mandatory=$true)]
        [string]$dhcpScopeEndRange,             #192.168.100.200
        [parameter(Mandatory=$true)]
        [string]$dhcpScopeSubnetMask,           #255.255.255.0
        [parameter(Mandatory=$true)]
        [string]$dhcpScopeName,                 #MyDHCPScope
        [parameter(Mandatory=$true)]
        [string]$dhcpScopeDescription,          #My DHCP Scope
        [parameter(Mandatory=$true)]
        [string]$vmSrvOs,                       #WS2022DC
        [parameter(Mandatory=$true)]
        [string]$vmSrvName,                     #srv-TTemps
        [parameter(Mandatory=$true)]
        [int]$nbVmSrv,                          #=3
        [parameter(Mandatory=$true)]
        [bool]$debugVerbose                            #false
    )
    #$BackgroundWorker.ReportProgress(0)
    $credentialsDC = New-Credential -login $localAccountLogin -pass $localAccountPassword # Change this to the credentials of the domain controller
    $credentialsDCDomain = New-Credential -login "$domainAdmin@$domainName" -pass $domainAdminPassword
    $dhcpServer = "$dcName.$domainName"

    
    # display verbose message if debug is true
    if ($debug) {
        $VerbosePreference = "Continue"
    } else {
        $VerbosePreference = "SilentlyContinue"
    }
    Remove-AllVMs # Ensure that all VMs are removed before starting the lab
    #$BackgroundWorker.ReportProgress(10)
    Write-Verbose "Checking if the VM already exists..."
    if (-not(Get-VM -Name $dcName -ErrorAction SilentlyContinue)) {
        Write-Verbose "VM does not exist, creating it..." 
        New-VM-TTemps -vmName $dcName -vmOS $dcOS
        #$BackgroundWorker.ReportProgress(20)
    }
    else {
        Write-Verbose "VM already exists, starting it..." 
        Start-VM -Name $dcName
    }

    # Wait until the vm is fully start
    Wait-VM -Name $dcName
    #$BackgroundWorker.ReportProgress(30)
    # script change name and change ip 
    $scriptChangeIPandName = {
        $currentName = (Get-WmiObject -Class Win32_ComputerSystem).Name
        if ($currentName -ne $Using:dcName) {
            try {
                Write-Verbose "Changing the computer name to $Using:dcName..." 
                Rename-Computer -NewName $Using:dcName -Force
            }
            catch {
                Write-Error "Error when changing the computer name. Details: $_"
            }
        }
        
        $networkInterface = (Get-NetAdapter | Where-Object {$_.InterfaceAlias -eq "Ethernet 2"}).Name

        try {
            Write-Verbose "Changing the IP address to $Using:ipAddressDC..." 
            $ipAddress = Get-NetIPAddress -InterfaceAlias $networkInterface -IPAddress $Using:ipAddressDC -ErrorAction SilentlyContinue
            if ($ipAddress) {
                Remove-NetIPAddress -InterfaceAlias $networkInterface -IPAddress $Using:ipAddressDC -Confirm:$false
            }
            Write-Verbose "Adding the IP address to the network interface..."  
            New-NetIPAddress -InterfaceAlias $networkInterface -IPAddress $Using:ipAddressDC -PrefixLength 24 -AddressFamily IPv4
            $route = Get-NetRoute -InterfaceAlias $networkInterface -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue
            if ($route) {
                Remove-NetRoute -InterfaceAlias $networkInterface -DestinationPrefix '0.0.0.0/0' -Confirm:$false
            }
            Write-Verbose "Adding the default gateway to the network interface..." 
            New-NetRoute -InterfaceAlias $networkInterface -DestinationPrefix 0.0.0.0/0 -NextHop $Using:defaultGateway
            # Add DNS server
            Write-Verbose "Adding DNS server" 
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
    #$BackgroundWorker.ReportProgress(50)
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
    #$BackgroundWorker.ReportProgress(60)

    # Script that install dhcp feature and create a scope
    $scriptCreateDHCP = {
        Write-Verbose "Installing DHCP feature" 
        # Install the DHCP Server feature
        try {
            Install-WindowsFeature -Name 'DHCP' -IncludeManagementTools 
        }
        catch {
            Write-Error "Error when installing the DHCP Server feature. Details: $_"
        }
        # Start the DHCP Server service
        Write-Verbose "Starting DHCP Server service" 
        try {
            Start-Service -Name 'DHCPServer' 
        }
        catch {
            Write-Error "Error when starting the DHCP Server service. Details: $_"
        }

        # Add the new DHCP scope
        try {
            Write-Verbose "Adding DHCP scope" 
            Add-DhcpServerv4Scope -StartRange $Using:dhcpScopeStartRange -EndRange $Using:dhcpScopeEndRange -SubnetMask $Using:dhcpScopeSubnetMask -Name $Using:dhcpScopeName -Description $Using:dhcpScopeDescription 
            # Authorize the DHCP server
            Write-Verbose "Authorizing DHCP server" 
            Add-DhcpServerInDC -DnsName $Using:dhcpServer 

            # Specify the DNS server for the DHCP scope
            $dnsServerIP = "$Using:ipAddressDC" # Change this to the IP address of your DNS server
            Write-Verbose "Setting DNS server for DHCP scope" 
            Set-DhcpServerv4OptionValue -DnsServer $dnsServerIP 

            # Add the DHCP console to the server
            Write-Verbose "Adding DHCP console to the server" 
            Add-WindowsFeature RSAT-DHCP 
            Write-Verbose "DHCP configured !" 
            Set-ItemProperty -Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
        }
        catch {
            Write-Error "Error when adding the DHCP scope. Details: $_"
        }
        
    }
    Invoke-Command -VMName $dcName -ScriptBlock $scriptCreateDHCP -Credential $credentialsDCDomain
    #$BackgroundWorker.ReportProgress(70)
    for ($i = 0; $i -lt $nbVmSrv; $i++) {
        $nameVM = "$vmSrvName-$i" #TODO changer le nom 
        if (-not(Get-VM -Name $nameVM -ErrorAction SilentlyContinue)) {
            Write-Verbose "VM does not exist, creating it..." 
            New-VM-TTemps -vmName $nameVM -vmOS $vmSrvOs
        }
        else {
            Write-Verbose "VM already exists, starting it..." 
            if ((Get-VM -Name $nameVM).State -eq "Off") {
                Start-VM -Name $nameVM
            }
        }
    }
    #$BackgroundWorker.ReportProgress(80)
    # get the lsit of every vm nammed "srv-TTemps-*"
    $listVMs = Get-VM | Where-Object { $_.Name -like "srv-TTemps-*"}
    foreach ($vm in $listVMs) {
        # Configure DHCP network settings
        Start-Sleep -Seconds 10
        $nameVM = $vm.Name
        Wait-VM -Name $nameVM
        $scriptConfigureDHCP = {
            Write-Verbose "Configuring network settings using DHCP..." 
            Write-Verbose "Joining the domain..." 
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
    #$BackgroundWorker.ReportProgress(100)
}
. .\labFunctions.ps1
<# LaunchLab -dcName "srv-DC-TTemps" `
          -dcOS "WS2022DC" `
          -ipAddressDC "192.168.100.2" `
          -defaultGateway "192.168.100.1" `
          -localAccountLogin "Administrateur" `
          -localAccountPassword 'Pa$$w0rd' `
          -domainName "lab.local" `
          -domainNetBIOS "LAB" `
          -domainAdmin "Administrateur" `
          -domainAdminPassword 'Pa$$w0rd' `
          -dhcpScopeStartRange "192.168.100.100" `
          -dhcpScopeEndRange "192.168.100.200" `
          -dhcpScopeSubnetMask "255.255.255.0" `
          -dhcpScopeName "MyDHCPScope" `
          -dhcpScopeDescription "My DHCP Scope" `
          -vmSrvOs "WS2022DC" `
          -vmSrvName "srv-TTemps" `
          -nbVmSrv 3 `
          -debugVerbose $true #>