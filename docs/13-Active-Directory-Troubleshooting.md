# Active Directory Troubleshooting

This reference summarizes commonly used Active Directory troubleshooting tools and commands based on hands-on lab work and real-world scenarios, including hybrid identity environments.

## AD Troubleshooting Summary

| Problem Type      | Tool to Use            | Why                   |
| ----------------- | ---------------------- | --------------------- |
| Login issue       | `nltest`, ADUC         | Validate DC + account |
| GPO issue         | `gpupdate`, `gpresult` | Apply + verify        |
| Replication issue | `repadmin`             | Check DC sync         |
| DC health         | `dcdiag`               | Validate services/DNS |
| Hybrid issue      | `dsregcmd`, miisclient | Check sync + join     |
| Deep issue        | Event Viewer           | Root cause analysis   |

## AD Troubleshooting Flow Summary

1. Identity issue?
   → Check ADUC (account status)
2. Login issue?
   → `nltest /dsgetdc`
   → `nltest /sc_verify`
3. GPO issue?
   → `gpupdate /force`
   → `gpresult /r`
4. Replication issue?
   → `repadmin /replsummary`
5. Hybrid issue?
   → `dsregcmd /status`
   → Check sync (miisclient)
6. Still unclear?
   → Event Viewer


# Tools

## 1. `nltest` – Domain & Trust Diagnostics

| Command                                                  | Purpose                                               | Where to Run             | When to Use                            | Notes                                 |
| -------------------------------------------------------- | ----------------------------------------------------- | ------------------------ | -------------------------------------- | ------------------------------------- |
| `nltest /dsgetdc:TNTECHDEMO01.com`                       | Finds a Domain Controller, validates DNS/DC discovery | Client or Server         | Login issues, DC connectivity problems | Verifies SRV records + DNS resolution |
| `nltest /dsgetdc:TNTECHDEMO01.com /force`                | Forces rediscovery of DC (ignores cache)              | Client                   | Suspected stale DC info                | Useful after network or DNS changes   |
| `nltest /sc_verify:TNTECHDEMO01.com`                     | Verifies secure channel (machine trust)               | Client                   | Login failures, trust issues           | `STATUS_SUCCESS` = OK                 |
| `nltest /sc_reset:TNTECHDEMO01.com`                      | Resets secure channel                                 | Client                   | “Trust relationship failed” error      | May require admin rights              |
| `nltest /server:VANDC2-W2022 /sc_query:TNTECHDEMO01.com` | Checks secure channel against specific DC             | Client or Server         | Multi-DC troubleshooting               | Helps isolate DC-specific issues      |
| `nltest /dclist:TNTECHDEMO01.com`                        | Lists all domain controllers                          | Any domain-joined system | Replication awareness, troubleshooting | Useful for topology visibility        |
| `nltest /domain_trusts`                                  | Lists domain trust relationships                      | Any domain-joined system | Trust troubleshooting                  | Less common but good knowledge        |

## 2. `repadmin` – Replication Health

| Command                  | Purpose                           | Where to Run      | When to Use                        | Notes                              |
| ------------------------ | --------------------------------- | ----------------- | ---------------------------------- | ---------------------------------- |
| `repadmin /replsummary`  | Summary of replication health     | Domain Controller | Suspected replication issues       | Quick overview (failures, latency) |
| `repadmin /showrepl`     | Detailed replication status       | Domain Controller | Investigating replication failures | Shows partners + error codes       |
| `repadmin /syncall /AeD` | Forces replication across all DCs | Domain Controller | After changes, troubleshooting     | Use cautiously in production       |
| `repadmin /queue`        | Shows pending replication         | Domain Controller | Delays or backlog suspected        | Helps identify stuck replication   |

## 3. `dcdiag` – Domain Controller Health

