#. .\LaunchLab.ps1
Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Paramètres du Lab'
$form.Size = New-Object System.Drawing.Size(400, 680)
### DC Name
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
### End DC Name
### DC OS
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
### End DC OS
### IP address of the DC
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
### End IP address of the DC
### default gateway
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
### End default gateway
### local Account Login
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
### End local Account Login
### local Account Password
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
### End local Account Password
### Domain Name
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
### End Domain Name
### Domain NetBIOS Name
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
### End Domain NetBIOS Name
### domain admin login
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
### End domain admin login
### domain admin password
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
### End domain admin password
### DHCP Scope Start Range
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
### End DHCP Scope Start Range
### DHCP Scope End Range
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
### End DHCP Scope End Range
### DHCP Scope Mask
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
### End DHCP Scope Mask
### DHCP Scope Name
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
### End DHCP Scope Name
### DHCP Scope Description
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
### End DHCP Scope Description
### VM SRV OS
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
### End VM SRV OS
### VM SRV Name
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
### End VM SRV Name
### VM SRV NUMBERS
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
### End VM SRV NUMBERS
### VERBOSE
$verboseCheckBox = New-Object System.Windows.Forms.CheckBox
$verboseCheckBox.Location = New-Object System.Drawing.Point(10, 560)
$verboseCheckBox.Size = New-Object System.Drawing.Size(120, 20)
$verboseCheckBox.Text = 'Verbose'
$form.Controls.Add($verboseCheckBox)
### End VERBOSE
### Submit Button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Location = New-Object System.Drawing.Point(90, 590)
$submitButton.Size = New-Object System.Drawing.Size(200, 23)
$submitButton.Text = 'Lancer le Lab !'
$submitButton.Add_Click({
    $submitCountCheck = 0
    if ($dcOSComboBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC OS is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        switch ($dcOSComboBox.Text) {
            "ModeleW22DC" { 
                $dcOS = "WS2022DC" 
            }
            "ModeleW10" { 
                $dcOS = "W10" 
            }
            "ModeleW11" { 
                $dcOS = "W11" 
            }
            "ModeleW22" { 
                $dcOS = "WS2022" 
            }
            Default {
                Write-Host "Invalid OS. Exiting..."
                Exit
            }
        }
        Write-Host $dcOS
        $submitCountCheck++
    }
    if ($dcNameTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC Name is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcNameTextBox.Text
        $submitCountCheck++
    }
    if ($dcIPTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC IP Address is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcIPTextBox.Text
        $submitCountCheck++
    }
    if ($dcGatewayTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC Gateway is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcGatewayTextBox.Text
        $submitCountCheck++
    }
    if ($dcLocalAccountTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC Local Account is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcLocalAccountTextBox.Text
        $submitCountCheck++
    }
    if ($dcLocalPasswordTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC Local Password is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcLocalPasswordTextBox.Text
        $submitCountCheck++
    }
    if ($dcDomainTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC Domain is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcDomainTextBox.Text
        $submitCountCheck++
    }
    if ($dcNetBIOSTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC NetBIOS Name is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcNetBIOSTextBox.Text
        $submitCountCheck++
    }
    if ($dcAdminAccountTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC Admin Account is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcAdminAccountTextBox.Text
        $submitCountCheck++
    }
    if ($dcAdminPasswordTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DC Admin Password is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcAdminPasswordTextBox.Text
        $submitCountCheck++
    }
    if ($dcDHCPScopeStartTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DHCP Scope Start is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcDHCPScopeStartTextBox.Text
        $submitCountCheck++
    }
    if ($dcDHCPScopeEndTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DHCP Scope End is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcDHCPScopeEndTextBox.Text
        $submitCountCheck++
    }
    if ($dcDHCPScopeMaskTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DHCP Scope Mask is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcDHCPScopeMaskTextBox.Text
        $submitCountCheck++
    }
    if ($dcDHCPScopeNameTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DHCP Scope Name is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcDHCPScopeNameTextBox.Text
        $submitCountCheck++
    }
    if ($dcDHCPScopeDescriptionTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('DHCP Scope Description is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $dcDHCPScopeDescriptionTextBox.Text
        $submitCountCheck++
    }
    if ($vmSRVOSComboBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('VM SRV OS is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        switch ($dcOSComboBox.Text) {
            "ModeleW22DC" { 
                $vmSRVOS = "WS2022DC" 
            }
            "ModeleW10" { 
                $vmSRVOS = "W10" 
            }
            "ModeleW11" { 
                $vmSRVOS = "W11" 
            }
            "ModeleW22" { 
                $vmSRVOS = "WS2022" 
            }
            Default {
                Write-Host "Invalid OS. Exiting..."
                Exit
            }
        }
        Write-Host $vmSRVOS
        $submitCountCheck++
    }
    if ($vmSRVNameTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('VM SRV Name is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $vmSRVNameTextBox.Text
        $submitCountCheck++
    }
    if ($vmSRVNumbersTextBox.Text -eq '') {
        [System.Windows.Forms.MessageBox]::Show('VM SRV Numbers is required', 'Error', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        Write-Host $vmSRVNumbersTextBox.Text
        $submitCountCheck++
    }
    if ($verboseCheckBox.Checked) {
        $verbose = $true
    } else {
        $verbose = $false
    }
    Write-Host $verbose
    if ($submitCountCheck -eq 18) {
        $progressForm = New-Object System.Windows.Forms.Form
        $progressForm.Text = 'Progress'
        $progressForm.Size = New-Object System.Drawing.Size(300, 100)

        # Create the progress bar
        $progressBar = New-Object System.Windows.Forms.ProgressBar
        $progressBar.Location = New-Object System.Drawing.Point(10, 10)
        $progressBar.Size = New-Object System.Drawing.Size(260, 20)
        $progressForm.Controls.Add($progressBar)
        # Show the progress form
        $progressForm.Show()
        # Create a background worker
        $backgroundWorker = New-Object System.ComponentModel.BackgroundWorker
        $backgroundWorker.WorkerReportsProgress = $true
        # Define what happens when the background worker starts
        $backgroundWorker.Add_DoWork({
            # Call the LaunchLab function here
            #LauchLab -dcOS $dcOS -dcName $dcNameTextBox.Text -dcIP $dcIPTextBox.Text -dcGateway $dcGatewayTextBox.Text -dcLocalAccount $dcLocalAccountTextBox.Text -dcLocalPassword $dcLocalPasswordTextBox.Text -dcDomain $dcDomainTextBox.Text -dcNetBIOS $dcNetBIOSTextBox.Text -dcAdminAccount $dcAdminAccountTextBox.Text -dcAdminPassword $dcAdminPasswordTextBox.Text -dcDHCPScopeStart $dcDHCPScopeStartTextBox.Text -dcDHCPScopeEnd $dcDHCPScopeEndTextBox.Text -dcDHCPScopeMask $dcDHCPScopeMaskTextBox.Text -dcDHCPScopeName $dcDHCPScopeNameTextBox.Text -dcDHCPScopeDescription $dcDHCPScopeDescriptionTextBox.Text -vmSRVOS $vmSRVOS -vmSRVName $vmSRVNameTextBox.Text -vmSRVNumbers $vmSRVNumbersTextBox.Text -verbose $verbose

        })
        # Define what happens when the background worker reports progress
        $backgroundWorker.Add_ProgressChanged({
            param($sender, $e)
            # Update the progress bar's value
            $progressBar.Value = $e.ProgressPercentage
        })
        # Define what happens when the background worker is done
        $backgroundWorker.Add_RunWorkerCompleted({
            # Display a message box when the progress bar is filled
            [System.Windows.Forms.MessageBox]::Show('Lab Deployed', 'Information', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

            # Close the progress form when done
            $progressForm.Close()
        })
        # Start the background worker
        $backgroundWorker.RunWorkerAsync()
    }
})
$form.Controls.Add($submitButton)
$form.ShowDialog()