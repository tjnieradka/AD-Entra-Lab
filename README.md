## AD–Entra Hybrid Lab (Demo)

A hands-on lab designed to demonstrate **hybrid identity integration** between **on-premises Active Directory (AD DS)** and **Microsoft Entra ID**, including Entra Connect, basic routing with VyOS, and various identity features.

This lab is for **demo and educational purposes** only -- **not meant for production**.

---

## Overview

This repository contains step-by-step instructions to:

- Deploy an **Active Directory domain** (`tntechdemo01.com`).
- Configure a **VyOS router** to isolate zones (LAN, DMZ, WAN).
- Set up **Microsoft Entra Connect** for directory synchronization.
- Test Entra-integrated authentication from Windows and Linux clients.
- Simulate real-world hybrid join, conditional access, and web services.

---

## Documentation and Scripts

### Documentation

1. [Active Directory Fundamentals](docs/00-Active-Directory-Fundamentals.md)
2. [Environment Overview and Network Topology](docs/01-Environment-Overview.md)
3. [VyOS Router Setup](docs/02-VyOS-Router_Setup.md)
4. [Active Directory and DNS Setup](docs/03-Active-Directory-and-DNS-Setup.md)
5. [DHCP Server Setup](docs/04-DHCP-Server-Setup.md)
6. [Test Users Setup in Active Directory](docs/05-Test-Users-Setup-in-Active-Directory.md)
7. [Microsoft Entra ID Setup](docs/06-Entra-ID-Setup.md)
8. [Entra Connect Setup and Synchronization](docs/07-Entra-Connect-Setup-and-Sync.md)
9. [Joining a Windows Client](docs/08-Joining-Windows-Client.md)
10. [Joining a Linux Client](docs/09-Joining-Linux-Client.md)
11. [Linux Web Server in DMZ Setup](docs/10-Test-Linux-Web-Server-in-DMZ-Setup.md)
12. [Testing Scenarios — To Be Added](docs/11-Testing%20Scenarios-TBA.md)
13. [Network Troubleshooting](docs/12-Network-Troubleshooting.md)
14. [Active Directory Troubleshooting](docs/13-Active-Directory-Troubleshooting.md)
15. [Entra Connect Quick Operations](docs/14-Entra-Connect-QuickOps.md)
16. [Microsoft 365 Administration](docs/15-Microsoft-365-Administration.md)
17. [Windows Client Troubleshooting](docs/16-Windows-Client-Troubleshooting.md)

### PowerShell Scripts

- [Entra Connect Quick Operations (PowerShell)](scripts/Entra-Connect-QuickOps.ps1) — Script for Entra Connect management tasks. See 15. [Entra Connect Quick Operations](docs/14-Entra-Connect-QuickOps.md)

---

## Technologies Used

- Microsoft Entra ID (formerly Azure AD)
- Windows Server 2022 (Domain Controller, Entra Connect)
- Windows 11 (test client)
- Ubuntu Desktop 20.04 (Linux test client)
- Ubuntu 20.04 (Linux test Web server)
- VyOS 1.3 (router with zone-based firewall & NAT)
- Virtualization via VMware Workstation

---

##  Important Notes

- This lab is built in a **local, virtualized environment**. Do **not** use real credentials or sensitive info.
- **Firewall rules and routing settings** are simplified for demonstration.
- Certain services (e.g., HTTP access to DMZ server) are intentionally left open to simulate access scenarios.
- **Security hardening, certificate-based auth, and production controls are not applied.**

---

##  Learning Sources

This lab was developed using hands-on experimentation, prior systems administration experience, training materials, and vendor documentation. Key references include:

- **Microsoft Learn — Active Directory Domain Services:** Concepts and administration of Active Directory Domain Services, DNS integration, domain controllers, and related services.  
- **Microsoft Learn — Microsoft Entra ID:** Identity administration, authentication, users, groups, and hybrid identity concepts.  
- **Microsoft Learn — Microsoft Entra Connect:** Installation, configuration, and synchronization of on-premises Active Directory identities with Microsoft Entra ID.  
- **Microsoft Learn — Microsoft 365 Administration:** Microsoft 365 users, licensing, administrative portals, and service administration.  
- **Microsoft Learn — Microsoft Intune:** Device enrollment, compliance, configuration, and endpoint-management concepts.  
- **VyOS Documentation:** Routing, NAT, interfaces, and firewall configuration.  
- **Udemy Training — SC-300 Microsoft Identity and Access Administrator Practice Labs:** Guided exercises used as part of the initial identity lab work.  
- **Hands-on lab testing and troubleshooting:** Configuration, validation, and troubleshooting performed within the virtualized lab environment.  

---

##  License

This repository is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. See LICENSE.md for details.

---


---


