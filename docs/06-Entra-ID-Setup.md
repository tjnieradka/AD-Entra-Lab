# 06. Entra ID Setup

## 1. Register Domain

1. Register Domain through a domain name registrar.

   GoDaddy is a widely used domain name registrar that allows users to purchase and manage DNS settings for custom domains. For this lab environment, the domain tntechdemo01.com was registered through GoDaddy will be     configured with the necessary DNS records (TXT, MX, etc.) to verify ownership and enable integration with Microsoft Entra ID (Azure AD) as part of a hybrid Active Directory setup.

## 2. Obtain Azure Active Directory Premium P1 

1. Acquire Azure Active Directory Premium P1 through https://www.microsoft.com/en-ca/security/business/microsoft-entra-pricing

2. Complete initial setup (e.g. MFA)

## 3. Add Custom Domain

1. In the Microsoft Entra Admin Center (https://entra.microsoft.com/), go to Identity > Settings > Domain Names

   ![image](https://github.com/user-attachments/assets/785df1bf-6261-44a8-8ec2-0d300f95185b)

2. Select to Add Custom Domain Name and enter the domain.

3. Copy the settings provided in the Custom domain name (Entra Admin Center) and create a TXT or MX record in the DNS settings.  In this lab a TXT DNS record was added to the domain on the domain name registrar portal (i.e. GoDaddy).

   ![image](https://github.com/user-attachments/assets/50511110-46c9-40d7-b312-7aed0babf235)

4. Verify the domain.

   ![image](https://github.com/user-attachments/assets/c90b88dd-bf44-4352-9781-50c212ad5386)

5. Add tntechdemo01.com UPN to Active Directory Domains and Trusts on VANDC1-W2022
   When test users UPNs will be in this format: user@tntechdemo01.com
   
   ![image](https://github.com/user-attachments/assets/cb8a34bf-4283-4b00-b4de-9c00cdbb8365)

NOTE: At this stage, the custom domain is NOT promoted to Primary in the Entra admin center since additional testing is needed.