| Command                  | Purpose                        | Where to Run            | When to Use              | Notes                           |
| ------------------------ | ------------------------------ | ----------------------- | ------------------------ | ------------------------------- |
| `dcdiag /v`              | Full diagnostic test (verbose) | Domain Controller       | General health check     | Default go-to                   |
| `dcdiag /q`              | Shows only errors              | Domain Controller       | Quick validation         | Cleaner output                  |
| `dcdiag /test:dns`       | DNS health check               | Domain Controller       | Login/GPO issues         | **Very common root cause**      |
| `dcdiag /s:VANDC1-W2022` | Test specific DC               | Any system (with tools) | Targeted troubleshooting | Useful in multi-DC environments |

## 4. `gpresult` – Validate Group Policy

| Command                       | Purpose                 | Where to Run | When to Use          | Notes                        |
| ----------------------------- | ----------------------- | ------------ | -------------------- | ---------------------------- |
| `gpresult /r`                 | Summary of applied GPOs | Client       | GPO not applying     | Most common command          |
| `gpresult /h report.html`     | Detailed HTML report    | Client       | Deep analysis        | Easy to review visually      |
| `gpresult /scope computer /r` | Computer policies only  | Client       | Device config issues | Useful for system-level GPOs |
| `gpresult /scope user /r`     | User policies only      | Client       | User access issues   | Helps isolate scope          |

## 5. `gpupdate` – Refresh Group Policy

| Command                     | Purpose                                        | Where to Run       | When to Use                 | Notes                        |
| --------------------------- | ---------------------------------------------- | ------------------ | --------------------------- | ---------------------------- |
| `gpupdate /force`           | Reapplies all Group Policies (user + computer) | Client (or server) | GPO changes not applying    | Most commonly used           |
| `gpupdate`                  | Applies only changed policies                  | Client             | Routine refresh             | Faster, less disruptive      |
| `gpupdate /target:user`     | Updates user policies only                     | Client             | User-specific issues        | Avoids computer refresh      |
| `gpupdate /target:computer` | Updates computer policies only                 | Client             | Device configuration issues | Useful for system-level GPOs |
| `gpupdate /logoff`          | Forces logoff after update                     | Client             | When GPO requires logoff    | Example: folder redirection  |
| `gpupdate /boot`            | Forces reboot after update                     | Client             | When GPO requires restart   | Example: software install    |
| `gpupdate /wait:0`          | Runs without waiting for completion            | Client             | Scripts/automation          | Default wait is ~600 sec     |


## 6. `dsregcmd` – Hybrid / Entra Join Status

| Command            | Purpose                                 | Where to Run | When to Use            | Notes                  |
| ------------------ | --------------------------------------- | ------------ | ---------------------- | ---------------------- |
| `dsregcmd /status` | Shows join status (AD / Entra / Hybrid) | Client       | Hybrid troubleshooting | **Key command**        |
| `dsregcmd /join`   | Forces Entra join                       | Client       | Device not registering | Requires proper config |
| `dsregcmd /leave`  | Removes Entra join                      | Client       | Reset/rejoin scenarios | Use carefully          |

## 7. Entra Connect / Hybrid Sync



| Tool / PowerShell Command                                     | Purpose                                  | Where to Use         | When to Use        | Notes                        |
| -------------------------------------------------- | ---------------------------------------- | -------------------- | ------------------ | ---------------------------- |
| Synchronization Service Manager (`miisclient.exe`) | View sync operations, errors, connectors | Entra Connect Server | User not syncing   | Check Operations + Metaverse |
| `Start-ADSyncSyncCycle -PolicyType Delta`          | Trigger sync                             | Entra Connect Server | Sync delays        | Most common manual trigger   |
| `Get-ADSyncScheduler`                              | View sync schedule                       | Entra Connect Server | Verify sync timing | Confirms automation          |
| `Restart-Service ADSync`                              | Restart sync service                     | Entra Connect Server | Restart sync | Try in case of sync failures    |



## 8. Entra Connect Synchronization (miisclient)

This screenshot demonstrates successful Azure AD (Entra ID) synchronization cycles in a hybrid identity lab environment.

- **Delta Import**: Imports changes from on-prem AD
- **Delta Synchronization**: Processes changes in the metaverse
- **Export**: Sends updates to Entra ID

I used this tool to verify synchronization status and troubleshoot issues such as missing users or delayed updates.

