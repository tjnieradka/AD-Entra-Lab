# 🔧 Lab Environment Overview

This virtual lab simulates a hybrid on-premises network integrated with **Microsoft Entra ID** (formerly Azure Active Directory). It provides a hands-on environment to explore Active Directory domain services, Entra Connect synchronization, firewall policies, and DMZ architecture using **VyOS 1.3** as a virtual router/firewall.

## 🏗️ Architecture Highlights

- **VyOS Router (1.3 Equuleus)** provides routing, zone-based firewalling, and NAT.
  - **WAN (VMnet8)**: NAT interface for outbound internet/Entra connectivity
  - **LAN (VMnet2)**: Internal subnet for domain services and clients
  - **DMZ (VMnet3)**: Segregated network for web-accessible services
- **Active Directory Domain Controller (Windows Server 2022)** with DNS/DHCP roles
- **Entra Connect Server (Windows Server 2022)** to sync on-prem AD to Microsoft Entra ID
- **Windows 11 and Ubuntu clients** connected to the LAN subnet via DHCP
- **Ubuntu Web Server** hosted in the DMZ to simulate a public-facing server
- **Microsoft Entra ID (Cloud)** accessed over HTTPS for directory sync and auth

## 🌐 Subnet Configuration

| Zone      | Interface   | Subnet             | Notes                              |
|-----------|-------------|--------------------|-------------------------------------|
| LAN       | VMnet2      | 192.168.10.0/24    | Static: `.10–.50`, DHCP: `.100–.200`|
| DMZ       | VMnet3      | 192.168.20.0/24    | Static IPs assigned manually       |
| WAN (NAT) | VMnet8      | 192.168.35.0/24    | VMware NAT to Internet             |

## 💻 Virtual Machines Summary

| VM Name           | vCPU | RAM  | Disk | NIC(s)           | OS/Role                                     |
|-------------------|------|------|------|------------------|---------------------------------------------|
| `AD-DC`           | 2    | 6 GB | 130 GB | VMnet2           | Windows Server 2022 – AD, DNS, DHCP         |
| `EntraConnect`    | 2    | 4 GB | 130 GB | VMnet2           | Windows Server 2022 – Entra Connect         |
| `Win11-Client`    | 2    | 4 GB | 80 GB | VMnet2           | Windows 11 – DHCP, AD-joined                |
| `UbuntuClient`    | 2    | 2 GB | 30 GB | VMnet2           | Ubuntu 20 Desktop – DHCP                    |
| `VyOS`            | 1    | 1 GB | 10 GB | VMnet2/3/8       | VyOS 1.3 – Router + ZBF                     |
| `UbuntuWebDMZ`    | 2    | 2 GB | 30 GB | VMnet3           | Ubuntu 20 Server – Static IP in DMZ         |

## ☁️ Microsoft Entra ID

- Cloud Directory: `EntraTenantName.onmicrosoft.com`
- Accessible from VyOS WAN interface via NAT
- Required for synchronization and token-based authentication

## 🔐 Firewall and Security

- VyOS uses **zone-based firewall (ZBF)** rules to restrict traffic between zones
- Inbound/Outbound rules are defined per zone-pair
- Only required ports for Entra Connect and AD traffic are allowed

## 🖥️ VMWare Setup

- This is how the above environment appears on VMWare Workstation

![image](https://github.com/user-attachments/assets/f735ccd2-b936-4f7a-8be6-0008baa569c2)


------------------------------------------------------------------------------------------
| VM Name           | vCPU | RAM (GB) | NICs        | Disk Space | Operating System             |
|-------------------|------|----------|-------------|------------|------------------------------|
| VYOS-ROUTER       | 1    | 1        | 3 (WAN, LAN, DMZ) | 10 GB       | VyOS 1.3 (Equuleus)           |
| VANDC1-W2022           | 2    | 6        | 1 (LAN)     | 130 GB      | Windows Server 2022 (AD, DNS, DHCP) |
| VANEC1-W2022   | 2    | 4        | 1 (LAN)     | 130 GB      | Windows Server 2022 (Entra Connect) |
| VANCL11-W11      | 2    | 4        | 1 (LAN)     | 80 GB      | Windows 11 Pro (DHCP client)               |
| VANCL2-UBUNTU    | 2    | 2        | 1 (LAN)     | 30 GB      | Ubuntu 22.04 LTS Desktop  (DHCP client)    |
| VANSRV-UBUNTU    | 2    | 2        | 1 (DMZ)     | 30 GB      | Ubuntu 22.04 LTS Server (DMZ Web server)      |
