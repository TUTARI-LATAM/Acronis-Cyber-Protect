#This Script Work for Acronis Cyber Protect and MSI and MST file created after download a offline installer 
#By default created a folder in "C:\AcronisUnattended" 
#Download a .zip with all the data generated for MSI and MST Process of official installer 
#Decompress 
#Install if is not installed previous in the system 
#Created By TUTARI
#Credits: https://tutari.net 

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Este script necesita ser ejecutado como administrador"
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# Check if program is already installed
$programName = "Acronis Cyber Protect Agent"
$program = Get-Package -Name $programName -ErrorAction SilentlyContinue

if ($program) {
    Write-Host "$programName is installed in your system."
    Start-Sleep -Seconds 5
    return
}

# Define the folder path
$FolderPath = "C:\AcronisUnattended"

# Check if the folder exists and delete it if it does
if (Test-Path $FolderPath) {
    Write-Host "Delete OLD Repository"
    Remove-Item $FolderPath -Force
}

# Create the folder if it doesn't exist
if (!(Test-Path -Path $FolderPath)) {
    New-Item -ItemType Directory -Path $FolderPath
    Write-Host "Create new Repository" -ForegroundColor Green
} else {
    Write-Host "Folder already exists!" -ForegroundColor Yellow
}

# Download the file using Invoke-WebRequest
$Url = "https://example.com"
$OutFile = "C:\AcronisUnattended\BackupClientDLP.zip"
try {
    Invoke-WebRequest -Uri $Url -OutFile $OutFile
} catch {
    Write-Error "Error al descargar el archivo: $_"
    exit 1
}

# Extract the archive
$Destination = "C:\AcronisUnattended"
try {
    Expand-Archive -LiteralPath $OutFile -DestinationPath $Destination -Force
} catch {
    Write-Error "Error al extraer el archivo: $_"
    exit 1
}

# Install the MSI package
$MsiFile = "C:\AcronisUnattended\BackupClient64.msi"
$Transforms = "C:\AcronisUnattended\BackupClient64.msi.mst"
$LogFile = "C:\AcronisUnattended\Install.log"
try {
    Start-Process msiexec -Wait -ArgumentList "/i `"$MsiFile`" TRANSFORMS=`"$Transforms`" /quiet /L*V `"$LogFile`""
} catch {
    Write-Error "Error al instalar el paquete MSI: $_"
    exit 1
}
