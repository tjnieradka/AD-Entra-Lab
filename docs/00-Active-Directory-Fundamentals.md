
**Update in progress**

# 00. Active Directory Fundamentals

## 1. Overview
This section summarizes core Active Directory concepts that underpin the hybrid identity lab.

---

## 2. What is Active Directory?

Active Directory is a directory service that provides centralized authentication, authorization, and management of users, computers, and resources in a Windows environment.

---

## 2.1 Domain

A domain is a security boundary that contains users, computers, and resources managed centrally.

- Has its own:  
-- Users, groups, computers  
-- Policies (GPOs)  
-- Uses a DNS name (e.g., `tntechdemo01.com` )  
-- Authentication happens within the domain  

---

## 2.2 Tree

A tree is a group of domains that share a contiguous namespace.

Examples:  
`tntechdemo01.com`  
`corp.tntechdemo01.com`  
- The same namespace so they are part of the same tree.

---

## 2.3 Forest

A forest is the top-level structure in Active Directory that contains one or more trees and defines the overall security boundary.

Forest = highest level  
Shares:  
- Schema (object definitions)  
- Configuration  
- Domains in a forest trust each other  

---

## 2.4 Domain Controllers

Domain Controllers store the Active Directory database and handle authentication and directory services.

Active Directory uses a multi-master model where most domain controllers can accept changes.

---
## 3. FSMO Roles

### 3.1 FSMO Role Responsibilities

Active Directory uses five Flexible Single Master Operations (FSMO) roles for operations that require a specific domain controller to act as the authoritative role holder.

| FSMO Role | Purpose |
|-----------|---------|
| Schema Master | Controls changes to the Active Directory schema. |
| Domain Naming Master | Controls the addition and removal of domains in the forest. |
| PDC Emulator | Provides important domain functions including time synchronization, password-change coordination, and account lockout processing. |
| RID Master | Allocates pools of Relative IDs (RIDs) to domain controllers for creating unique security identifiers (SIDs). |
| Infrastructure Master | Maintains references to objects located in other domains. |


### 3.2 Identifying FSMO Role Holders in the Lab

The following command identifies the domain controllers currently holding the five FSMO roles:

`netdom query fsmo`

<img width="976" height="407" alt="image" src="https://github.com/user-attachments/assets/79b23146-afcd-4592-b20e-5269a489a7f9" />

The lab uses a single domain controller, VANDC1-W2022, which currently holds all five FSMO roles.
The following command-line and PowerShell commands confirm the role assignments:

 - `netdom query fsmo` displays all five FSMO role holders in one view.
 - `Get-ADDomain` identifies the three domain-level roles: PDC Emulator, RID Master, and Infrastructure Master.
 - `Get-ADForest` identifies the two forest-level roles: Schema Master and Domain Naming Master.

All five roles are assigned to VANDC1-W2022.tntechdemo01.com, which is appropriate for this single-domain-controller lab environment. In larger environments, FSMO roles may be distributed across multiple domain controllers.


## 4. DNS and Active Directory

### 4.1 AD DNS Dependency

Active Directory relies on DNS to locate domain controllers and directory services. Domain-joined systems use DNS records to identify servers that provide services such as authentication and LDAP.

In an Active Directory environment, DNS provides:

- **Host (A/AAAA) records** to resolve server names to IP addresses.
- **Service (SRV) records** to locate domain controllers and Active Directory services.
- **Domain controller locator records** used by clients to find appropriate domain controllers.
- Support for locating services required for authentication, including LDAP and Kerberos.

Domain-joined clients should use an Active Directory-aware DNS server rather than querying public DNS servers directly for domain resources. The AD DNS server can resolve internal domain records and forward external queries to an upstream DNS resolver.
Incorrect DNS configuration can cause problems with domain logons, domain controller discovery, Group Policy, and other Active Directory operations.

### 4.2 Verifying Domain Controller DNS Records

Active Directory uses DNS service (SRV) records to allow clients to locate domain controllers and services such as LDAP.

The following command queries the DNS records used to locate domain controllers for the lab domain:

`nslookup -type=SRV _ldap._tcp.dc._msdcs.tntechdemo01.com`

<img width="714" height="225" alt="image" src="https://github.com/user-attachments/assets/f8f29e1f-4b4c-4d90-8627-e528c3296cd7" />

A successful response identifies the domain controller registered for the domain. The SRV record includes:
- Service: LDAP (_ldap)
- Protocol: TCP (_tcp)
- Port: 389
- Target: The domain controller providing the service
- Priority and weight: Values DNS clients can use when multiple servers are available

This verifies that the domain controller has registered the DNS records required for clients to locate Active Directory services.



## 5. Validating the Lab Environment

### 5.1 Domain Configuration
`Get-ADDomain`

### 5.2 Forest Configuration
`Get-ADForest`

### 5.3 Domain Controllers
`Get-ADDomainController -Filter *`

### 5.4 Domain Controller Health
`dcdiag`

### 5.5 AD Replication
`repadmin /replsummary`





-------------------------------
## FSMO Roles

Certain operations are handled by specific domain controllers:

- Schema Master  
- Domain Naming Master  
- RID Master  
- PDC Emulator  
- Infrastructure Master  

---

## PDC Emulator

The PDC Emulator handles:
- Password changes
- Account lockouts
- Time synchronization

It is a writable domain controller with additional responsibilities.

---

## DNS in Active Directory

Active Directory relies heavily on DNS for locating domain controllers and services.

Incorrect DNS configuration is a common cause of AD issues.

---

## Relation to This Lab

This lab builds on these fundamentals by implementing:
- Hybrid identity (AD + Entra ID)
- Directory synchronization
- Authentication and device management
