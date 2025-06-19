# Environment Setup

**Overview**


![image](https://github.com/user-attachments/assets/f735ccd2-b936-4f7a-8be6-0008baa569c2)


------------------------------------------------------------------------------------------

1. Set up VMWare machines

![image](https://github.com/user-attachments/assets/8ba50fef-601a-42b3-8677-86377c002542)

2. Configure VyOS open source router on a VMWare machine.

   VyOS 1.3 Configuration:
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

**Entra Connect Port Requirements**  
**LAN → WAN**  
**TCP	443	HTTPS** (Azure AD Connect to Entra endpoints)	- Mandatory for sync, token auth, service access  
**TCP	80	HTTP** (Redirect or telemetry)	- Optional – used for fallback & redirect  
**TCP	389	LDAP** to on-prem AD (internal)	- Needed within LAN only, for AD sync  
**TCP	88	Kerberos** auth to domain controller	- Also LAN-only  
**TCP	445	SMB** (Group Policy, logon scripts)	- Also LAN-only, avoid exposing externally  
**UDP	123	NTP** (Time sync with Internet or internal NTP)	- Needed if not syncing time locally  

**WAN → LAN**	
None normally required -All sync is outbound only from LAN  

![image](https://github.com/user-attachments/assets/36ce1e95-97f2-4d20-9a62-4fec1659582e)

