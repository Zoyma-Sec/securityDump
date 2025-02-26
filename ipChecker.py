import requests
import re
import time
from colorama import Back, init

init(autoreset=True)

API_KEY = input("Introduce your API KEY: ")
logFile = input("Introduce your log file: ")

ipv4_regex = re.compile(r"^\d{1,3}(\.\d{1,3}){3}$")
ipv6_regex = re.compile(r"^[a-fA-F0-9:]+$")

def isPublblicIp(ip):
    privateRanges = [
        re.compile(r"^10\..*"),
        re.compile(r"^192\.168\..*"),
        re.compile(r"^172\.(1[6-9]|2[0-9]|3[0-1])\..*"),
        re.compile(r"^0\.0\.0\.0"),
        re.compile(r"^127\..*"),
        re.compile(r"^::1$"),  
        re.compile(r"^::$"),   
    ]
    
    return (ipv4_regex.match(ip) or ipv6_regex.match(ip)) and not any(r.match(ip) for r in privateRanges)


with open(logFile, "r") as file:
    lineas = file.readlines()

publicIps = list(set(line.split(": ")[1].strip() for line in lineas if "RemoteAddress" in line))
publicIps = list(filter(isPublblicIp, publicIps))  

for ip in publicIps:
    url = f"https://www.virustotal.com/api/v3/ip_addresses/{ip}"
    headers = {
        "accept": "application/json",
        "x-apikey": API_KEY
    }

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        stats = data.get("data", {}).get("attributes", {}).get("last_analysis_stats", {})

        if stats.get("malicious", 0) > 0 or stats.get("suspicious", 0) > 0:
            print(Back.RED + f"Results for {ip}: {stats}" + Back.RESET)
        else:
            print(f"Results for {ip}: {stats}")
    
    elif response.status_code == 429:
        print(Back.YELLOW + f"Error con {ip}: Max API tryouts per day..." + Back.RESET)

    else:
        print(f"Error {ip}: {response.status_code} - {response.text}")
