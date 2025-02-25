$hostname = $env:COMPUTERNAME  # Alternativa: (Get-ComputerInfo).CsName

$logFile = "$(Get-Location)\SecurityScan_${hostname}_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

Start-Transcript -Path $logFile -Force

Write-Host "`n### Usuarios Locales Habilitados ###`n"
Get-LocalUser | Where-Object { $_.Enabled -eq $true } | Select-Object Name, PrincipalSource

Write-Host "`n### Conexiones de Red Activas ###`n"
Get-NetTCPConnection | Where-Object { $_.State -eq "Established" -or $_.RemoteAddress -notmatch "^(127\.0\.0\.1|::1)$" } |
Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State

Write-Host "`n### Tabla ARP ###`n"
arp -a

Write-Host "`n### Procesos en Ejecucion ###`n"
Get-Process | Select-Object ProcessName, Id, Path

Write-Host "`n### Lista Detallada de Procesos ###`n"
tasklist /v

Write-Host "`n### Archivos Modificados Recientemente ###`n"
Get-ChildItem -Path "C:\Users" -Recurse -ErrorAction SilentlyContinue |
Where-Object { 
    $_.LastWriteTime -gt (Get-Date).AddMinutes(-30) -and 
    $_.Extension -notmatch "(\.log|\.evtx|\.etl|\.txt)$" 
} | Select-Object FullName, LastWriteTime

Write-Host "`n### Variaciones del path (Registro) ###`n"
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" |
Select-Object -Property *

Write-Host "`n### Servicios en Ejecucion Automatica ###`n"
Get-Service | Where-Object { $_.StartType -eq "Auto" -and $_.Status -eq "Running" } |
Select-Object Name, DisplayName, StartType

Write-Host "`n### Tareas Programadas Activas ###`n"
Get-ScheduledTask | Where-Object { $_.State -eq "Ready" } |
Select-Object TaskPath, TaskName

Write-Host "`n### Análisis completado. Resultados guardados en $logFile ###`n"
Stop-Transcript
