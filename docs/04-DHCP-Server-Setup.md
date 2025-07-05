⚠️ This lab is for demonstration only; not for production.

# 04. DHCP Server Setup

1. Select **Complete DHCP configuration**.  

   ![image](https://github.com/user-attachments/assets/354e3bc9-9f2b-4ea0-b6ff-d49505ba25bc)

2. On the **DHCP Post-Install configuration wizard > Description**, click **Next**.

3. For this lab, the Domain Administrator account is used on the **Authorization** screen.

   ![image](https://github.com/user-attachments/assets/758f9014-4cfb-4f0f-a536-9da3a359b610)

4. At the **Summary** screen, click to complete the initial setup.

5. In Tools, open **DHCP**.

6. Right-click on **IPv4**, and select **New Scope**.

   ![image](https://github.com/user-attachments/assets/ea9a39c3-7ad1-41cc-adf0-d11b81b412e8)

7. In the Wizard, enter "LAN Scope" for the **Scope Name**.

8. Enter the range of IP addresses that will be leased to client devices.

   ![image](https://github.com/user-attachments/assets/060c207c-1ea8-4e27-a310-facc167164cc)

9. Add **Exclusions**, if some IP addresses need to be reserved.

    ![image](https://github.com/user-attachments/assets/6d744044-996d-484c-8e2c-2f93ec05f8ae)

10. Update or confirm lease selection.  The default 8 days was selected.

    ![image](https://github.com/user-attachments/assets/0ceda589-2382-4ee8-82f7-e77f9e004a54)

11. Configure **DHCP Options**.

    ![image](https://github.com/user-attachments/assets/d6cf0532-d90a-4ef7-ac9f-311e382bcf85)

12. For the **Router (Default Gateway)**, the IP address of the LAN interface of the VYos Router was entered: 192.168.10.1.

    ![image](https://github.com/user-attachments/assets/94c1bc82-2cf5-4a9f-88e1-5705086f4b43)

13. DNS and Domain were also specified.

    ![image](https://github.com/user-attachments/assets/083f37ea-992d-4c12-807e-257f9c6b29b5)

**NOTE**: At the time of setup, only 192.168.10.10 was added as the DNS server.  As this lab set up was completed, external IP addresses were also added to DNS settings:  
  
**1.1.1.1** – A public DNS server provided by Cloudflare.  
**8.8.8.8** – A public DNS server operated by Google.   

15. Click to continue at the WINS settings screen.

16. Activate the DHCP scope.

17. Check that the **DHCP Server** Service is running.

     ![image](https://github.com/user-attachments/assets/147cfd1e-020d-4ec1-8bf5-3d81fe17fc81)

18. Test on clients. Note that the IP address is based on the configured scope.

# DHCP Clients

## Windows 11 

The IP address obtained is from the DHCP server.  The settings show 192.168.10.1 as the **Default Gateway** and 192.168.10.10 as the **DNS Server** which is also the AD Domain Controller in this lab. 

```
ipconfig -release
ipconfig -renew
```

  ![image](https://github.com/user-attachments/assets/bdd3337a-bcf4-4422-87d7-3e5f1e9c7c5e)



## Ubuntu 20.04 Desktop

The IP address obtained is from the DHCP server as shown by the results on the ens33 interface.  

```
sudo dhclient -r
sudo dhclient ens33 
ip -brief address 
ip a 
```
 

   ![image](https://github.com/user-attachments/assets/e069d8de-8f22-4f2a-a760-a3688740553c)



