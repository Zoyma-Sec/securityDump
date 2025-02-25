Write-Host "Starting Analysis, wait a few mintues..." -ForegroundColor Yellow
$hostname = $env:COMPUTERNAME
$logFile = "$(Get-Location)\SecurityScan_${hostname}_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

"### Security Scan Report - $hostname ###`nFecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n" | Out-File -FilePath $logFile -Encoding UTF8

$users = net users
$localUsers = Get-LocalUser | Where-Object { $_.Enabled -eq $true }
$networkConnections = Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State
$arpTable = arp -a
$processes = Get-Process
$tasklist = tasklist /v
$recentFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue |
Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-30) -and $_.Extension -notmatch "(\.log|\.evtx|\.etl|\.txt)$" } |
Select-Object FullName, LastWriteTime
$startupPrograms = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$services = Get-Service | Where-Object { $_.StartType -eq "Auto" -and $_.Status -eq "Running" } | Select-Object Name, DisplayName, StartType
$tasks = Get-ScheduledTask | Where-Object { $_.State -eq "Ready" } | Select-Object TaskPath, TaskName

function Write-Section {
    param ($title, $data)
    if ($data) {
        "`n### $title ###`n" | Out-File -FilePath $logFile -Append -Encoding UTF8
        $data | Out-File -FilePath $logFile -Append -Encoding UTF8
    }
}

Write-Section "System users" $users
Write-Section "Local users enabled" $localUsers
Write-Section "Active network connections" $networkConnections
Write-Section "ARP table" $arpTable
Write-Section "Running processes" $processes
Write-Section "Detailed list of processes" $tasklist
Write-Section "Recently modified files" $recentFiles
Write-Section "Programs on automatic start (Registry)" $startupPrograms
Write-Section "Services running automatically" $services
Write-Section "Active scheduled tasks" $tasks

"`n### Analysis completed. Results saved in $logFile ###`n" | Out-File -FilePath $logFile -Append -Encoding UTF8

Write-Host "Analysis completed. Check the log: $logFile" -ForegroundColor Green
