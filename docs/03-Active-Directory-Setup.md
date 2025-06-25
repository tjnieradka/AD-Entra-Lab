# Active Directory and DNS Server Setup -- Detailed Steps

## Preparation 

1. In Server Manager > Local Server > Properties, click on the Computer Name, and change to VANDC1-W2022. Reboot.
2. In Settings > Network & Ethernet > Advanced Network Settings > Change Adapter Options > Ethernet0 Properties.
   Disable (uncheck) Internet Protocol Version 6 (TCP/IPv6).
   Configure Internet Protocol Version 4 (TCP/IPv4) . Set static IP Address and DNS settings.

   ![image](https://github.com/user-attachments/assets/6cde8a6b-a513-49b6-8574-b695e5d2d373)

3. In Server Manager, select Manage > Add Roles and Features.

   ![image](https://github.com/user-attachments/assets/94157b25-0c8b-4495-8b91-f987e9bfb4ef)

4. In the Add Roles and Features Wizard, click Next on the Before You Begin screen.

5. In the Installation Type, select Role-based or Feature-based installation.

6. On the Server Selection screen, select VANDC1-W2022.
   
7. On the Server Roles screen, select Active Directory Domain Services, DNS Server (selection is optional, it would be installed automatically with this first domain controller), and DHCP Server (configured later).   Select to Add Features after each selection.

   ![image](https://github.com/user-attachments/assets/f4add9e4-f000-41b0-b575-92f479644b29)

8. Continue through the folloiwng screens (default settings, as needed): Features, DNS Server, DHCP Server, AD DS.

9. On the Confirmation screen, click Install.  AD DS, DNS, and DHCP would be installed.

## Installation and Configuration of Active Directory and DNS

11. Click on the yellow triangle with an exclamation mark. 

    ![image](https://github.com/user-attachments/assets/9e21c560-3986-49dd-8caa-6532dc41cae5)

12. Active Directory will be configured at thios stage (DHCP and DNS will be cobnfigured later). Select Priomote this server to a domain controller

13. Select Add a new forest.  The tntechdemo01.com domain is what I reserved.  Click Next.

    ![image](https://github.com/user-attachments/assets/2204b6f5-6d76-415b-b116-ab85297f6a07)

14. This lab will have only has one domain controller, and the highest available functional level in thiz wizard is Windows 2016 (if there were domain controllers at earlier versions of Windows, the function level would be selected to match these earlier domain controllers). DSRM password was entered in case a restore is needded from backup.

     ![image](https://github.com/user-attachments/assets/89b03d4c-7fed-4088-973a-c79eccb221b0)

15. Click Next on DNS Options.  The warning "A delegation for this DNS server cannot be created because the authoritative parent zone cannot be found" is normal.  The DNS Server needs to be configured afterwards.
    
17. For Additional Options, enter or confirm NetBIOS name TNTECHDEMO01.  This is a legacy domain name for older devices, if they need to interact with the domain.

18. For Paths, defaults were left as is.

    ![image](https://github.com/user-attachments/assets/d26514c6-9db9-4ca3-abad-17c1ed9e61ac)

19. Review Options and confirm.  The following script based on the selected setting is available if you click View Script button.

# Windows PowerShell script for AD DS Deployment
```
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "tntechdemo01.com" `
-DomainNetbiosName "TNTECHDEMO01" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
```
Click Next.

20. Note warnings and install.

     ![image](https://github.com/user-attachments/assets/3deaa2b1-5dcb-44d7-bbbf-587807c0d934)

21.  The installation will proceed and the server will reboot.

22.  Verify configuration after reboot.

     [image](https://github.com/user-attachments/assets/ff75132f-07a9-4217-a007-16e1432bf073)

23. In Tools > DNS, verify settings in DNS Manager.

     ![image](https://github.com/user-attachments/assets/5c7c3928-73af-409e-a68b-4143801c72c6)

24. In Tools > Active Directory Users and Computers, various administration tasks (e.g., user account setup) can be done.

    ![image](https://github.com/user-attachments/assets/043f9e04-7b69-4870-b4f8-4b4eecf7c980)

