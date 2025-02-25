$hostname = $env:COMPUTERNAME

$logFile = "$(Get-Location)\SecurityScan_${hostname}_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

Start-Transcript -Path $logFile -Force

Write-Host "`n### Enabled local users ###`n"
Get-LocalUser | Where-Object { $_.Enabled -eq $true } | Select-Object Name, PrincipalSource

Write-Host "`n### Active Network Connections ###`n"
Get-NetTCPConnection | Where-Object { $_.State -eq "Established" -or $_.RemoteAddress -notmatch "^(127\.0\.0\.1|::1)$" } |
Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State

Write-Host "`n### ARP table ###`n"
arp -a

Write-Host "`n### Processes in Execution ###`n"
Get-Process | Select-Object ProcessName, Id, Path

Write-Host "`n### Detailed List of Processes ###`n"
tasklist /v

Write-Host "`n### Recently Modified Files ###`n"
Get-ChildItem -Path "C:\Users" -Recurse -ErrorAction SilentlyContinue |
Where-Object { 
    $_.LastWriteTime -gt (Get-Date).AddMinutes(-60) -and 
    $_.Extension -notmatch "(\.log|\.evtx|\.etl|\.txt)$" 
} | Select-Object FullName, LastWriteTime

Write-Host "`n### Variations of the path (Registry) ###`n"
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" |
Select-Object -Property *

Write-Host "`n### Services in Automatic Execution ###`n"
Get-Service | Where-Object { $_.StartType -eq "Auto" -and $_.Status -eq "Running" } |
Select-Object Name, DisplayName, StartType

Write-Host "`n### Active Scheduled Tasks ###`n"
Get-ScheduledTask | Where-Object { $_.State -eq "Ready" } |
Select-Object TaskPath, TaskName

Write-Host "`n### Analysis completed. Results saved in $logFile ###`n"
Stop-Transcript
