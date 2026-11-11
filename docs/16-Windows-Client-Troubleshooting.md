# Windows 11 Client Troubleshooting

## 1. Overview

This section provides an overview of common Windows 11 tools and techniques used to investigate system, application, performance, hardware, service, and startup problems. It includes built-in graphical tools, command-line utilities, PowerShell, crash analysis, recovery options, and online troubleshooting resources.

The examples provide a practical reference for identifying problems, gathering diagnostic information, and validating corrective actions.

## 2. Initial Troubleshooting Approach

- Identify symptoms and recent changes.
- Reproduce the issue where appropriate.
- Determine scope.
- Check logs and system health.
- Make one change at a time.
- Validate resolution.

## 3. Windows Settings

- Review and configure Windows system settings.
- Check **Windows Update** status and update history.
- Review **System → About** for Windows version, hardware, and device information.
- Review **Network & internet** configuration.
- Review installed applications under **Apps.**
- Access troubleshooting and recovery options under **System.**
- Access by pressing Windows + I or right-clicking Start and selecting **Settings.**

<img width="1021" height="724" alt="image" src="https://github.com/user-attachments/assets/a7115973-feb8-452e-a59d-a3c8430f9245" />


## 4. Task Manager

- View Processes or Performance showing CPU, memory, disk and network.
- End and Start task or process.
- Start, stop, restart a service.
- View process details such as PID, status, CPU, memory.
- Access by pressing Ctrl-Alt-Del and select Task Manager or Right-click on Task bar and select Task Manager.  

<img width="1073" height="636" alt="image" src="https://github.com/user-attachments/assets/d1f0db29-302b-4bc1-b8da-f5079e58efe4" />


## 5. Event Viewer

- View System, Application, Security, and Setup logs.
- View Common event levels, including Information, Warning, Error, and Critical.
- Filter events.
- Correlate timestamps with reported problems.
- Access by right-clicking on the Start button and selecting Event Viewer. 

<img width="1041" height="742" alt="image" src="https://github.com/user-attachments/assets/cd0548e5-e193-4a94-83a8-9fbc52297480" />


## 6. Reliability Monitor

- View Application failures, Windows failures, Hardware errors on a Timeline/history.
- Access by running `perfmon /rel` in the Run box or in the Terminal.

<img width="1126" height="693" alt="image" src="https://github.com/user-attachments/assets/6f0ace0e-515e-4e07-a073-c37fde174a89" />

- View Problem Details
  
<img width="1124" height="684" alt="image" src="https://github.com/user-attachments/assets/bf303b73-b48b-460d-a040-34420b02895e" />


## 7. Performance Monitor

- View Performance counters for CPU, memory, disk and network.
- Configure Data Collector Sets to view performance.
- Access by running `perfmon` in the Run box or in the Terminal. 

<img width="987" height="705" alt="image" src="https://github.com/user-attachments/assets/39a4823b-17c1-4f99-9ced-b8614b4dab24" />

- Add Counters from Data Collector Sets
  
<img width="984" height="704" alt="image" src="https://github.com/user-attachments/assets/87585bc7-ca36-49f4-9f95-bb0e5d74125c" />


## 8. Resource Monitor

- Monitor CPU, Memory, Disk, and Network.
- Access by running `resmon` in the Run box or in the Termninal. 

<img width="780" height="691" alt="image" src="https://github.com/user-attachments/assets/dc00af99-5154-4555-b9ce-9efd15697280" />


## 9. Device Troubleshooting

- View status of devices and drivers.
- Rescan for new devices and update drivers if necessary.
- Disable and enable devices.
- Access Device Manager by right-clicking on the Start button and selecting Device Manager.
  
<img width="780" height="603" alt="image" src="https://github.com/user-attachments/assets/478bb2ae-6fe1-4027-9382-c892b45880af" />

## 10. Service Troubleshooting

- View service state/startup type.
- Start, stop, pause, resume, restart services.  Change Startup type.
- Access by running `services.msc` in the Run box or in the Terminal.

<img width="805" height="587" alt="image" src="https://github.com/user-attachments/assets/e8d59320-08f2-49c4-a97d-714b46469034" />

## 11. Windows Crash / BSOD Troubleshooting

- Record the **stop code** displayed when the system crashes and use it to identify the general type of failure.
- Check **Event Viewer → Windows Logs → System** for errors and critical events around the time of the crash.
- Check **Reliability Monitor** for Windows failures and other events corresponding to the crash.
- Check for crash dump files:
  `C:\Windows\Minidump` — small memory dump files, if configured.
  `C:\Windows\MEMORY.DMP` — larger memory dump file, depending on the configured dump type.
- Review dump configuration under **System Properties → Advanced → Startup and Recovery → Settings.**
- Install **Microsoft WinDbg** when detailed crash-dump analysis is required.
- Open the .dmp file in **WinDbg** and run `!analyze -v` to perform verbose analysis.
- Use the stop code, event logs, dump analysis, and recent system changes to investigate possible driver, hardware, firmware, or Windows problems.
- Apply the appropriate corrective action and monitor the system for recurrence.

