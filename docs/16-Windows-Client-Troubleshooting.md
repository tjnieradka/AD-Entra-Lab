# Windows 11 Client Troubleshooting

## 1. Overview

## 2. Initial Troubleshooting Approach
- Identify symptoms and recent changes
- Reproduce the issue where appropriate
- Determine scope
- Check logs and system health
- Make one change at a time
- Validate resolution

## 3. Task Manager
- View Processes or Performance showing CPU, memory, disk and network.
- End and Start task or process
- Start, stop, restart a service
- View process details such as PID, status, CPU, memory
- Access by Ctrl-Alt-Del and select Task Manager or Right-click on Task bar and select Task Manager

<img width="1073" height="636" alt="image" src="https://github.com/user-attachments/assets/d1f0db29-302b-4bc1-b8da-f5079e58efe4" />


## 4. Event Viewer
- View System, Application, Security, and Setup logs
- View Common event levels, including Information, Warning, Error, and Critical.
- Filter events
- Correlate timestamps with reported problems
- Access by right-clicking on the Start button and selecting Event Viewer 

<img width="1041" height="742" alt="image" src="https://github.com/user-attachments/assets/cd0548e5-e193-4a94-83a8-9fbc52297480" />


## 5. Reliability Monitor
- perfmon /rel
- Application failures
- Windows failures
- Hardware errors
- Timeline/history

## 6. Performance Monitor
- perfmon
- Performance counters
- CPU, memory, disk and network
- Data Collector Sets — brief mention only

## 7. Resource Monitor
- resmon
- CPU
- Memory
- Disk
- Network

## 8. Device and Service Troubleshooting
- Device Manager
- services.msc
- Driver status
- Service state/startup type

## 9. Windows Crash / BSOD Troubleshooting
- Stop codes
- Event Viewer
- C:\Windows\Minidump
- C:\Windows\MEMORY.DMP
- WinDbg overview
- !analyze -v

## 10. Windows System Health Tools
- sfc /scannow
- DISM
- chkdsk
- Windows Memory Diagnostic

## 11. PowerShell Troubleshooting
- Get-Process
- Get-Service
- Get-WinEvent
- Get-ComputerInfo

## 12. Network Troubleshooting
Brief reference/link to your separate Network Troubleshooting Foundations repo.

## 13. Summary
