. .\LaunchLab.ps1
. .\labFunctions.ps1
Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
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

        #launchLab -dcName $dcNameTextBox.Text -dcOS $(Get-OSVM($dcOSComboBox.Text)) -ipAddressDC $dcIPTextBox.Text -defaultGateway $dcGatewayTextBox.Text -localAccountLogin $dcLocalAccountTextBox.Text -localAccountPassword $dcLocalPasswordTextBox.Text -domainName $dcDomainTextBox.Text -domainNetBIOS $dcNetBIOSTextBox.Text -domainAdmin $dcAdminAccountTextBox.Text -domainAdminPassword $dcAdminPasswordTextBox.Text -dhcpScopeStartRange $dcDHCPScopeStartTextBox.Text -dhcpScopeEndRange $dcDHCPScopeEndTextBox.Text -dhcpScopeSubnetMask $dcDHCPScopeMaskTextBox.Text -dhcpScopeName $dcDHCPScopeNameTextBox.Text -dhcpScopeDescription $dcDHCPScopeDescriptionTextBox.Text -vmSrvOs $(Get-OSVM($vmSRVOSComboBox.Text)) -vmSrvName $vmSRVNameTextBox.Text -nbVmSrv $vmSRVNumbersTextBox.Text -debugVerbose $verbose
    }
})
$form.Controls.Add($submitButton)
$form.ShowDialog()
### End Submit Button