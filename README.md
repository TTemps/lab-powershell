# PowerShell VM Configuration and Domain Join

Welcome to the PowerShell VM Configuration and Domain Join project! This PowerShell script automates the setup of a virtual machine and joins it to a specified domain, simplifying the process of VM deployment in a lab environment.

## Features

- Automatically configures DHCP settings.
- Joins the virtual machine to the "lab.local" domain.
- Includes robust error handling for common issues like network or credential errors.

## Getting Started

### Prerequisites

Ensure you have the following before starting:
- PowerShell 5.1 or higher.
- Administrative access on the virtual machine.
- Network connectivity to the domain controller.

### Installation

No installation is required. Simply download the `LaunchLab.ps1` script from this repository.

### Usage

To run the script, open PowerShell as an administrator and navigate to the directory containing `LaunchLab.ps1`. Execute the script using:

```powershell
.\LaunchLab.ps1
