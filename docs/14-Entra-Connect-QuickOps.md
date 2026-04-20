# 14. Entra Connect Operations and Troubleshooting

## Overview
This section documents operational tasks and troubleshooting techniques for Microsoft Entra Connect in a hybrid identity environment.

---

## PowerShell QuickOps Tool

To streamline common administrative tasks, I created a PowerShell menu-based tool:

[scripts/Entra-Connect-QuickOps.ps1](https://github.com/tjnieradka/AD-Entra-Lab/blob/main/scripts/Entra-Connect-QuickOps.ps1)

This tool simplifies:

- Checking sync status
- Restarting services
- Running delta and full syncs
- Launching Synchronization Service Manager (miisclient)

---

## Menu Interface

<img width="656" height="294" alt="image" src="https://github.com/user-attachments/assets/fd4133bb-fb00-48e3-8290-c5aaa0065c48" />

---

## Key Functions

| Option | Description |
|-------|------------|
| S | Show service and scheduler status |
| R | Restart AD Sync service |
| M | Restart miiserver engine |
| D | Run delta sync |
| F | Run full sync |
| L | Show last 10 sync runs |
| H | Restart Health Agent |
| O | Open miisclient |
| X | Exit |

---

## Example Use Cases

### User not syncing to Entra ID
- Run delta sync (D)
- Verify in miisclient (O)

### Sync appears stuck
- Restart AD Sync service (R)

### Investigate sync history
- Review last runs (L)

---

## Notes

- Requires administrative privileges
- Uses PowerShell cmdlets:
  - Start-ADSyncSyncCycle
  - Get-ADSyncScheduler
- Designed for lab and learning purposes
