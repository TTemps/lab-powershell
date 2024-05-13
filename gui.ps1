Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = 'LaunchLab Parameters'
### DC Name
$dcNameLabel = New-Object System.Windows.Forms.Label
$dcNameLabel.Location = New-Object System.Drawing.Point(10, 20)
$dcNameLabel.Size = New-Object System.Drawing.Size(100, 20)
$dcNameLabel.Text = 'DC Name:'
$form.Controls.Add($dcNameLabel)

$dcNameTextBox = New-Object System.Windows.Forms.TextBox
$dcNameTextBox.Location = New-Object System.Drawing.Point(150, 20)
$dcNameTextBox.Size = New-Object System.Drawing.Size(100, 20)
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
$dcOSComboBox.Size = New-Object System.Drawing.Size(100, 20)
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
$dcIPTextBox.Size = New-Object System.Drawing.Size(100, 20)
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
$dcGatewayTextBox.Size = New-Object System.Drawing.Size(100, 20)
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
$dcLocalAccountTextBox.Size = New-Object System.Drawing.Size(100, 20)
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
$dcLocalPasswordTextBox.Size = New-Object System.Drawing.Size(100, 20)
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
$dcDomainTextBox.Size = New-Object System.Drawing.Size(100, 20)
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
$dcAdminAccountTextBox.Size = New-Object System.Drawing.Size(100, 20)
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
$dcAdminPasswordTextBox.Size = New-Object System.Drawing.Size(100, 20)
$dcAdminPasswordTextBox.Text = 'Pa$$w0rd'
$form.Controls.Add($dcAdminPasswordTextBox)
### End domain admin password

$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Location = New-Object System.Drawing.Point(10, 320)
$submitButton.Size = New-Object System.Drawing.Size(75, 23)
$submitButton.Text = 'Submit'
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
    if ($submitCountCheck -eq 19) {
        # Call the LaunchLab function with the parameters
    }
})
$form.Controls.Add($submitButton)

$form.ShowDialog()