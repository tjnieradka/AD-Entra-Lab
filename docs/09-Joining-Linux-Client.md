
# 09. Joining Linux Client to Active Directory

## 1. Configure Network Settings 

The version of the Linux is the following:
   ```
   lsb_release -a
   No LSB modules are available.
   Distributor ID:	Ubuntu
   Description:	Ubuntu 20.04.6 LTS
   Release:	20.04
   Codename:	focal
   ```

1. Edit /etc/hostname and enter vancl2-ubuntu
2. Edit /etc/hosts and enter vancl2-ubutu
   ```
   127.0.0.1	localhost
   127.0.1.1	vancl2-ubuntu
   ```
3. Reboot 
4. Edit 01-network-manager-all.yaml (after creating a backup copy) in /etc/netplan/
   I am using netword renderer because it seems to work better than the default NetworkManager (which resulted in some issues in my lab). 

```   
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: yes
      dhcp4-overrides:
        use-dns: false
        use-routes: false
      nameservers:
        addresses: [192.168.10.10, 1.1.1.1, 8.8.8.8]
      routes:
        - to: 0.0.0.0/0
          via: 192.168.10.1
```

5. Run
```
sudo netplan generate
sudo netplan apply
```

## 2. Update and Install Packages to Join Active Directory

1. Update
```
sudo apt update
sudo apt upgrade
```
2. Install packages and enter the AD domain name to configure Kerberos.
```
sudo apt install realmd sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit krb5-user -y
```
![image](https://github.com/user-attachments/assets/a23a56d4-f7a3-493b-899f-7b49054a9164)


## 3. Join Active Directory Domain

1. Run
   
```
realm discover tntechdemo01.com
```

2. Join the AD domain
   
```
sudo realm join --user=administrator tntechdemo01.com
```

![image](https://github.com/user-attachments/assets/a18282fe-5ced-4d9c-8b3e-711544cf169a)

3. Verify that the computer account was created in Active Directory.

![image](https://github.com/user-attachments/assets/9ce5b432-9598-476a-b591-d19322c513e7)

4. Enable home directories to be created automatically after logins of Active Directory accounts.

```
sudo pam-auth-update
```

![image](https://github.com/user-attachments/assets/0d91b16f-0e50-4b9d-9de7-f686584fcb02)


5. Test login of an AD account on the Linux client.
    Below screenshot confirms that the Administrator of tntechdemo01.com AD domain was able to log in on the Linux client. Home directory was created for the user.

![image](https://github.com/user-attachments/assets/b0f07e0f-431c-46b8-b5d0-d9d57ea042ad)


