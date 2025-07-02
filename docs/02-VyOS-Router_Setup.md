# 02.VyOS Router Setup

## 1. Introduction

VyOS 1.3 is an open-source, Debian-based network operating system used for routing, firewalling, NAT, DHCP, and VPN services. In this lab, VyOS 1.3 virtual machine acts as the edge router and zone-based firewall, separating the LAN, DMZ, and NAT interfaces. It simulates enterprise-class network segmentation and enforces access rules between on-premises and cloud-connected components (e.g., Entra Connect → Entra ID).

Official documentation (rolling & 1.3):
🔗 https://docs.vyos.io/en/equuleus/


## 2. VyOS 1.3 Configuration

The following are commands used to configure the VyOS router and firewall for the lab. The main objective is to allow connectivity between the on-premise Active Directory and Entra.  
```
# Interfaces
set interfaces ethernet eth0 address dhcp
set interfaces ethernet eth0 description 'WAN'
set interfaces ethernet eth1 address '192.168.10.1/24'
set interfaces ethernet eth1 description 'LAN'
set interfaces ethernet eth2 address '192.168.20.1/24'
set interfaces ethernet eth2 description 'DMZ'

# NAT (LAN to WAN masquerade)
set nat source rule 100 outbound-interface 'eth0'
set nat source rule 100 source address '192.168.10.0/24'
set nat source rule 100 translation address masquerade

# NAT (DMZ to WAN masquerade)
set nat source rule 110 outbound-interface 'eth0'
set nat source rule 110 source address '192.168.20.0/24'
set nat source rule 110 translation address masquerade

# Define Zones
set zone-policy zone WAN interface eth0
set zone-policy zone LAN interface eth1
set zone-policy zone DMZ interface eth2

set zone-policy zone WAN default-action drop
set zone-policy zone LAN default-action drop
set zone-policy zone DMZ default-action drop

# ----------- FIREWALL RULESETS ------------

# LAN to WAN
set firewall name LAN-to-WAN default-action drop
set firewall name LAN-to-WAN rule 10 action accept
set firewall name LAN-to-WAN rule 10 state established enable
set firewall name LAN-to-WAN rule 10 state related enable

set firewall name LAN-to-WAN rule 20 action accept
set firewall name LAN-to-WAN rule 20 protocol tcp
set firewall name LAN-to-WAN rule 20 destination port 443

set firewall name LAN-to-WAN rule 30 action accept
set firewall name LAN-to-WAN rule 30 protocol tcp
set firewall name LAN-to-WAN rule 30 destination port 80

set firewall name LAN-to-WAN rule 40 action accept
set firewall name LAN-to-WAN rule 40 protocol udp
set firewall name LAN-to-WAN rule 40 destination port 53

set firewall name LAN-to-WAN rule 50 action accept
set firewall name LAN-to-WAN rule 50 protocol tcp
set firewall name LAN-to-WAN rule 50 destination port 53

set firewall name LAN-to-WAN rule 60 action accept
set firewall name LAN-to-WAN rule 60 protocol udp
set firewall name LAN-to-WAN rule 60 destination port 123

# (Optional - allow pings from Internet for debug)
set firewall name LAN-to-WAN rule 80 action accept
set firewall name LAN-to-WAN rule 80 protocol icmp

# Apply LAN-to-WAN rule
set zone-policy zone WAN from LAN firewall name LAN-to-WAN

#---------------------------------------------------------

# WAN to LAN
set firewall name WAN-to-LAN default-action drop
set firewall name WAN-to-LAN rule 10 action accept
set firewall name WAN-to-LAN rule 10 state established enable
set firewall name WAN-to-LAN rule 10 state related enable

# (Optional - allow pings from Internet for debug)
set firewall name WAN-to-LAN rule 20 action accept
set firewall name WAN-to-LAN rule 20 protocol icmp

# Apply WAN-to-LAN rule
set zone-policy zone LAN from WAN firewall name WAN-to-LAN

#---------------------------------------------------------

# LAN to DMZ
set firewall name LAN-to-DMZ default-action drop
set firewall name LAN-to-DMZ rule 10 action accept
set firewall name LAN-to-DMZ rule 10 state established enable
set firewall name LAN-to-DMZ rule 10 state related enable

set firewall name LAN-to-DMZ rule 20 action accept
set firewall name LAN-to-DMZ rule 20 protocol tcp
set firewall name LAN-to-DMZ rule 20 destination port 80

set firewall name LAN-to-DMZ rule 30 action accept
set firewall name LAN-to-DMZ rule 30 protocol tcp
set firewall name LAN-to-DMZ rule 30 destination port 443

# Apply LAN-to-DMZ rule
set zone-policy zone DMZ from LAN firewall name LAN-to-DMZ

#---------------------------------------------------------

# DMZ to LAN (optional, usually strict)
set firewall name DMZ-to-LAN default-action drop
set firewall name DMZ-to-LAN rule 10 action accept
set firewall name DMZ-to-LAN rule 10 state established enable
set firewall name DMZ-to-LAN rule 10 state related enable

# Apply DMZ-to-LAN rule
set zone-policy zone LAN from DMZ firewall name DMZ-to-LAN

#---------------------------------------------------------

# DMZ to WAN
# Default to deny everything
set firewall name DMZ-to-WAN default-action drop

# Allow all outbound traffic from DMZ subnet to internet (0.0.0.0/0)
# NOTE: You can restrict this to certain ports later (e.g., HTTP/HTTPS only)
set firewall name DMZ-to-WAN rule 10 action accept
set firewall name DMZ-to-WAN rule 10 source address '192.168.20.0/24'
set firewall name DMZ-to-WAN rule 10 destination address '0.0.0.0/0'
set firewall name DMZ-to-WAN rule 10 protocol all

# Default to deny all WAN-initiated traffic
set firewall name WAN-to-DMZ default-action drop

# Allow only established or related sessions (e.g., responses to DMZ → WAN traffic)
set firewall name WAN-to-DMZ rule 10 action accept
set firewall name WAN-to-DMZ rule 10 state established enable
set firewall name WAN-to-DMZ rule 10 state related enable

# Apply DMZ-to-WAN firewall policy to traffic originating in DMZ targeting WAN
set zone-policy zone WAN from DMZ firewall name DMZ-to-WAN

# Apply WAN-to-DMZ policy for return traffic
set zone-policy zone DMZ from WAN firewall name WAN-to-DMZ

#---------------------------------------------------------
# IPv6 - disable forwarding
set system ipv6 disable-forwarding

commit
save
```
## 3. Ports

