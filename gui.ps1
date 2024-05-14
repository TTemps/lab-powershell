. '.\LaunchLab.ps1'
. '.\labFunctions.ps1'
Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon('./lab.ico')
$form.Text = 'Paramètres du Lab'
$form.Size = New-Object System.Drawing.Size(400, 680)
### DC Name
$dcNameTextBox = dcNameGUI -form $form
### DC OS
$dcOSComboBox = dcOSGUI -form $form
### IP address of the DC
$dcIPTextBox = dcIPGUI -form $form
### Gateway of the DC
$dcGatewayTextBox = dcGatewayGUI -form $form
### Local Account of the DC
$dcLocalAccountTextBox = dcLocalAccGUI -form $form
### Local Password of the DC
$dcLocalPasswordTextBox = dcLocalPwdGUI -form $form
### Domain of the DC
$dcDomainTextBox = dcDomainNameGUI -form $form
### NetBIOS Name of the DC
$dcNetBIOSTextBox = dcNetBiosGUI -form $form
### Admin Account of the DC
$dcAdminAccountTextBox = dcAdminAccGUI -form $form
### Admin Password of the DC
$dcAdminPasswordTextBox = dcAdminPwdGUI -form $form
### DHCP Scope Start
$dcDHCPScopeStartTextBox = dhcpScopeStartGUI -form $form
### DHCP Scope End
$dcDHCPScopeEndTextBox = dhcpScopeEndGUI -form $form
### DHCP Scope Mask
$dcDHCPScopeMaskTextBox = dhcpScopeMaskGUI -form $form
### DHCP Scope Name
$dcDHCPScopeNameTextBox = dhcpScopeNameGUI -form $form
### DHCP Scope Description
$dcDHCPScopeDescriptionTextBox = dhcpScopeDescriptionGUI -form $form
### VM SRV OS
$vmSRVOSComboBox = vmSrvOSGUI -form $form
### VM SRV Name
$vmSRVNameTextBox = vmSrvNameGUI -form $form
### VM SRV Numbers
$vmSRVNumbersTextBox = vmSrvNumGUI -form $form
### Verbose
$verboseCheckBox = verboseGUI -form $form
### Progress Bar
$progressBar = progressBarGUI -form $form
### Submit Button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Location = New-Object System.Drawing.Point(90, 590)
$submitButton.Size = New-Object System.Drawing.Size(200, 23)
$submitButton.Text = 'Lancer le Lab !'
$submitButton.Add_Click({
    $check = checkAllFields -form $form
    if ($verboseCheckBox.Checked) {
        $verbose = $true
    } else {
        $verbose = $false
    }
    if ($check -eq $true) {
        $jobParams = @{
            dcName = $dcNameTextBox.Text
            dcOS = $(Get-OSVM($dcOSComboBox.Text))
            ipAddressDC = $dcIPTextBox.Text
            defaultGateway = $dcGatewayTextBox.Text
            localAccountLogin = $dcLocalAccountTextBox.Text
            localAccountPassword = $dcLocalPasswordTextBox.Text
            domainName = $dcDomainTextBox.Text
            domainNetBIOS = $dcNetBIOSTextBox.Text
            domainAdmin = $dcAdminAccountTextBox.Text
            domainAdminPassword = $dcAdminPasswordTextBox.Text
            dhcpScopeStartRange = $dcDHCPScopeStartTextBox.Text
            dhcpScopeEndRange = $dcDHCPScopeEndTextBox.Text
            dhcpScopeSubnetMask = $dcDHCPScopeMaskTextBox.Text
            dhcpScopeName = $dcDHCPScopeNameTextBox.Text
            dhcpScopeDescription = $dcDHCPScopeDescriptionTextBox.Text
            vmSrvOs = $(Get-OSVM($vmSRVOSComboBox.Text))
            vmSrvName = $vmSRVNameTextBox.Text
            nbVmSrv = $vmSRVNumbersTextBox.Text
            debugVerbose = $verbose
        }
         # Starting the lab setup in the background
        $job = Start-Job -ScriptBlock {
            param($params)
            # The script block to run in the background job
            # The script run in the home directory of the current user
            # so to run the script correctly, it needs to be placed in the home directory of the current user + the relative path
            $basePath = Get-Location # Get the current location
            $relativePath = "\projects\lab-powershell\" # Set the relative path
            $fullPath = Join-Path -Path $basePath -ChildPath $relativePath # Join the paths
            Set-Location -Path $fullPath # Set the location to the full path
            . .\LaunchLab.ps1 # Load the LaunchLab script
            launchLab @params # Launch the lab
        } -ArgumentList $jobParams -Name "LaunchLabJob"
        $job | Wait-Job
        if ($job.State -eq "Completed") {
            $progressBar.Value = 100
            # Handle job completion
            Write-Verbose "Job completed with the following output:"
            $job | Receive-Job -Keep
            [System.Windows.Forms.MessageBox]::Show("Deployment completed successfully!", "Deployment Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $form.Close()

        } elseif ($job.State -eq "Failed") {
            # Handle job failure
            Write-Error "Job failed with the following output:"
            $job | Receive-Job -Keep
        } elseif ($job.State -eq "Stopped") {
            # Handle job being stopped
            Write-Error "Job was stopped"

        }
    }
})
$form.Add_FormClosing({
    param($sender, $e)
    if ($e.CloseReason -eq [System.Windows.Forms.CloseReason]::UserClosing) {
        $result = [System.Windows.Forms.MessageBox]::Show('Are you sure you want to close?', 'Confirm Closure', [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
        if ($result -ne 'Yes') {
            $e.Cancel = $true
            [System.Console]::WriteLine('')  # Clear any return value
        } else {
            [Environment]::Exit(0)  # Cleanly exit the application with no error code
        }
    }
})

$form.Controls.Add($submitButton)
$form.ShowDialog()
### End Submit Button