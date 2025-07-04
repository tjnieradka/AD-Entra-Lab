⚠️ This lab is for demonstration only; not for production.

# 02.VyOS Router Setup

## 1. Introduction

VyOS 1.3 is an open-source, Debian-based network operating system used for routing, firewalling, NAT, DHCP, and VPN services. In this lab, VyOS 1.3 virtual machine acts as the edge router and zone-based firewall, separating the LAN, DMZ, and NAT (labelled as WAN) interfaces. It simulates enterprise-class network segmentation and enforces access rules between on-premises and cloud-connected components (e.g., Entra Connect → Entra ID).

Official documentation (rolling & 1.3):
🔗 https://docs.vyos.io/en/equuleus/


## 2. Overview VyOS 1.3 Configuration  

The following configurations were done on VyOS for the lab.  Note that some of the settings were done because this is a lab where VMware environment is shut down when not in use (ie., this is not a production system that stays online all the time).  Some rulesets where done to allow various tests (e.g., ICMP was enabled to allow pings and debugging).

**1. Interfaces**  

The VyOS router is configured with three network interfaces, each representing a separate network zone (set up as different VMware VLANs/virtual networks):  

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

**4. Firewall Rulesets**  
The firewall rules are set up in this pattern:
- First rule has the default action to deny traffic. Allowed traffic is explicity defined in later rulesets.
- Second ruleset (i.e., labelled as 10) allows traffic for returning or related connections.
- Additional rulesets define the protocol and destination ports that allow traffic.
- Final command is to apply firewall configuration.
  
**5. Lab Configuration Notes**  
Some of the configurations were done purely for lab/demo purposes to verify web access and network routing.  They are not recommended for production environment.

LAN to DMZ  
In a production environment, it is strongly recommended to:
- Use HTTPS (port 443) instead of HTTP(80).
- Restrict access by source IP or subnet.
- Enable logging for monitoring.
- Disable or remove unnecessary open ports.

DMZ to LAN  
The setup here is appropriate for lab environments where minimal exposure is acceptable and we need to observe request-response behavior between LAN and DMZ.
Production environments typically block all unsolicited DMZ-to-LAN traffic.  In real-world, additional rules would be added only for required services, such as:
- A secure connection from a reverse proxy in DMZ to an internal identity provider
- DNS or syslog forwarding (tightly controlled)

DMZ to WAN  
The current DMZ-to-WAN firewall rule allows all outbound traffic from the DMZ subnet for testing and package updates. This is not a best practice in production environments.
In real deployments:
- Outbound access should be restricted to essential ports (e.g., 80, 443, 123).
- Egress filtering and logging should be enforced.
- Traffic to the WAN should be monitored and tightly scoped.

**6. Ipv6**  
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
# Test Ubuntu Web Server with a simple Web site is set up in DMZ. 
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
# Default action is to deny traffic. Allowed traffic is explicity defined in later rulesets.
set firewall name LAN-to-WAN default-action drop

# Allow traffic for returning or related connections
set firewall name LAN-to-WAN rule 10 action accept
set firewall name LAN-to-WAN rule 10 state established enable
set firewall name LAN-to-WAN rule 10 state related enable

# Allow traffic on specific protocols and destination ports 
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

# (Optional - set up in the lab to allow pings for debugging)
set firewall name LAN-to-WAN rule 80 action accept
set firewall name LAN-to-WAN rule 80 protocol icmp

# Apply firewall configuration
set zone-policy zone WAN from LAN firewall name LAN-to-WAN

#---------------------------------------------------------

# WAN to LAN
# Default action is to deny traffic. Allowed traffic is explicity defined in later rulesets.
set firewall name WAN-to-LAN default-action drop

# Allow traffic for returning or related connections
set firewall name WAN-to-LAN rule 10 action accept
set firewall name WAN-to-LAN rule 10 state established enable
set firewall name WAN-to-LAN rule 10 state related enable

# Apply firewall configuration
set zone-policy zone LAN from WAN firewall name WAN-to-LAN

#---------------------------------------------------------

