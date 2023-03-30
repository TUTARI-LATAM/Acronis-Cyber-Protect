# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as an administrator. Please re-run this script with elevated privileges."
    Start-Sleep -Seconds 5
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File $($MyInvocation.MyCommand.Path)"
    Exit
}

#Variables
$FolderPath = "C:\AcronisUnattended"
$CleanupToolUrl = "https://dl5.acronis.com/u/kb/cleanup_tool.exe"
$CleanupToolPath = Join-Path $FolderPath "cleanup_tool.exe"

#Comprobar si la carpeta existe
if (!(Test-Path -Path $FolderPath)) {
    New-Item -ItemType Directory -Path $FolderPath
    Write-Host "New folder created successfully!" -ForegroundColor Green
} else {
    Write-Host "Folder already exists!" -ForegroundColor Yellow
}

#Descargar cleanup utility Acronis
if (!(Test-Path -Path $CleanupToolPath)) {
    Write-Host "Downloading cleanup tool from $CleanupToolUrl" -ForegroundColor Cyan
    try {
        $response = Invoke-WebRequest -Uri $CleanupToolUrl -OutFile $CleanupToolPath -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "Download completed successfully!" -ForegroundColor Green
        } else {
            Write-Host "Download failed with status code $($response.StatusCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Download failed with error: $_" -ForegroundColor Red
    }
} else {
    Write-Host "Cleanup tool already exists in $CleanupToolPath" -ForegroundColor Yellow
}

#Ejecutar herramienta
if (Test-Path -Path $CleanupToolPath) {
    try {
        $process = Start-Process -FilePath $CleanupToolPath -ArgumentList "-q", "--allow-reboot" -NoNewWindow -Wait -PassThru -ErrorAction Stop
        if ($process.ExitCode -eq 0) {
            Write-Host "Cleanup completed successfully!" -ForegroundColor Green
        } else {
            Write-Host "Cleanup failed with exit code $($process.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Cleanup failed with error: $_" -ForegroundColor Red
    }
} else {
    Write-Host "Cleanup tool not found at $CleanupToolPath. Cannot execute cleanup." -ForegroundColor Red
}