<img width="876" height="691" alt="image" src="https://github.com/user-attachments/assets/91413ba8-00d7-416b-b388-73add1aefeb7" />

## 12. Windows Recovery Environment

If Windows cannot start normally, the system can be booted from Windows installation media, such as a bootable USB drive or ISO image, to access recovery tools.

- Boot from Windows installation media and select **Repair my PC** rather than **Install Windows 11**.
- Select **Troubleshoot → Advanced options** to access recovery tools.
- Available recovery options can include:
  - **Startup Repair** — attempts to repair problems preventing Windows from starting.
  - **Command Prompt** — provides command-line access for advanced troubleshooting and repair.
  - **Uninstall Updates** — removes recently installed Windows quality or feature updates.
  - **UEFI Firmware Settings** — provides access to system firmware configuration.
  - **System Restore** — restores Windows using an available restore point.
  - **System Image Recovery** — restores a previously created system image.

Windows Recovery Environment provides troubleshooting options when problems prevent normal access to the Windows desktop.

<img width="716" height="559" alt="image" src="https://github.com/user-attachments/assets/49e5d721-8b6f-4590-b420-a67307f1686b" />

<img width="911" height="497" alt="image" src="https://github.com/user-attachments/assets/29f36261-c9f9-4379-90c1-0d11ea049589" />

<img width="911" height="497" alt="image" src="https://github.com/user-attachments/assets/cbe0b6a0-9b09-4f8e-8806-290a324a87ca" />




## 13. Windows System Health Tools
- Run `sfc /scannow`
- Scans protected Windows system files and attempts to replace corrupted files with correct versions.

<img width="840" height="275" alt="image" src="https://github.com/user-attachments/assets/153629fd-eae8-4c7c-8458-45a4fce221d3" />
  
- Run `DISM`
- `DISM /Online /Cleanup-Image /CheckHealth` checks whether corruption has been detected in the Windows component store.
- Additional options such as `/ScanHealth` and `/RestoreHealth` can be used for more detailed scanning and repair.

<img width="842" height="257" alt="image" src="https://github.com/user-attachments/assets/ee9f8d8f-3edb-469a-9e81-778c8d29fc1a" />

- Run `chkdsk`
- Checks the file system and file-system metadata of a volume for logical and physical errors. Additional options can be used to perform repairs.

<img width="839" height="234" alt="image" src="https://github.com/user-attachments/assets/730f1b54-25b5-49aa-b84c-02288c2aca2d" />
  
- Windows Memory Diagnostic
- Access by running `mdsched`
- Memory will be scanned after reboot.

<img width="841" height="470" alt="image" src="https://github.com/user-attachments/assets/3830daa0-adb4-44f2-abf5-c6542663937e" />



## 14. PowerShell Troubleshooting
- Use the following PowerShell cmdlets with appropriate options:
- `Get-Process`
- `Get-Service`
- `Get-WinEvent`
- `Get-ComputerInfo`

## 15. Registry Editor
- The Windows Registry stores configuration information used by Windows, applications, services, and hardware.
- Use `regedit` to view and modify registry keys and values when required for troubleshooting or configuration.
- Registry changes should be made carefully and preferably based on trusted documentation.
- Back up relevant registry data before making significant changes.
- Access by running `regedit`.

<img width="774" height="615" alt="image" src="https://github.com/user-attachments/assets/6a6317d3-a378-48f9-a342-911cb06e7b5f" /> 

## 16. Network Troubleshooting

See https://github.com/tjnieradka/Network-Troubleshooting-Foundations

## 17. Online Troubleshooting Resources
- Additional information can be obtained from trusted technical documentation and support resources:

  - **Microsoft Learn — Windows Troubleshooting:** Technical troubleshooting documentation for Windows clients and Windows Server.
  - **Microsoft Support:** Windows support articles, configuration guidance, and troubleshooting procedures.
  - **Microsoft Sysinternals:** Advanced Windows troubleshooting utilities including Process Explorer, Process Monitor, Autoruns, ProcDump, and TCPView.
  - **Microsoft bug check documentation:** Reference information for Windows stop codes and crash troubleshooting.
  - **Hardware and software vendor documentation:** Driver, firmware, application, and product-specific troubleshooting information.
  
When researching an error, useful search terms can include the exact error message, Event ID, stop code, application or driver name, and Windows version.

## 18. Summary

Windows troubleshooting involves identifying symptoms, gathering relevant diagnostic information, isolating possible causes, applying appropriate corrective actions, and validating the results.

Windows 11 provides a range of built-in tools for examining system events, performance, processes, services, devices, system health, and recovery. PowerShell and additional tools such as WinDbg and Microsoft Sysinternals can provide further diagnostic capabilities when more detailed investigation is required.

