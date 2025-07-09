⚠️ This lab is for demonstration only; not for production.

# 06. Entra ID Setup

## 1. Register Domain

1. Register your domain through a domain name registrar.

   GoDaddy is a widely used domain name registrar that allows users to purchase and manage DNS settings for custom domains. For this lab environment, the domain tntechdemo01.com was registered through GoDaddy, and will be     configured with the necessary DNS records (TXT, MX, etc.) to verify ownership and enable integration with Microsoft Entra ID (Azure AD) as part of this lab.

## 2. Obtain Azure Active Directory Premium P1 

1. Acquire Azure Active Directory Premium P1 through https://www.microsoft.com/en-ca/security/business/microsoft-entra-pricing

2. Complete initial setup (e.g. MFA and other settings)

## 3. Add Custom Domain

1. In the **Microsoft Entra admin center** (https://entra.microsoft.com/), go to **Identity > Settings > Domain Names**.

   ![image](https://github.com/user-attachments/assets/23aaefcd-38d7-4630-aa17-1173efa55ed4)

2. Select to **Add Custom Domain Name** and enter the domain.

3. Copy the settings provided (as shown below) in the Custom domain name in the **Microsoft Entra admin center**.
   Log in to the domain name registrar portal (i.e., GoDaddy), and create either a TXT or MX record in the DNS settings.  Enter the settings obtained from Custom domain name in the **Microsoft Entra admin center**. 

   ![image](https://github.com/user-attachments/assets/50511110-46c9-40d7-b312-7aed0babf235)

5. Click to **Verify** the domain on the **Microsoft Entra admin center**.

   ![image](https://github.com/user-attachments/assets/c90b88dd-bf44-4352-9781-50c212ad5386)

6. Normally "tntechdemo01.com" UPN would be added to **Active Directory Domains and Trusts** on the AD Domain Controller VANDC1-W2022.  However, the on-premises AD is already set up as "tntechdemo01.com" so this is probably not necessary.
   When test users UPNs will be in this format: user@tntechdemo01.com
   
   ![image](https://github.com/user-attachments/assets/cb8a34bf-4283-4b00-b4de-9c00cdbb8365)

**NOTE:** At this stage, the custom domain on the **Microsoft Entra admin center** is NOT promoted to Primary in the Entra admin center since additional testing is needed. After testing, tntechdemo01.com could be promoted to be primary.

   ![image](https://github.com/user-attachments/assets/1b48a862-1b63-4204-a02d-9d1196f6b5ac)

