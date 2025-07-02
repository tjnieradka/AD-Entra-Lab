# 08. Joining Windows Client to Active Directory

## 1. Configure Network Settings

1. The client is already DHCP-enabled and is getting network settings from DHCP.  IPv6 was disabled in Ethernet connection properties.

   ![image](https://github.com/user-attachments/assets/7be8e610-2af4-4d7e-8017-0de0e7995b16)


2. Rename system to VANCL1-W11.

   ![image](https://github.com/user-attachments/assets/5c6ad9a9-d1e0-4dd7-85f8-051d6d1b4e5d)

## 2. Join the Domain

1. Open Settings > System > About and click "Domain or Workgroup" in Related Links.

   ![image](https://github.com/user-attachments/assets/0f641a22-3cc1-428b-9ad8-28b9bd6ed13e)

2. In System Properties > Computer Name, click on Change.
3. In Computer Name/Domain Changes, select Domain in Member Of section.
4. Enter tntechdemo01.com
5. Enter administrator to join the domain.

   ![image](https://github.com/user-attachments/assets/a4b2b2ba-804d-46cd-b3a2-bd4f466394ed)

6. A Welcome message will confirm successful join.

   ![image](https://github.com/user-attachments/assets/c581f2e4-47c3-40e9-878e-14f4aab4c722)

7. New Computer account is created in Active Directory.

   ![image](https://github.com/user-attachments/assets/f0a39737-bf2a-4f06-a0f0-cd3f59969971)

8. The command `dsregcmd` provides information on the join type

   ![image](https://github.com/user-attachments/assets/57661f9b-fc52-4b75-a556-e6713e0c9871)

   This client has only joined the TNTECHDEMO01 domain.
