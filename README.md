# securityDump

>[!WARNING]
> This script has been created to perform automatic security checks. It should not be used for malicious actions such as privilege escalation or information gathering.

## Description
This PowerShell script dump detailed information about your PC, including open ports, active services, and network connections. The collected data is then processed by a Python script that compares the connected IP addresses with the VirusTotal database to detect potential threats or intrusions.

All PowerShell queries are native, for a more in-depth analysis, you can complement it with Microsoft's "Sysinternals" tools.
## POC

<h3>Execute the ps1 script to dump your pc information 💻</h3>

<b>Powershell</b>
```
.\securityDump.ps1
```

This will generate a txt file with your:

- System Users
- Local users enabled
- Active network connections
- ARP table
- Running processes
- Detailed list of your processes
- Recently modified files
- Programs on automatic start
- Services running automatically
- Active scheduled tasks

<h3>Compare your network connections with virustotal 🦠</h3>

**Install the necessary python libraries**
```
pip install -r requirements.txt
```
**Execute your python script**
```
python ipChecker.py

  Introduce your API KEY: <Your virustotal API Key (you must have an registered account on virustotal)>
  Introduce your log file: log.txt
```
This will scan the IPs of your active network connections with virustotal, if a malicious or suspicious IP is detected, the output will be underlined in red 😉.


## Zoyma
<p align="center">
  <img src="https://github.com/user-attachments/assets/a629a502-76f3-4749-918f-760da70baf9b" alt="Zoyma icon" width="400"/>
</p>

**Follow me on my social media**

<a href="https://zoyma-sec.github.io/">My website</a>
</br>
<a href="http://beacons.ai/zoyma">Follow me</a>