# LAN to DMZ
# Default action is to deny traffic. Allowed traffic is explicity defined in later rulesets.
set firewall name LAN-to-DMZ default-action drop

# Allow traffic for returning or related connections
set firewall name LAN-to-DMZ rule 10 action accept
set firewall name LAN-to-DMZ rule 10 state established enable
set firewall name LAN-to-DMZ rule 10 state related enable

# Allow traffic on specific protocols and destination ports (lab configuration, not meant for production scenario)
set firewall name LAN-to-DMZ rule 20 action accept
set firewall name LAN-to-DMZ rule 20 protocol tcp
set firewall name LAN-to-DMZ rule 20 destination port 80

set firewall name LAN-to-DMZ rule 30 action accept
set firewall name LAN-to-DMZ rule 30 protocol tcp
set firewall name LAN-to-DMZ rule 30 destination port 443

# Apply firewall configuration
set zone-policy zone DMZ from LAN firewall name LAN-to-DMZ

#---------------------------------------------------------

# DMZ to LAN (optional, usually strict)
# Default action is to deny traffic. Allowed traffic is explicity defined in later rulesets.
set firewall name DMZ-to-LAN default-action drop

# Allow traffic for returning or related connections
set firewall name DMZ-to-LAN rule 10 action accept
set firewall name DMZ-to-LAN rule 10 state established enable
set firewall name DMZ-to-LAN rule 10 state related enable

# Apply firewall configuration
set zone-policy zone LAN from DMZ firewall name DMZ-to-LAN

#---------------------------------------------------------

# DMZ to WAN
# Default action is to deny traffic. Allowed traffic is explicity defined in later rulesets.
set firewall name DMZ-to-WAN default-action drop

# Lab Environment: Allow all outbound traffic from DMZ subnet to internet (e.g., updates, NTP, testing web access)
# ⚠️ NOTE: In production, this should be limited to specific destination ports (e.g., 80/443, 123 for NTP)
set firewall name DMZ-to-WAN rule 10 action accept
set firewall name DMZ-to-WAN rule 10 source address '192.168.20.0/24'
set firewall name DMZ-to-WAN rule 10 destination address '0.0.0.0/0'
set firewall name DMZ-to-WAN rule 10 protocol all

# Apply firewall configuration
set zone-policy zone WAN from DMZ firewall name DMZ-to-WAN

#---------------------------------------------------------
# WAN to DMZ
# Default action is to deny traffic. Allowed traffic is explicity defined in later rulesets.
set firewall name WAN-to-DMZ default-action drop

# Allow returning traffic from outbound connections (HTTP requests, NTP, etc.)
set firewall name WAN-to-DMZ rule 10 action accept
set firewall name WAN-to-DMZ rule 10 state established enable
set firewall name WAN-to-DMZ rule 10 state related enable

# Apply firewall configuration
set zone-policy zone DMZ from WAN firewall name WAN-to-DMZ

#---------------------------------------------------------
# IPv6 - disable forwarding
set system ipv6 disable-forwarding

commit
save
```
## 3. Ports

Here is a summary of relevant ports.

| Protocol | Port | Description                                          | Notes                                 |
|----------|------|------------------------------------------------------|---------------------------------------|
| TCP      | 443  | HTTPS (Azure AD Connect to Entra endpoints)         | Mandatory for sync, token auth, etc.  |
| TCP      | 80   | HTTP (Redirect or telemetry)                        | Optional – used for fallback/redirect |
| TCP      | 53   | DNS queries                                         | DNS                                   |
| UDP      | 53   | DNS queries                                         | DNS                                   |
| UDP      | 123  | NTP (Time sync with Internet or internal NTP)       | Needed if no internal NTP             |

ICMP port opened for diagnostics in the lab.

| Protocol | Port | Description                                          | Notes                                 |
|----------|------|------------------------------------------------------|---------------------------------------|
| TCP      | 389  | LDAP to on-prem AD (internal)                       | LAN only – for AD sync                |
| TCP      | 88   | Kerberos auth to domain controller                  | LAN only                              |
| TCP      | 445  | SMB (Group Policy, logon scripts)                   | LAN only – avoid exposing externally  |

