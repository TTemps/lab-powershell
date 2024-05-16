# Virtual Lab Setup Tool

This PowerShell script provides a graphical user interface (GUI) to configure and launch virtual lab environments, including virtual machines (VMs), domain controllers (DCs), and DHCP scopes.

## Features

- **Executable programme** that can be run on Windows systems with PowerShell 5.1 or higher.
- **DC Configuration**: Setup domain controller with customizable options like name, OS, IP, and credentials.
- **DHCP Scope Configuration**: Define start and end IP ranges, subnet masks, and descriptions for scopes.
- **VM Configuration**: Setup VMs with options for operating system, number, and names.
- **Verbose Logging**: Optional verbose logging to provide detailed output during operations.

## Prerequisites

- Windows PowerShell 5.1 or higher.
- Access to administrative privileges might be required for certain operations.
- You need to have the "OS" pre-confiugred in a .vhdx

## Setup

1. Ensure all script files (`LaunchLab.ps1`, `labFunctions.ps1`) are in the same directory.
2. The script uses Windows Forms, so ensure that the assembly `System.Windows.Forms` is available on your system.
3. You need to have a master VHDX file to create new VMs. This file should be located in the same directory as the script files.
4. You need to have the folder `projects\lab-powershell` in the home directory of the user running the script. Otherwise, the script will not be able to be executed.

## Functions

### Core Functions

- `launchLab`: Main function to set up the lab environment.
- `New-VM-TTemps`: Function to create new virtual machines based on a master VHDX.
- `Remove-AllVMs`: Function to remove all virtual machines.
- `New-Credential`: Creates a new PSCredential object for authentication purposes.
- `Wait-VM`: Waits for a virtual machine to reach the 'OK' status in the heartbeat check.

### GUI Component Functions

- `dcNameGUI`, `dcOSGUI`, `dcIPGUI`, etc.: Functions to create GUI components for input fields.

## Components Description

Each GUI component (`TextBox`, `ComboBox`) is tied to a specific configuration aspect of the virtual lab. Inputs are validated to ensure all necessary fields are filled before proceeding.

## Screenshots

The following screenshots provide an overview of the GUI and the required folders for the script to run correctly.

### Folders structure required
![Mandatories Folders required](/screenshots/image.png)

### GUI
![Main Menu](/screenshots/image2.png)

### Hyper-V preview
![Hyper-V preview](/screenshots/image3.png)

## Troubleshooting

Ensure all paths and external scripts are correctly referenced. Check PowerShell execution policies if scripts do not run as expected.
If you encounter any issues, please don't hesitate to open an issue on this repository or contact me directly.

## Author

Tristan Morel - TTemps

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
