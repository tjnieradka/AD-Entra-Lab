# 05. Test Users Setup in Active Directory

## 1. Enable Active Directory Recycle Bin

1. Enable Recycle Bin for AD on VANDC1-W2022.  This means that deleted objects in AD can be restored without an authoritative restore from backup.
   The deleted objects are kept for 180 days.  After enabling this feature, we cannot disable it.

   ```
   Enable-ADOptionalFeature -Identity 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target "tntechdemo01.com"
   ```

   ![image](https://github.com/user-attachments/assets/d5a4242e-ae89-48f3-827d-6b555651ed37)

   
2. To view or restore deleted AD objects, we can run Active Directory Administrative Center.

   ```
   dsac.exe
   ``` 

   ![image](https://github.com/user-attachments/assets/d1329a82-73b5-41e0-bf02-56db38eb3602)

##  2. Create Entra Sync OU Structure


1. Create "Entra Sync" OU that will be used to synchronize accounts with Entra.

   ![image](https://github.com/user-attachments/assets/3bb022e7-a997-475a-901d-bd4169a225bb)

2. For the initial setup, we'll create test users manually.  Due to limited Entra licenses for this lab, we can create three users for synchronization to Entra.  
   
   **Note:** All user accounts shown in screenshots are fictional and created for lab demonstration purposes only.  

   ![image](https://github.com/user-attachments/assets/9f21bed2-d24f-452e-ac78-d9c1ef40958e)

4. Create test groups.  Global groups will be set up for sync to Entra. 

![image](https://github.com/user-attachments/assets/1a04249c-0a1e-46d5-8a28-388c954ad303)


| Group Scope     | Can Contain Members From | Can Be Used to Assign Permissions In | Replicated To Global Catalog | Typical Use Case                                             | Sync to Entra ID? |
|-----------------|--------------------------|--------------------------------------|-------------------------------|-------------------------------------------------------------|--------------------|
| Domain Local    | Any domain                | Local domain only                    | No                          | Assigning permissions to resources in the local domain      | Not recommended |
| Global          | Same domain               | Any domain                           | Yes                         | Grouping users with similar roles within the same domain    | Yes             |
| Universal       | Any domain                | Any domain                           | Yes                         | Assigning permissions across domains in a forest            | Yes             |

4. We will test different scenarios later in the lab.