Here is a summary of why specific ports were configured.

Entra Connect Port Requirements (update needed)

**LAN → WAN** 
| Protocol | Port | Description                                          | Notes                                 |
|----------|------|------------------------------------------------------|---------------------------------------|
| TCP      | 443  | HTTPS (Azure AD Connect to Entra endpoints)         | Mandatory for sync, token auth, etc.  |
| TCP      | 80   | HTTP (Redirect or telemetry)                        | Optional – used for fallback/redirect |
| TCP      | 389  | LDAP to on-prem AD (internal)                       | LAN only – for AD sync                |
| TCP      | 88   | Kerberos auth to domain controller                  | LAN only                              |
| TCP      | 445  | SMB (Group Policy, logon scripts)                   | LAN only – avoid exposing externally  |
| UDP      | 123  | NTP (Time sync with Internet or internal NTP)       | Needed if no internal NTP             |

icmp port opened for diagnostics in the lab.

**WAN → LAN** 

None normally required -All sync is outbound only from LAN 

**DMZ → LAN** 

_Work in progress_

 Protocol | Port | Description                                          | Notes                                 |
|----------|------|------------------------------------------------------|---------------------------------------|
| TCP      | 443  | HTTPS                      | Test Web traffic from Web server in the DMZ |
| TCP      | 80   | HTTP                       | Test Web traffic from Web server in the DMZ |

**DMZ → WAN** 

_Work in progress_
