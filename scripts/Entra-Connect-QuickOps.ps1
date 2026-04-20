<#
.SYNOPSIS
Quick operations menu for Microsoft Entra Connect (lab-safe).

.DESCRIPTION
Runs on the Entra Connect server (Windows PowerShell 5.x).
Provides menu-driven shortcuts to view sync status, restart services,
trigger delta/full syncs, and open the Synchronization Service Manager.

.EXAMPLE
.\Entra-Connect-QuickOps.ps1
Launches the menu interface.

.PARAMETER None
Parameters are not required.

.NOTES
Author: Thomas Nieradka
Requires: Windows PowerShell 5.1, ADSync module
RunAs: Administrator
Version: 1.0 (October 2025)
#>

#requires -RunAsAdministrator
#requires -Version 5.1

#--- Initial Validation ---------------------------------------------------

# Verify that the script does not run on a desktop PowerShell
if ($PSVersionTable.PSEdition -ne 'Desktop') {
  Write-Warning "Use Windows PowerShell (Desktop) 5.x on the Entra Connect server. Current: $($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion)"
}

# Verify that the ADSync module is present on the system where the script runs.  
$adSyncModule = "C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1"
if (Test-Path $adSyncModule) {
  Import-Module $adSyncModule -Force -ErrorAction Stop
} else {
  Write-Warning "ADSync module not found at: $adSyncModule"
}

# Verify that the script is running on Entra Connect server with ADSync service.
if (-not (Get-Service -Name ADSync -ErrorAction SilentlyContinue)) {
  Write-Error "ADSync service not found on this machine. Are you on the Entra Connect server?"
  return
}

#--- Helper Functions --------------------------------------------------------------
function Pause-Any { Read-Host "Press ENTER to continue..." | Out-Null }

# Show status of the ADSync service
function Show-Status {
  Get-Service ADSync
  Write-Host ""
  Write-Host "Scheduler:"
  Get-ADSyncScheduler | Format-List
}

# Restart AD Sync service. 
# Show service status or show the error
function Restart-ADSyncService {
  try {
    Restart-Service ADSync -Force -ErrorAction Stop -PassThru | Out-Host
  } catch {
    Write-Error "Restart-Service ADSync failed: $($_.Exception.Message)"
  }
}


# Stop the miiserver process and restart it.  Restart the ADSync service. 
# Show service status or show the error.
function Restart-EngineThenService {
  try {
    $p = Get-Process miiserver -ErrorAction SilentlyContinue
    if ($p) {
      Write-Host "Stopping miiserver.exe (PID $($p.Id))..." 
      Stop-Process -Id $p.Id -Force -ErrorAction Stop
      Start-Sleep -Seconds 2
    } else {
      Write-Host "miiserver.exe not found; proceeding to start ADSync." 
    }
    Start-Service ADSync -ErrorAction Stop
    Write-Host "ADSync service started." -ForegroundColor Green
  } catch {
    Write-Error "Engine/service restart failed: $($_.Exception.Message)"
  }
}
# Perform sync of changes between on premises AD and Entra ID.
# Show status of the sync or an error. 
function Start-DeltaSync {
  try {
    Start-ADSyncSyncCycle -PolicyType Delta | Out-Host
  } catch {
    Write-Error "Delta sync failed: $($_.Exception.Message)"
  }
}

# Perform full sync of between on premises AD and Entra ID.
# Show status of the sync or an error. 
function Start-FullSync {
  Write-Host "Full sync (Initial) can take a while..." 
  try {
    Start-ADSyncSyncCycle -PolicyType Initial | Out-Host
  } catch {
    Write-Error "Full sync failed: $($_.Exception.Message)"
  }
}

# Show status of the Health Agent service
function Show-HealthAgent {
  # New name uses "Microsoft Entra"
  Get-Service | Where-Object { $_.DisplayName -like "Microsoft Entra * Health *" } |
    Sort-Object DisplayName | Format-Table -AutoSize
}

# Show last 10 runs of synchronization or show a warning
function Show-LastRuns {
  try {
    Get-ADSyncConnectorRunStatus |
      Sort-Object EndTime -Descending |
      Select-Object -First 10 ConnectorName, RunStepName, Status, StartTime, EndTime | Format-Table -AutoSize
  } catch {
    Write-Warning "No run history returned. Ensure module loaded and you are on the Connect server."
  }
}

# Open Synchronization Service Manager (miisclient) if additional investigation is needed into sync details.
function Open-MiisClient {
  $path = "C:\Program Files\Microsoft Azure AD Sync\UIShell\miisclient.exe"
  if (Test-Path $path) { Start-Process $path } else { Write-Warning "miisclient.exe not found." }
}

#--- Main Menu -----------------------------------------------------------------

# Menu here-string to preserve formatting
$menu = @"
******************************************************
Type a letter and press ENTER

s = Show Status (service and scheduler)
r = Restart AD Sync service
m = Restart miiserver engine then start AD Sync
d = Perform Delta sync (changes since last successful run)
f = Perform Full sync (initial)
l = Show last 10 sync runs
h = Show Entra Connect Health agent service
o = Open Synchronization Service Manager (miisclient)
x = Exit

******************************************************

"@

# Console color for Desktop PS
if ($PSVersionTable.PSEdition -eq 'Desktop') { cmd /c color 71 }


# Call helper functions based on input of letter sections (if applicable, upper case is converted to lowercase) 

$quit = $false
do {
  $selection = (Read-Host -Prompt $menu).Trim().ToLowerInvariant()
  Clear-Host
  switch ($selection) {
    's' { Show-Status; Pause-Any }
    'r' { Restart-ADSyncService; Pause-Any }
    'm' { Restart-EngineThenService; Pause-Any }
    'd' { Start-DeltaSync; Pause-Any }
    'f' { Start-FullSync; Pause-Any }
    'l' { Show-LastRuns; Pause-Any }
    'h' { Show-HealthAgent; Pause-Any }
    'o' { Open-MiisClient }
    'x' { $quit = $true }
    default { Write-Host "  Not a valid selection. Try again." -ForegroundColor Red }
  }
} while (-not $quit)

# Reset console colors
cmd /c color 07
Clear-Host
