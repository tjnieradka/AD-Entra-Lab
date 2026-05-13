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
