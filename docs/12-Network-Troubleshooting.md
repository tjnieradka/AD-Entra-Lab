# Network Connectivity Troubleshooting

The following commands were used in troubleshooting network connectivity during lab setup.  **This section is work-in-progress.**

## Checking if network traffic from a source server is reaching an interface on the VyOS router.

   The tcpdump command was used to verify whether traffic from a source server was reaching a specific interface on the VyOS router and successfully passing through to the Internet.
   This helped identify if firewall rules were misconfigured or blocking traffic.
   
1. On the VyOS router, start the following command
   ```
   sudo tcpdump -i eth0  -v      #where eth0 refers to the WAN interface in the lab and optional v = verbose output  
   ```
   <img width="736" height="218" alt="image" src="https://github.com/user-attachments/assets/24ef612c-acf6-4734-a5b1-d00c15cf36bb" />

   `tcpdump` captures and displays packets on a network interface in real-time. It is commonly used in Linux systems (e.g., Debian, Ubuntu) for basic troubleshooting and packet inspection.
   It usually requires root privileges. If not installed, install it using `sudo apt install tcpdump`. Output can be redirected to a file using `>` or `tee` for later analysis.

   On Windows, TShark (the CLI version of Wireshark) provides similar functionality.
  
3. On the source server, start pings or leave "as is" if traffic is already generated.


## Testing connectivity in Windows

While configuring various network topologies, the following Windows commands were used to verify connectivity—especially important given the custom firewall rules in VyOS.

1. In Windows CLI, `ping` could be used as long as the (target) firewall settings have been modified to allow ICMP traffic.  Many Windows hosts block ICMP Echo Requests by default on public networks unless explicitly allowed.
2. In Powershell, `Test-Connection` or `Test-NetConnection` can also be used. `Test-Connection` uses ICMP, like `ping`, while `Test-NetConnection` can test specific TCP ports.

   <img width="950" height="577" alt="image" src="https://github.com/user-attachments/assets/ba95bdfa-c7a2-4557-82b8-2379c334d414" />

## Testing connectivity in Linux (Ubuntu)

TBA

## Checking hostname resolution

1. Run 'nslookup' either in Windows or Linux.  `nslookup` queries a DNS server to resolve a domain name to an IP address.

    <img width="595" height="226" alt="image" src="https://github.com/user-attachments/assets/eb29b7a2-13fd-4b46-8339-200416937781" />

2. On Linux (Ubuntu), run `systemd-resolve --status` to verify DNS resolution. This shows the current DNS configuration per interface.
   It helps verify which DNS servers are being used and whether resolution settings are correct. On newer systems, the command may be `resolvectl status`.
