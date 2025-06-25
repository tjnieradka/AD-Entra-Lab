# VyOS 1.3 (Equuleus) — Lab Router and Firewall

VyOS 1.3 is an open-source, Debian-based network operating system used for routing, firewalling, NAT, DHCP, and VPN services. In this lab, VyOS 1.3 virtual machine acts as the edge router and zone-based firewall, separating the LAN, DMZ, and NAT interfaces. It simulates enterprise-class network segmentation and enforces access rules between on-premises and cloud-connected components (e.g., Entra Connect → Entra ID).

Official documentation (rolling & 1.3):
🔗 https://docs.vyos.io/en/equuleus/


# VyOS 1.3 Configuration used in the lab

The following are commands used to configure the VyOS router and firewall. The main obhjective is to allow connectivity between the on-premise Active Directory and Entra.
```
configure

# Interfaces
set interfaces ethernet eth0 address dhcp
set interfaces ethernet eth0 description 'WAN'
set interfaces ethernet eth1 address '192.168.10.1/24'
set interfaces ethernet eth1 description 'LAN'
set interfaces ethernet eth2 address '192.168.20.1/24'
set interfaces ethernet eth2 description 'DMZ'

# Zone-based firewall
set zone-policy zone WAN interface eth0
set zone-policy zone LAN interface eth1
set zone-policy zone DMZ interface eth2
set zone-policy zone WAN default-action drop
set zone-policy zone LAN default-action drop
set zone-policy zone DMZ default-action drop


# Firewall Rules (LAN to WAN - basic)
set firewall name LAN-to-WAN default-action drop
set firewall name LAN-to-WAN rule 10 action accept
set firewall name LAN-to-WAN rule 10 state established enable
set firewall name LAN-to-WAN rule 10 state related enable  # "if the connection was initiated from the LAN, this rule allows the response back to the LAN"

set firewall name LAN-to-WAN rule 20 action accept
set firewall name LAN-to-WAN rule 20 protocol tcp
set firewall name LAN-to-WAN rule 20 destination port 443  # HTTPS

set firewall name LAN-to-WAN rule 30 action accept
set firewall name LAN-to-WAN rule 30 protocol tcp
set firewall name LAN-to-WAN rule 30 destination port 80   # HTTP

set firewall name LAN-to-WAN rule 40 action accept
set firewall name LAN-to-WAN rule 40 protocol tcp
set firewall name LAN-to-WAN rule 40 destination port 389  # LDAP

set firewall name LAN-to-WAN rule 50 action accept
set firewall name LAN-to-WAN rule 50 protocol tcp
set firewall name LAN-to-WAN rule 50 destination port 88   # Kerberos

set firewall name LAN-to-WAN rule 60 action accept
set firewall name LAN-to-WAN rule 60 protocol tcp
set firewall name LAN-to-WAN rule 60 destination port 445  # SMB

set firewall name LAN-to-WAN rule 70 action accept
set firewall name LAN-to-WAN rule 70 protocol udp
set firewall name LAN-to-WAN rule 70 destination port 123  # NTP

# Apply zone-to-zone policy
set zone-policy zone LAN from WAN firewall name LAN-to-WAN

commit
save
```

Here is a summary of why specific ports were configured.

Entra Connect Port Requirements 

**LAN → WAN** 
| Protocol | Port | Description                                          | Notes                                 |
|----------|------|------------------------------------------------------|---------------------------------------|
| TCP      | 443  | HTTPS (Azure AD Connect to Entra endpoints)         | Mandatory for sync, token auth, etc.  |
| TCP      | 80   | HTTP (Redirect or telemetry)                        | Optional – used for fallback/redirect |
| TCP      | 389  | LDAP to on-prem AD (internal)                       | LAN only – for AD sync                |
| TCP      | 88   | Kerberos auth to domain controller                  | LAN only                              |
| TCP      | 445  | SMB (Group Policy, logon scripts)                   | LAN only – avoid exposing externally  |
| UDP      | 123  | NTP (Time sync with Internet or internal NTP)       | Needed if no internal NTP             |

**WAN → LAN** 

None normally required -All sync is outbound only from LAN 

# VyOS 1.3 Virtual machine screenshot

![image](https://github.com/user-attachments/assets/bbc282bd-7b3a-4c93-a91b-b22037cb6a5e)
