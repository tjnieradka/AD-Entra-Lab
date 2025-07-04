⚠️ This lab is for demonstration only; not for production.

# 07. Entra Connect Setup and Sync

## 1. Entra Connect Configuration

1. Here is what Entra Connect looks like before it is connected to on-premise Active Directory.  
   **Key settings:**  
   Last sync: Has never run  
   Password Hash Synch: Disabled  
   Seemless single sign-on: Disabled 0 domains  
   
    ![image](https://github.com/user-attachments/assets/d87537bc-585b-4206-aecd-52507ae6d753)

3. Download Connect Sync Agent from **Microsoft Entra admin center > Hybrid management > Microsoft Entra Connect**.

   ![image](https://github.com/user-attachments/assets/2eae65cc-08c0-4450-bfe1-cd0b381bb954)

4. Copy downloaded AzureAdConnect.msi to VANEC1-W2022 server, which is designated as the Entra Connect Server in this lab.

5. Start the installation of Entra Connect Sync agent.

   ![image](https://github.com/user-attachments/assets/f9759dbd-b4fd-41a1-8cd2-df11ab94aad2)

6. Select **Customize**.

   ![image](https://github.com/user-attachments/assets/d87419c0-5aa8-4cf9-ab17-f11fc50ee9f1)

7. Keep the default setting and click **Install**.
      
   ![image](https://github.com/user-attachments/assets/2024cb1b-14b4-4e4c-83ea-63681c128021)
   
8. Select **Password Hash Synchronization**.

   ![image](https://github.com/user-attachments/assets/359e649a-a800-4f03-b73b-a85fc9985b5f)

**Authentication Comparison** 

| Feature / Aspect                         | Password Hash Sync (PHS)                                       | Pass-through Authentication (PTA)                                | Federated Authentication                                          |
|------------------------------------------|----------------------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|
| **Authentication location**              | Microsoft Entra ID (cloud)                                     | On-prem AD (via installed authentication agents)                 | On-prem AD (via federation server like AD FS)                    |
| **Real-time credential check**           | No (uses previously synced password hash)                    | Yes (credentials validated live against AD)                    | Yes (via AD FS)                                               |
| **Requires AD FS / WAP?**                | No                                                           | No                                                             | Yes                                                           |
| **Entra Connect required?**              | Yes (for identity + password hash sync)                      | Yes (for identity sync, plus agent install for PTA)            | Yes (for identity sync)                                       |
| **Password stored in cloud?**            | Yes (hashed, salted, encrypted)                              | No (password never leaves the local network)                   | No                                                            |
| **Supports modern auth (MFA, SSO)**      | Yes                                                          | Yes                                                            | Yes                                                           |
| **Supports Smart Cards / 3rd-party MFA** | Limited                                                      | Limited                                                        | Yes (via AD FS customization)                                 |
| **Resiliency if on-prem is down**        | Yes – cloud handles authentication                           | No – sign-in fails if all PTA agents are offline               | No – sign-in fails if AD FS or WAP is unavailable             |
| **MFA method**                           | Entra Conditional Access + Microsoft Authenticator             | Entra Conditional Access + Microsoft Authenticator               | AD FS (on-prem) or Conditional Access                            |
| **Best use case**                        | Simple cloud-first hybrid identity                             | Hybrid with real-time password validation but no hash sync       | Organizations needing on-prem control / 3rd-party MFA            |
| **Complexity / maintenance**             | Low                                                          | Moderate (manage agents)                                       | High (certs, proxies, HA)                                     |

  **Source**: Information based on Microsoft Learn documentation:  
> [Authentication options for hybrid identity solutions](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/choose-ad-authn)


9. Enter username for **Connect to Microsoft Entra ID**.

10. Enter the **Forest**, and get the system to create a new AD account with required permissions for periodic sychronization.  

    ![image](https://github.com/user-attachments/assets/c607a3e9-5e6f-45c7-a67e-96d159a114f6)

    ![image](https://github.com/user-attachments/assets/4e052734-a310-490a-8342-d1dff7206723)

    ![image](https://github.com/user-attachments/assets/51483c64-16ea-464c-9fbb-f7b11e5f4abb)

11. Confirm the default **userPrincipalName** setting and click **Next**.  

    ![image](https://github.com/user-attachments/assets/81790218-0e50-4120-879b-5c1875896281)

12. Specify **Domain and OU Filtering**.  
    For now, I selected the Entra Sync OU in the on-premise AD.
    
    ![image](https://github.com/user-attachments/assets/45d8112e-6e8c-4795-9b13-b7c9aec7345a)

14. Accept default settings for identifying users.  

    ![image](https://github.com/user-attachments/assets/2495b7d2-b33c-4b69-a773-7f8e4f12ca65)

15. Accept the default setting for synchronizing all users.  

    ![image](https://github.com/user-attachments/assets/05292185-7cdb-4e34-99e6-be4631b204a4)

16. Accept **Password hash synchronization**.  Add **Password writeback** and **Group writeback**.  
    **Password writeback** allows users to reset the passwords in Entra ID, and then those passwords are written back to on-premise AD.  
    **Group writeback** allows groups from Entra ID (espectially Microsoft 365 groups) to be synchronized to on-premise AD. The groups will appear as universal distribution groups in AD.  P1 or P2 license is required (the lab environment uses P1 license currently).

    ![image](https://github.com/user-attachments/assets/cb2c7e6a-d19d-406e-8b7f-bc50bfe91f17)

17. Specify **Group writeback** destination in on-premise AD. This step is a simulation if the lab AD had an Exchange scheme.  

     ![image](https://github.com/user-attachments/assets/1c841f5d-e2b4-469b-a7aa-a062ba358cf4)

18. Enable Single Sign-on.  

     ![image](https://github.com/user-attachments/assets/9add61b3-5ea7-4679-9b5a-0ae12cf62931)

19. Confirm and click **Install**.  

     ![image](https://github.com/user-attachments/assets/07599690-0108-42e7-977d-7c989c5022b0)

20. The **Configuration complete** will indicate completion.  
    **NOTE:** The Active Directory Recycle Bin was enabled after Entra Connect configuration.

    ![image](https://github.com/user-attachments/assets/f6241b7e-e55f-46b1-bcea-54e6daa1e62f)

## 2. Entra Connect Synchronization

1. Here is what Entra Connect looks like after it is connected to Active Directory (running on a VMWare machine in my home lab).  
   **Key settings**:  
   Last sync: Less than 1 hour ago  
   Password Hash Synch: Eanbled  
   Seemless single sign-on: Enabled 1 domains  
   

    ![image](https://github.com/user-attachments/assets/ab179ce0-4b0f-43b6-b155-481e6991ac93)

2. Sync status

     ![image](https://github.com/user-attachments/assets/8ac94978-15db-42e8-9c26-6ef2ce2d51db)

3. Check accounts that were synchronized from on-premise AD to Entra.  
   **Test Users**  

     ![image](https://github.com/user-attachments/assets/0c7afb94-96da-4ed5-86ce-ea493fd724fd)

     ![image](https://github.com/user-attachments/assets/74d909ac-6367-44e9-b35a-1388080f271b)

   **Test Groups**  
     ![image](https://github.com/user-attachments/assets/e333d0ee-5606-4e05-b3fa-45119309cc35)

     ![image](https://github.com/user-attachments/assets/348b293e-48de-44e7-a685-3c0733c11c97)


**NOTES**  
Manual synchronization can be initiated as shown below.

```
# Start a delta (incremental) sync:
Start-ADSyncSyncCycle -PolicyType Delta

#Start a full (initial) sync:
Start-ADSyncSyncCycle -PolicyType Initial

#Check sync scheduler status:
Get-ADSyncScheduler
```
