```markdown

| Command                                                  | Purpose                                               | Where to Run             | When to Use                            | Notes                                 |
| -------------------------------------------------------- | ----------------------------------------------------- | ------------------------ | -------------------------------------- | ------------------------------------- |
| `nltest /dsgetdc:TNTECHDEMO01.com`                       | Finds a Domain Controller, validates DNS/DC discovery | Client or Server         | Login issues, DC connectivity problems | Verifies SRV records + DNS resolution |
| `nltest /dsgetdc:TNTECHDEMO01.com /force`                | Forces rediscovery of DC (ignores cache)              | Client                   | Suspected stale DC info                | Useful after network or DNS changes   |
| `nltest /sc_verify:TNTECHDEMO01.com`                     | Verifies secure channel (machine trust)               | Client                   | Login failures, trust issues           | `STATUS_SUCCESS` = OK                 |
| `nltest /sc_reset:TNTECHDEMO01.com`                      | Resets secure channel                                 | Client                   | “Trust relationship failed” error      | May require admin rights              |
| `nltest /server:VANDC2-W2022 /sc_query:TNTECHDEMO01.com` | Checks secure channel against specific DC             | Client or Server         | Multi-DC troubleshooting               | Helps isolate DC-specific issues      |
| `nltest /dclist:TNTECHDEMO01.com`                        | Lists all domain controllers                          | Any domain-joined system | Replication awareness, troubleshooting | Useful for topology visibility        |
| `nltest /domain_trusts`                                  | Lists domain trust relationships                      | Any domain-joined system | Trust troubleshooting                  | Less common but good knowledge        |
