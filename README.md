# AcronisCyberProtect
Script's for Acronis Cyber Protect Installation

########################################################

InstallerDLACRONIS.ps1 is a PowerShell script that helps with the installation of the Acronis Cyber Protect Cloud agent. 
This script validates administrator permissions and performs a clean installation if the software is not installed on the system. 
If the software is already installed, the script will skip the installation process. 

Remember Download latest version from cloud.acronis.com and create MSI and MST File from executable file downloaded and compress a zip archive 

After validation, the script will proceed to download a ZIP package from a specific URL. Then, the script will read the MST and MSI files of the original offline installer, generate a log file, and notify the user of the steps taken.

########################################################

Uninstall-Acronis.ps1 is a script that downloads the official Acronis tool for uninstalling their software and removes any Acronis software from the computer. The script is allowed to restart the computer, so this should be taken into account when running it.
