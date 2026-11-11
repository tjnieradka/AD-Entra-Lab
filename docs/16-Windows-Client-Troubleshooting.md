# Windows 11 Client Troubleshooting

## 1. Overview

## 2. Initial Troubleshooting Approach
- Identify symptoms and recent changes.
- Reproduce the issue where appropriate.
- Determine scope.
- Check logs and system health.
- Make one change at a time.
- Validate resolution.

## 3. Task Manager
- View Processes or Performance showing CPU, memory, disk and network.
- End and Start task or process.
- Start, stop, restart a service.
- View process details such as PID, status, CPU, memory.
- Access by pressing Ctrl-Alt-Del and select Task Manager or Right-click on Task bar and select Task Manager.  

<img width="1073" height="636" alt="image" src="https://github.com/user-attachments/assets/d1f0db29-302b-4bc1-b8da-f5079e58efe4" />


## 4. Event Viewer
- View System, Application, Security, and Setup logs.
- View Common event levels, including Information, Warning, Error, and Critical.
- Filter events.
- Correlate timestamps with reported problems.
- Access by right-clicking on the Start button and selecting Event Viewer. 

<img width="1041" height="742" alt="image" src="https://github.com/user-attachments/assets/cd0548e5-e193-4a94-83a8-9fbc52297480" />


## 5. Reliability Monitor
- View Application failures, Windows failures, Hardware errors on a Timeline/history.
- Access by running `permon /rel` in the Run box or in the Terminal.

<img width="1126" height="693" alt="image" src="https://github.com/user-attachments/assets/6f0ace0e-515e-4e07-a073-c37fde174a89" />

- View Problem Details
<img width="1124" height="684" alt="image" src="https://github.com/user-attachments/assets/bf303b73-b48b-460d-a040-34420b02895e" />


## 6. Performance Monitor
- View Performance counters for CPU, memory, disk and network.
- Configure Data Collector Sets to view performance.
- Access by running `perfmon` in the Run box or in the Terminal. 

<img width="987" height="705" alt="image" src="https://github.com/user-attachments/assets/39a4823b-17c1-4f99-9ced-b8614b4dab24" />

<img width="984" height="704" alt="image" src="https://github.com/user-attachments/assets/87585bc7-ca36-49f4-9f95-bb0e5d74125c" />


## 7. Resource Monitor
- Monitor CPU, Memory, Disk, and Network.
- Access by running `resmon` in the Run box or in the Termninal. 

<img width="780" height="691" alt="image" src="https://github.com/user-attachments/assets/dc00af99-5154-4555-b9ce-9efd15697280" />


## 8. Device Troubleshooting
- View status of devices and drivers.
- Rescan for new devices and update drivers if necessary.
- Disable and enable devices.
- Access Device Manager by right-clicking on the Start button and selecting Device Manager.
  
<img width="780" height="603" alt="image" src="https://github.com/user-attachments/assets/478bb2ae-6fe1-4027-9382-c892b45880af" />

## 9. Service Troubleshooting
- View service state/startup type.
- Start, stop, pause, resume, restart services.  Change Startup type.
- Access by running `services.msc` in the Run box or in the Terminal.

<img width="805" height="587" alt="image" src="https://github.com/user-attachments/assets/e8d59320-08f2-49c4-a97d-714b46469034" />



## 10. Windows Crash / BSOD Troubleshooting
- Stop codes
- Event Viewer
- C:\Windows\Minidump
- C:\Windows\MEMORY.DMP
- WinDbg overview
- !analyze -v

## 10. Windows System Health Tools
- Run `sfc /scannow`
- The untility Scans the integrity of all protected system files and replaces incorrect versions with correct Microsoft versions.

<img width="840" height="275" alt="image" src="https://github.com/user-attachments/assets/153629fd-eae8-4c7c-8458-45a4fce221d3" />
  
- Run `DISM`
- DISM enumerates, installs, uninstalls, configures, and updates features and packages in Windows images. The commands that are available depend
  on the image being serviced and whether the image is offline or running.
- Various options available.  Example below used `DISM /Online /Cleanup-Image /CheckHealth`

<img width="842" height="257" alt="image" src="https://github.com/user-attachments/assets/ee9f8d8f-3edb-469a-9e81-778c8d29fc1a" />

- Run `chkdsk`
- Checks a disk and displays a status report. Various options available.

<img width="839" height="234" alt="image" src="https://github.com/user-attachments/assets/730f1b54-25b5-49aa-b84c-02288c2aca2d" />
  
- Windows Memory Diagnostic
- Access by running `mdsched`
- Memory will be scanned after reboot.

<img width="841" height="470" alt="image" src="https://github.com/user-attachments/assets/3830daa0-adb4-44f2-abf5-c6542663937e" />



## 11. PowerShell Troubleshooting
- Use the following PowerShell cmdlets with appropriate options:
- `Get-Process`
- `Get-Service`
- `Get-WinEvent`
- `Get-ComputerInfo`

## 12. Network Troubleshooting
Brief reference/link to your separate Network Troubleshooting Foundations repo.



## 13. Summary
