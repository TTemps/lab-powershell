# Virtual Lab Setup Tool

This PowerShell script provides a graphical user interface (GUI) to configure and launch virtual lab environments, including virtual machines (VMs), domain controllers (DCs), and DHCP scopes.

## Features

- **DC Configuration**: Setup domain controller with customizable options like name, OS, IP, and credentials.
- **DHCP Scope Configuration**: Define start and end IP ranges, subnet masks, and descriptions for scopes.
- **VM Configuration**: Setup VMs with options for operating system, number, and names.
- **Verbose Logging**: Optional verbose logging to provide detailed output during operations.

## Prerequisites

- Windows PowerShell 5.1 or higher.
- Access to administrative privileges might be required for certain operations.

## Setup

1. Ensure all script files (`LaunchLab.ps1`, `labFunctions.ps1`) are in the same directory.
2. The script uses Windows Forms, so ensure that the assembly `System.Windows.Forms` is available on your system.

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

(Insert screenshots of the GUI here to provide visual context for users.)

## Troubleshooting

Ensure all paths and external scripts are correctly referenced. Check PowerShell execution policies if scripts do not run as expected.

## Author

Tristan Morel

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