<img width="789" height="622" alt="image" src="https://github.com/user-attachments/assets/8b47648c-515f-4571-a3dd-0bbb8235d9fc" />

## 9. Active Directory Database Deep Diagnostics

| Tool / Command                       | Purpose                   | Where to Run                | When to Use                    | Notes                     |
| ------------------------------------ | ------------------------- | --------------------------- | ------------------------------ | ------------------------- |
| `ntdsutil` (integrity)               | Check DB integrity        | Domain Controller (offline) | Suspected DB corruption        | Requires maintenance mode |
| `ntdsutil` (semantic analysis)       | Logical consistency check | Domain Controller           | Advanced troubleshooting       | Rare but useful           |
| Event Viewer (Directory Service log) | View AD errors            | Domain Controller           | Most troubleshooting scenarios | **First place to check**  |

# SCENARIOS

## 1. User Login Issues

| Issue                       | Likely Cause            | What to Check                   | Tools/Commands                   | Notes               |
| --------------------------- | ----------------------- | ------------------------------- | -------------------------------- | ------------------- |
| User cannot log in          | Account locked/disabled | ADUC account status             | ADUC, Event Viewer               | Most common issue   |
| “Trust relationship failed” | Broken machine trust    | Secure channel                  | `nltest /sc_verify`, `/sc_reset` | Often after imaging |
| Slow login                  | DC/DNS issues           | DNS resolution, DC reachability | `nltest /dsgetdc`, `ping`        | DNS is key          |
| Login works on one PC only  | Profile or local issue  | Local vs domain problem         | Event Viewer                     | Helps isolate scope |

## 2. Group Policy Issues

| Issue                      | Likely Cause       | What to Check    | Tools/Commands          | Notes             |
| -------------------------- | ------------------ | ---------------- | ----------------------- | ----------------- |
| GPO not applying           | Wrong OU           | Object location  | ADUC                    | Basic but common  |
| GPO not applying           | Security filtering | Group membership | `gpresult /r`           | Often missed      |
| GPO delayed                | Replication issue  | DC sync status   | `repadmin /replsummary` | Multi-DC issue    |
| GPO requires reboot/logoff | Policy requirement | Policy type      | `gpupdate /force /boot` | Expected behavior |

## 3. Replication Issues

| Issue                            | Likely Cause        | What to Check      | Tools/Commands          | Notes          |
| -------------------------------- | ------------------- | ------------------ | ----------------------- | -------------- |
| Changes not visible on other DCs | Replication failure | Replication health | `repadmin /replsummary` | First check    |
| Inconsistent AD data             | Replication latency | DC sync            | `repadmin /showrepl`    | Check partners |
| Replication backlog              | Network/DNS issue   | Queue              | `repadmin /queue`       | Delayed sync   |

## 4. DNS / Connectivity Issues

| Issue                   | Likely Cause         | What to Check       | Tools/Commands    | Notes                    |
| ----------------------- | -------------------- | ------------------- | ----------------- | ------------------------ |
| Cannot log in to domain | DNS misconfigured    | DNS server settings | `ipconfig /all`   | Client should use DC DNS |
| DC not found            | SRV records missing  | DNS records         | `nltest /dsgetdc` | Critical                 |
| Intermittent issues     | Multiple DNS servers | DNS order           | `nslookup`        | Common misconfig         |

## 5. Hybrid / Entra ID Issues

| Issue                             | Likely Cause             | What to Check      | Tools/Commands                      | Notes                |
| --------------------------------- | ------------------------ | ------------------ | ----------------------------------- | -------------------- |
| User not in Entra ID              | Sync issue               | Sync status        | miisclient, `Start-ADSyncSyncCycle` | Very common          |
| Login works on-prem but not cloud | Conditional Access / MFA | Entra sign-in logs | Entra portal                        | Cloud-specific issue |
| Device not hybrid joined          | Registration issue       | Device state       | `dsregcmd /status`                  | Check join type      |
| Sync delays                       | Scheduler issue          | Sync interval      | `Get-ADSyncScheduler`               | Verify timing        |




