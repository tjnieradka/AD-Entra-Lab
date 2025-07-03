## AD–Entra Hybrid Lab (Demo)

A hands-on lab designed to demonstrate **hybrid identity integration** between **on-premises Active Directory (AD DS)** and **Microsoft Entra ID**, including Entra Connect, basic routing with VyOS, and various identity features.

This lab is for **demo and educational purposes** only -- **not meant for production**.

---

## Overview

This repository contains step-by-step instructions to:

- Deploy an **Active Directory domain** (`tntechdemo01.com`)
- Configure a **VyOS router** to isolate zones (LAN, DMZ, WAN)
- Set up **Microsoft Entra Connect** for directory synchronization
- Test Entra-integrated authentication from Windows and Linux clients
- Simulate real-world hybrid join, conditional access, and web services

---

## Repository Structure  

AD-Entra-Lab/  
├─ docs/ # Lab walkthroughs  
│ ├─ 01-Environment-Overview.md # Network topology  
│ ├─ 02-VyOS-Router_Setup.md # Work in progress  
│ ├─ 03-Active-Directory-and-DNS-Setup.md  
│ ├─ 04-DHCP-Server-Setup.md  
│ ├─ 05-Test-Users-Setup-in-Active-Directory.md  # Work in progress  
│ ├─ 06-Entra-ID-Setup.md  
│ ├─ 07-Entra-Connect-Setup-and-Sync.md  
│ ├─ 08-Joining-Windows-Client.md  
│ ├─ 09-Joining-Linux-Client.md  
│ ├─ 10-Test-Linux-Web-Server-in-DMZ-Setup.md  
│ ├─ 11-Testing Scenarios-TBA.md # Work in progress  
│ └─ ... more steps coming  

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

This lab setup was inspired by:

-  **Udemy Training**: _SC-300 Microsoft Identity and Access Administrator Practice Labs_
-  **Microsoft Learn**: [Hybrid Identity Documentation](https://learn.microsoft.com/en-us/entra/identity/hybrid/)
-  Personal Experience in systems administration, data centers, and identity integration

---

## 📘 License

This repository is released under **Creative Commons CC BY-NC-ND 4.0**.

-  You may share this for non-commercial educational purposes
-  You may not modify or use it commercially without permission

---

## 📫 Contact

Created and maintained by **Thomas Nieradka**

- GitHub: [@tjnieradka](https://github.com/tjnieradka)
- LinkedIn: [linkedin.com/in/thomas-nieradka](https://www.linkedin.com/in/thomas-nieradka))

---


