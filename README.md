# AD–Entra Hybrid Lab

A hands-on lab demonstrating **hybrid identity integration** between on-premises **Active Directory Domain Services (AD DS)** and **Microsoft Entra ID**, with network segmentation using VyOS and Windows and Linux test systems.

This is an educational demonstration environment, **not a production deployment guide**.

---

## 1. Overview

The lab documents how to:

- Deploy an Active Directory domain (`tntechdemo01.com`) and supporting DNS and DHCP services.
- Configure a VyOS router to separate LAN, DMZ, and WAN zones.
- Configure Microsoft Entra Connect for directory synchronization.
- Join and test Windows and Linux clients in the lab environment.
- Explore hybrid identity features, Microsoft 365 administration, and troubleshooting.
- Configure a Linux web server in the DMZ for connectivity testing.

---

## 2. Technologies and Tools

- **Identity:** Active Directory DS, Microsoft Entra ID, Microsoft Entra Connect
- **Servers:** Windows Server 2022 (domain controller and Entra Connect)
- **Clients:** Windows 11 and Ubuntu Desktop 20.04
- **Web server:** Ubuntu 20.04
- **Networking:** VyOS 1.3 (routing, firewall, NAT)
- **Virtualization:** VMware Workstation
- **Administration:** PowerShell and Windows/Linux diagnostic tools

---

## 3. Documentation and Scripts

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

- [Entra Connect Quick Operations (PowerShell)](scripts/Entra-Connect-QuickOps.ps1) — Management tasks described in the [Entra Connect Quick Operations guide](docs/14-Entra-Connect-QuickOps.md).

---

## 4. Lab Environment and Scope

The lab runs in a **local, virtualized environment** with simplified routing and firewall configurations. The [Environment Overview and Network Topology](docs/01-Environment-Overview.md) documents the design.

- Use only test accounts and non-sensitive data.
- Some services, including HTTP access to the DMZ web server, are intentionally exposed for testing.
- Production security hardening, certificate-based authentication, and other production controls are not fully implemented.

---

## 5. Project Status

The repository contains setup walkthroughs, administration notes, and troubleshooting documentation. Additional testing scenarios are identified as planned where applicable. Screenshots are embedded directly in the existing Markdown guides.

---

## 6. References and Learning Resources

The lab draws on hands-on experimentation, prior systems administration experience, vendor documentation, and training materials:

- **Microsoft Learn — Active Directory Domain Services:** Domain controllers, DNS integration, and administration.
- **Microsoft Learn — Microsoft Entra ID:** Identity administration, authentication, users, and groups.
- **Microsoft Learn — Microsoft Entra Connect:** Directory synchronization and hybrid identity.
- **Microsoft Learn — Microsoft 365 Administration:** Users, licensing, and administrative portals.
- **Microsoft Learn — Microsoft Intune:** Device enrollment, compliance, and endpoint management.
- **VyOS Documentation:** Routing, NAT, interfaces, and firewall configuration.
- **Udemy — SC-300 Microsoft Identity and Access Administrator Practice Labs:** Guided exercises informing the initial identity lab work.

Configuration, validation, and troubleshooting examples are documented from the virtualized lab environment.
