# 10. Test Linux Web Server in DMZ

## 1. Configure Network Settings
```
lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.6 LTS
Release:	20.04
Codename:	focal
```

1. Update hostname in **/etc/hostname** to vansrv-ubuntu

2. Update **/etc/hosts** file. Reboot
  
3. Update network configuration in **/etc/netplan/00-installer-config.yaml** 

  ![image](https://github.com/user-attachments/assets/d00ccf30-4915-4a5c-a2e5-12f546944670)

5. Run the following.
   ```
   netplan generate
   netplan apply
   ```
## 2. Install and Configure Simple Web Server  

1. Update and upgrade

   ```
   sudo apt update
   sudo apt upgrade -y
   ```

2. Install the Web server.

   ```
   sudo apt install apache2 -y
   ```
3. Start the Web server.

   ```
   sudo systemctl enable apache2
   sudo systemctl start apache2
   sudo systemctl status apache2
   ```

   ![image](https://github.com/user-attachments/assets/9cd8b9d6-99ef-484b-8df8-90d4f470463e)

4. Update local firewall.

    ```
    sudo ufw enable
    sudo ufw allow 'Apache'
    sudo ufw reload
    ```
    ![image](https://github.com/user-attachments/assets/087fd941-1504-4b54-a0c7-1fed6cc5e8f2)
   
5. Test Web server from VANCL2-UBUNTU or VANCL1-W11 client (in the LAN).

    ![image](https://github.com/user-attachments/assets/7bfa666d-634f-4ba5-9693-2b0302cd3cb9)
    
6. Update index.html on the Web server.

    ```
    echo "<h1>Welcome to AD-Entra Lab Test Page</h1><p>This is a test web page.</p>" | sudo tee /var/www/html/index.html
    ```

7. Test Web server from VANCL2-UBUNTU or VANCL1-W11 client (in the LAN).

     Ubuntu client
    
     ![image](https://github.com/user-attachments/assets/bac30e74-c8d8-45c1-a9d4-931c97983804)

     Windows client
    
     ![image](https://github.com/user-attachments/assets/91e2550b-3006-47a1-b40f-bc675995eee4)

    


