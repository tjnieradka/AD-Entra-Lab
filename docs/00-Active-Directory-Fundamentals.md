
**Update in progress**

# 00. Active Directory Fundamentals

## Overview
This section summarizes core Active Directory concepts that underpin the hybrid identity lab.

---

## What is Active Directory?

Active Directory is a directory service that provides centralized authentication, authorization, and management of users, computers, and resources in a Windows environment.

---

## Domain

A domain is a security boundary that contains users, computers, and resources managed centrally.

- Has its own:  
-- Users, groups, computers  
-- Policies (GPOs)  
-- Uses a DNS name (e.g., `tntechdemo01.com` )  
-- Authentication happens within the domain  

---

## Tree

A tree is a group of domains that share a contiguous namespace.

Examples:  
`tntechdemo01.com`  
`corp.tntechdemo01.com`  
- The same namespace so they are part of the same tree.

---

## Forest

A forest is the top-level structure in Active Directory that contains one or more trees and defines the overall security boundary.

Forest = highest level  
Shares:  
- Schema (object definitions)  
- Configuration  
- Domains in a forest trust each other  

---

## Domain Controllers

Domain Controllers store the Active Directory database and handle authentication and directory services.

Active Directory uses a multi-master model where most domain controllers can accept changes.

---
## 3. FSMO Roles

### 3.1 FSMO Role Responsibilities


### 3.2 Identifying FSMO Role Holders in the Lab

The following command identifies the domain controllers currently holding the five FSMO roles:

`netdom query fsmo`

<img width="976" height="407" alt="image" src="https://github.com/user-attachments/assets/79b23146-afcd-4592-b20e-5269a489a7f9" />

The lab uses a single domain controller, VANDC1-W2022, which currently holds all five FSMO roles.
The command-line and PowerShell results confirm the role assignments:

 - `netdom query fsmo` displays all five FSMO role holders in one view.
 - `Get-ADDomain` identifies the three domain-level roles: PDC Emulator, RID Master, and Infrastructure Master.
 - `Get-ADForest` identifies the two forest-level roles: Schema Master and Domain Naming Master.

All five roles are assigned to VANDC1-W2022.tntechdemo01.com, which is appropriate for this single-domain-controller lab environment. In larger environments, FSMO roles may be distributed across multiple domain controllers.

| FSMO Role | Purpose |
|-----------|---------|
| Schema Master | Controls changes to the Active Directory schema. |
| Domain Naming Master | Controls the addition and removal of domains in the forest. |
| PDC Emulator | Provides important domain functions including time synchronization, password-change coordination, and account lockout processing. |
| RID Master | Allocates pools of Relative IDs (RIDs) to domain controllers for creating unique security identifiers (SIDs). |
| Infrastructure Master | Maintains references to objects located in other domains. |


## 4. DNS and Active Directory

### 4.1 AD DNS Dependency
### 4.2 Verifying Domain Controller DNS Records

[command]
[screenshot]
[short interpretation]

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
