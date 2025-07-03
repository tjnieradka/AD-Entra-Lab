⚠️ This lab is for demonstration only; not for production.

# 02.VyOS Router Setup

## 1. Introduction

VyOS 1.3 is an open-source, Debian-based network operating system used for routing, firewalling, NAT, DHCP, and VPN services. In this lab, VyOS 1.3 virtual machine acts as the edge router and zone-based firewall, separating the LAN, DMZ, and NAT interfaces. It simulates enterprise-class network segmentation and enforces access rules between on-premises and cloud-connected components (e.g., Entra Connect → Entra ID).

Official documentation (rolling & 1.3):
🔗 https://docs.vyos.io/en/equuleus/


## 2. Overview VyOS 1.3 Configuration

The following configurations were done on VyOS for the lab.  Note that some of the settings were done because this is a lab where VMware environment is shut down when not in use (ie., this is not a production system that stays online).  Some rulesets where done to allow various tests (e.g., ICMP was enabled to allow pings and debugging).

**1. Interfaces**
The VyOS router in this lab is configured with three network interfaces, each representing a separate network zone (set up as different VMware VLANs/virtual networks):
**eth0 (WAN):**
- Assigned via DHCP from the VMware NAT or bridged network.
- Represents the external interface used for internet access.
**eth1 (LAN):**
- Statically assigned the subnet 192.168.10.1/24.
- Used for internal (trusted) client devices such as AD, Windows, Linux clients.
**eth2 (DMZ)**
- Statically assigned the subnet 192.168.20.1/24.
- Used for semi-public or isolated servers (e.g., web servers).
These interfaces are mapped to separate VMware virtual networks (or VLANs) to simulate zone isolation. The WAN uses the VMware-provided NAT network for internet access.

**2. Masquerading**
Two masquerade rulesets were set up.
Masquerading is a type of Network Address Translation (NAT) that allows internal devices (in LAN or DMZ) to access the internet by sharing the VyOS router's WAN IP address.
It rewrites the source IP of outgoing packets to match the WAN interface IP.  In the this lab, it enables internet passthrough for VMs in 192.168.10.0/24 (LAN) and 192.168.20.0/24 (DMZ).

**3. Zone-based Firewalls**
The configuration in the VyOS uses zone-based firewalling to organize interfaces into security zones and control traffic between them.
Interfaces are assigned to security zones:
eth0 → WAN
eth1 → LAN
eth2 → DMZ

Default policy is set to drop.  All traffic between zones is denied by default. The firewall rules need to explictly to allow traffic (e.g., LAN to WAN).
This follows the principle of least privilege, ensuring only approved traffic is allowed between zones.

**4. LAN to WAN Firewall Rulesets**

The first ruleset, "set firewall name LAN-to-WAN default-action drop" controls outbound traffic from the LAN zone to the WAN (internet). It follows a default-deny posture and selectively allows essential traffic.
Ruleset 10 allows return traffic for existing connections.
Rulesets 20 to 60 allow traffic for common outbound ports. 
Ruleset 80 was added specifically for this lab to allow ICMP traffic (i.e., connectivity testing using pings)
The rulesets were applied using this command "set zone-policy zone WAN from LAN firewall name LAN-to-WAN"

**5. WAN to LAN Firewall Ruleset**

The first ruleset governs inbound traffic from the internet (WAN) to the LAN zone. It uses a default-deny policy for security and allows only specific, necessary traffic.
It allows return traffic for LAN-initiated connections. This rule is needed because the Entra Connect server (on the LAN) initiates secure outbound traffic to Microsoft Entra ID, and Entra responds.
The rulesets were applied using this command "set zone-policy zone LAN from WAN firewall name WAN-to-LAN".
   
**6. LAN to DMZ Firewall Ruleset**

The first ruleset governs inbound traffic from the internet (LAN) to the DMZ. It uses a default-deny policy for security and allows only specific, necessary traffic
It allows return traffic from DMZ servers that respond to LAN-initiated requests. 
It permits LAN clients to access DMZ-hosted websites on port 80 or 443.  The single test server in this lab is a Ubuntu Web server with a simplae http-based Web page.
The rule is applied using "set zone-policy zone DMZ from LAN firewall name LAN-to-DMZ".

This configuration is done purely for lab/demo purposes to verify web access and network routing. In a production environment, it is strongly recommended to:
- Use HTTPS (port 443) instead of HTTP(80).
- Restrict access by source IP or subnet.
- Enable logging for monitoring.
- Disable or remove unnecessary open ports.

**7. DMZ to LAN Firewall Ruleset**

The first ruleset governs inbound traffic from the internet (LAN) to the DMZ. It uses a default-deny policy for security and allows only specific, necessary traffic
It allows return traffic from DMZ servers that respond to LAN-initiated requests.  
This means DMZ devices cannot initiate connections to LAN — but can respond to requests originating from the LAN (e.g., if the Entra Connect server initiates a sync to a web-based admin tool in DMZ).
The rule is applied using "set zone-policy zone LAN from DMZ firewall name DMZ-to-LAN".

This setup is appropriate for lab environments where minimal exposure is acceptable and you need to observe request-response behavior between LAN and DMZ.
Production environments typically block all unsolicited DMZ-to-LAN traffic.  In real-world, additional rules would be added only for required services, such as:
- A secure connection from a reverse proxy in DMZ to an internal identity provider
- DNS or syslog forwarding (tightly controlled)

**8. DMZ to WAN Firewall Ruleset**

**9. WAN to DMZ Ruleset**

**10. Ipv6**
IPv6 fowarding is disabled.


## 3. VyOS 1.3 Configuration
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

# (Optional - allow pings for debug)
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

# Apply DMZ-to-WAN firewall policy to traffic originating in DMZ targeting WAN
set zone-policy zone WAN from DMZ firewall name DMZ-to-WAN

#---------------------------------------------------------
# WAN to DMZ
# Default to deny all WAN-initiated traffic
set firewall name WAN-to-DMZ default-action drop

# Allow only established or related sessions (e.g., responses to DMZ → WAN traffic)
set firewall name WAN-to-DMZ rule 10 action accept
set firewall name WAN-to-DMZ rule 10 state established enable
set firewall name WAN-to-DMZ rule 10 state related enable

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
| TCP      | 53   | DNS queries                                         | DNS                                   |
| UDP      | 53   | DNS queries                                         | DNS                                   |
| UDP      | 123  | NTP (Time sync with Internet or internal NTP)       | Needed if no internal NTP             |

ICMP port opened for diagnostics in the lab.

**LAN only**
| Protocol | Port | Description                                          | Notes                                 |
|----------|------|------------------------------------------------------|---------------------------------------|
| TCP      | 389  | LDAP to on-prem AD (internal)                       | LAN only – for AD sync                |
| TCP      | 88   | Kerberos auth to domain controller                  | LAN only                              |
| TCP      | 445  | SMB (Group Policy, logon scripts)                   | LAN only – avoid exposing externally  |

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
