# Microsoft 365 Administration

## 1. Overview

The hybrid identity lab was extended into Microsoft 365 to explore cloud-based identity, licensing, endpoint management, messaging, and security administration.

The Microsoft 365 admin center provides a central administrative interface for managing users, licenses, services, and access to specialized Microsoft administration portals.

Home screen of Microsoft 365 admin center set up for the lab environment.

<img width="1602" height="937" alt="image" src="https://github.com/user-attachments/assets/9e0cf356-b988-4ed9-9fb8-01b18b2d6838" />



## 2. Microsoft 365 Admin Center

The Microsoft 365 admin center provides centralized administration for Microsoft 365 services.

Key administrative functions available in the lab include:

- Managing users and groups
- Assigning and reviewing licenses
- Resetting user passwords
- Reviewing Microsoft 365 products and services
- Accessing service health and administrative reports
- Opening specialized Microsoft administration centers

The lab contains test accounts used for identity, synchronization, licensing, and endpoint-management exercises.

## 3. Administrative Portals

Microsoft 365 administration is distributed across several specialized portals. The following administration centers are available in the lab environment:

| **Administration Center** | **Primary Purpose** |
|---|---|
| Microsoft 365 Admin Center | Central administration of users, licenses, Microsoft 365 services, settings, and service health |
| Microsoft Entra Admin Center | Identity, users, groups, authentication, roles, Conditional Access, and hybrid identity |
| Microsoft Intune Admin Center | Endpoint enrollment, configuration, compliance, applications, and device management |
| Microsoft Defender / Security | Security monitoring, incidents, alerts, and security configuration |
| Microsoft Purview | Data governance, information protection, compliance, and related data-security capabilities |
| Exchange Admin Center | Exchange Online recipients, mailboxes, mail flow, and messaging configuration |
| Azure Portal | Administration of Azure resources and cloud services |

These portals separate administrative functions while using identities and services that are integrated within the same Microsoft cloud environment.

## 4. Identity and User Administration

The Microsoft 365 environment includes both cloud-based and synchronized test identities.

Microsoft Entra Connect integrates the on-premises Active Directory environment with Microsoft Entra ID, allowing selected Active Directory identities to be represented in the cloud environment.

Administrative tasks explored in the lab include:

- Reviewing users and groups
- Verifying synchronized identities
- Reviewing user licensing
- Managing cloud test accounts
- Reviewing authentication and identity settings

## 5. Licensing

Microsoft 365 services and administrative capabilities depend on the licenses assigned to users.

The lab has been used to review license assignments and determine which Microsoft 365, Entra ID, Intune, and security capabilities are available to individual test accounts.

Licensing is managed through the Microsoft 365 admin center and can also affect functionality exposed through specialized administration portals.

## 6. Integration with the Hybrid Identity Lab

Microsoft 365 extends the lab beyond the on-premises Active Directory environment.

The overall identity path demonstrated by the lab is:

**Active Directory → Microsoft Entra Connect → Microsoft Entra ID → Microsoft 365 / Intune**

This provides a practical environment for exploring how traditional Active Directory identity services integrate with Microsoft's cloud identity, productivity, security, and endpoint-management platforms.
