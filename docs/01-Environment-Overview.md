# 01. Environment Overview

This virtual lab simulates a hybrid on-premises network integrated with **Microsoft Entra ID** (formerly Azure Active Directory). It provides a hands-on environment to explore Active Directory domain services, Entra Connect synchronization, firewall policies, and DMZ architecture using **VyOS 1.3** as a virtual router/firewall.

## 1. Architecture Highlights

- **VyOS Router (1.3 Equuleus)** provides routing, zone-based firewalling, and NAT.
  - **WAN (VMnet8)**: NAT interface for outbound internet/Entra connectivity
  - **LAN (VMnet2)**: Internal subnet for domain services and clients
  - **DMZ (VMnet3)**: Segregated network for web-accessible services
- **Active Directory Domain Controller (Windows Server 2022)** with DNS/DHCP roles
- **Entra Connect Server (Windows Server 2022)** to sync on-prem AD to Microsoft Entra ID
- **Windows 11 and Ubuntu clients** connected to the LAN subnet via DHCP
- **Ubuntu Web Server** hosted in the DMZ to simulate a public-facing server
- **Microsoft Entra ID (Cloud)** accessed over HTTPS for directory sync and auth

## 2. Subnet Configuration

| Zone      | Interface   | Subnet             | Notes                              |
|-----------|-------------|--------------------|-------------------------------------|
| LAN       | VMnet2      | 192.168.10.0/24    | Static: `.10–.50`, DHCP: `.100–.200`|
| DMZ       | VMnet3      | 192.168.20.0/24    | Static IPs assigned manually       |
| WAN (NAT) | VMnet8      | 192.168.35.0/24    | VMware NAT to Internet             |

## 3. Virtual Machines Summary

Machines start with 'VAN' to indicate they are located in Vancouver.

| VM Name           | vCPU | RAM  | Disk | NIC(s)           | OS/Role                                     |
|-------------------|------|------|------|------------------|---------------------------------------------|
| VANDC1-W2022      | 2    | 4 GB | 130 GB | VMnet2 (LAN)   | Windows Server 2022 – AD, DNS, DHCP       |
| VANEC1-W2022      | 2    | 4 GB | 130 GB | VMnet2 (LAN)        | Windows Server 2022 – Entra Connect, AD-joined       |
| VANCL1-W11        | 2    | 4 GB | 80 GB | VMnet2 (LAN)         | Windows 11 – DHCP client, AD-joined               |
| VANCL2-UBUNTU     | 2    | 2 GB | 30 GB | VMnet2 (LAN)         | Linux: Ubuntu 20 Desktop – DHCP client, AD-joined           |
| VYOS-ROUTER       | 1    | 1 GB | 10 GB | VMnet2/3/8 (LAN/DMZ/WAN)     | VyOS 1.3 – Router + ZBF                    |
| VANSRV-UBUNTU     | 2    | 2 GB | 30 GB | VMnet3 (DMZ)         | Ubuntu 20 Server – Static IP in DMZ        |

## 4. Microsoft Entra ID

- Cloud Directory: `EntraTenantName.onmicrosoft.com`
- Accessible from VyOS WAN interface via NAT
- Required for synchronization and token-based authentication

## 5. Firewall and Security

- VyOS uses **zone-based firewall (ZBF)** rules to restrict traffic between zones
- Inbound/Outbound rules are defined per zone-pair
- Only required ports for Entra Connect and AD traffic are allowed

## 6. Network Topology

- The diagram below provides an overview of the network topology.

![image](https://github.com/user-attachments/assets/f735ccd2-b936-4f7a-8be6-0008baa569c2)

## 6. VMware Setup

- This is how the above environment appears on VMware Workstation 17 Pro

![image](https://github.com/user-attachments/assets/5c19f0e6-ea32-42ad-8317-a2993e7e09ba)

- VMWare Virtual Network Editor Configuration
- Only VMnet2, VMnet3, VMnet8 are used in the lab.

![image](https://github.com/user-attachments/assets/5585d948-adbf-4448-953c-ccdd4b7fb478)
