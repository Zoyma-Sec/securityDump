net users

Get-LocalUser | Where-Object { $_.Enabled -eq $true }

Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State

arp -a

Get-Process 

tasklist /v

Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue |
Where-Object { 
    $_.LastWriteTime -gt (Get-Date).AddMinutes(-30) -and 
    $_.Extension -notmatch "(\.log|\.evtx|\.etl|\.txt)$" 
}

Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

Get-Service | Where-Object { $_.StartType -eq "Auto" -and $_.Status -eq "Running" } | Select-Object Name, DisplayName, StartType

Get-ScheduledTask | Where-Object { $_.State -eq "Ready" } | Select-Object TaskPath, TaskName


