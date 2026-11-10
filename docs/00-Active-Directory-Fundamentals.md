
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
- Internet Address: 192.168.10.10
- Target: The domain controller providing the service
- Priority and weight: Values DNS clients can use when multiple servers are available

This verifies that the domain controller has registered the DNS records required for clients to locate Active Directory services.



## 5. Validating the Lab Environment

### 5.1 Domain Configuration

The `Get-ADDomain` PowerShell cmdlet can be used to retrieve configuration information about the current Active Directory domain.

`Get-ADDomain | Select-Object DNSRoot, NetBIOSName, DomainMode, PDCEmulator, RIDMaster, InfrastructureMaster`

<img width="1024" height="230" alt="image" src="https://github.com/user-attachments/assets/2029256c-887d-4836-a5c2-35789a901a02" />

The output confirms the primary configuration of the lab domain:

- **DNS domain:** tntechdemo01.com
- **NetBIOS domain:** TNTECHDEMO01
- **Domain functional level:** Windows2016Domain
- **PDC Emulator:** VANDC1-W2022.tntechdemo01.com
- **RID Master:** VANDC1-W2022.tntechdemo01.com
- **Infrastructure Master:** VANDC1-W2022.tntechdemo01.com

The three domain-level FSMO roles are hosted by the lab's single domain controller, consistent with the FSMO role validation performed earlier.

### 5.2 Forest Configuration

The `Get-ADForest` PowerShell cmdlet retrieves configuration information about the Active Directory forest.

`Get-ADForest | Select-Object Name, ForestMode, Domains, GlobalCatalogs, SchemaMaster, DomainNamingMaster`

<img width="1023" height="232" alt="image" src="https://github.com/user-attachments/assets/dcea777b-2880-4a13-adb5-e7a5fffaf5c9" />

The output confirms the primary configuration of the lab forest:
- **Forest:** tntechdemo01.com
- **Forest functional level:** Windows2016Forest
- **Domains:** tntechdemo01.com
- **Global Catalog:** VANDC1-W2022.tntechdemo01.com
- **Schema Master:** VANDC1-W2022.tntechdemo01.com
- **Domain Naming Master:** VANDC1-W2022.tntechdemo01.com

The lab consists of a single-domain forest with VANDC1-W2022 operating as the Global Catalog server and holding both forest-level FSMO roles.

### 5.3 Domain Controllers

The `Get-ADDomainController` PowerShell cmdlet can be used to identify domain controllers and review their primary configuration.

`Get-ADDomainController -Filter * | Select-Object HostName, IPv4Address, Site, OperatingSystem, IsGlobalCatalog, IsReadOnly`

<img width="1021" height="223" alt="image" src="https://github.com/user-attachments/assets/ab95520a-eb18-4e50-87e6-e659e1ef11c7" />

The output identifies the domain controller used by the lab and confirms several of its key properties:
- **Domain controller:** VANDC1-W2022.tntechdemo01.com
- **IPv4 address:** 192.168.10.10
- **AD site:** Default-First-Site-Name
- **Operating system:** Windows Server 2022 Datacenter Evaluation
- **Global Catalog:** True
- **Read-only domain controller:** False

This confirms that VANDC1-W2022 is a writable domain controller and Global Catalog server for the lab environment.

### 5.4 Domain Controller Health

The dcdiag utility provides diagnostic tests for evaluating the health and configuration of an Active Directory domain controller. Individual tests can be run to investigate specific components without displaying the complete diagnostic output.

The following tests were used to validate several core domain controller functions:

`dcdiag /test:Connectivity`
`dcdiag /test:Advertising`
`dcdiag /test:SysVolCheck`
`dcdiag /test:NetLogons`

<img width="1020" height="544" alt="image" src="https://github.com/user-attachments/assets/2822cc88-19fc-4410-9a89-839015558179" />

<img width="1021" height="577" alt="image" src="https://github.com/user-attachments/assets/d5fe47a1-5fe6-45bf-8858-bb9d3555274d" />

<img width="1021" height="580" alt="image" src="https://github.com/user-attachments/assets/4038b83f-e778-4d7d-9c33-e14237baeb41" />

<img width="1018" height="575" alt="image" src="https://github.com/user-attachments/assets/88f6658b-ec7f-4bb7-af9b-23b63c6ce0c4" />

The tests confirm that:

- **Connectivity** — the domain controller can be located and basic connectivity tests succeed.
- **Advertising** — the domain controller is correctly advertising its Active Directory services.
- **SysVolCheck** — the SYSVOL shared directory is available.
- **NetLogon**s — the required SYSVOL and NETLOGON shares can be accessed.

All four targeted tests completed successfully on VANDC1-W2022.

### 5.5 AD Replication

Active Directory uses replication to synchronize directory changes between domain controllers. The repadmin utility can be used to examine replication status and troubleshoot replication problems.

The following command displays a summary of replication activity:

`repadmin /replsummary`

<img width="1014" height="218" alt="image" src="https://github.com/user-attachments/assets/cb7f4b23-f18f-482a-b577-0d2d4ee4a872" />

The lab currently contains a single domain controller. As a result, there are no other domain controllers acting as replication partners, and the replication summary does not list any source or destination DSAs.

In a multi-domain-controller environment, this command would display replication partners, the largest replication delta, the number of failed replication attempts, and associated replication errors.



## 6. Relationship to the Hybrid Identity Lab

The Active Directory components described in this section provide the on-premises identity foundation for the hybrid lab.

The lab builds on these fundamentals by implementing:
- **Hybrid identity** — integrating the on-premises Active Directory domain with Microsoft Entra ID.
- **Directory synchronization** — using Microsoft Entra Connect to synchronize selected identities from Active Directory to Entra ID.
- **Hybrid device identity** — connecting Windows devices to both the on-premises Active Directory environment and Microsoft Entra ID.
- **Authentication and access management** — exploring authentication, Microsoft Entra ID, and Microsoft 365 identity features.
- **Endpoint management** — extending the environment into Microsoft Intune for device enrollment, compliance, and management testing.

Understanding the underlying domain, DNS, domain controller, FSMO, and directory-service components helps provide context for how the on-premises Active Directory environment integrates with Microsoft's cloud identity and device-management services.
