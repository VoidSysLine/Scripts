# ===========================================
# Get-NetworkConnections_Stable.ps1
# Liest alle TCP/UDP-Verbindungen mit Prozessnamen aus
# und speichert sie als Textdatei auf dem Desktop.
# ===========================================

$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$OutputFile = "$env:USERPROFILE\Desktop\Netzwerkverbindungen_$Date.txt"

Write-Host "Starte Netzwerkscan..." -ForegroundColor Cyan

# Funktion, um Ports bekannten Diensten zuzuordnen
$CommonPorts = @{
    20  = "FTP Data"; 21 = "FTP Control"; 22 = "SSH"; 23 = "Telnet"; 25 = "SMTP"
    53  = "DNS"; 80 = "HTTP"; 110 = "POP3"; 143 = "IMAP"; 443 = "HTTPS"
    445 = "SMB"; 3389 = "RDP"; 5900 = "VNC"; 8080 = "HTTP-Alt"
}
function Get-PortDescription($Port) {
    if ($CommonPorts.ContainsKey($Port)) { return $CommonPorts[$Port] }
    else { return "" }
}

# ------------------------
# TCP-Verbindungen
# ------------------------
try {
    $tcp = Get-NetTCPConnection -ErrorAction Stop | ForEach-Object {
        [PSCustomObject]@{
            Protocol      = "TCP"
            LocalAddress  = $_.LocalAddress
            LocalPort     = $_.LocalPort
            RemoteAddress = if ($_.RemoteAddress -eq "0.0.0.0") {"-"} else { $_.RemoteAddress }
            RemotePort    = if ($_.RemotePort -eq 0) {"-"} else { $_.RemotePort }
            State         = $_.State
            PID           = $_.OwningProcess
            ProcessName   = (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName
            Description   = Get-PortDescription($_.LocalPort)
        }
    }
}
catch {
    Write-Warning "Get-NetTCPConnection nicht verfügbar. Fallback zu netstat..."
    $tcp = netstat -ano | Select-String "TCP" | ForEach-Object {
        $parts = $_ -split "\s+"
        [PSCustomObject]@{
            Protocol      = $parts[1]
            LocalAddress  = ($parts[2] -split ":")[0]
            LocalPort     = ($parts[2] -split ":")[1]
            RemoteAddress = ($parts[3] -split ":")[0]
            RemotePort    = ($parts[3] -split ":")[1]
            State         = $parts[4]
            PID           = $parts[5]
            ProcessName   = (Get-Process -Id $parts[5] -ErrorAction SilentlyContinue).ProcessName
            Description   = Get-PortDescription(($parts[2] -split ":")[1])
        }
    }
}

# ------------------------
# UDP-Verbindungen
# ------------------------
try {
    $udp = Get-NetUDPEndpoint -ErrorAction Stop | ForEach-Object {
        [PSCustomObject]@{
            Protocol      = "UDP"
            LocalAddress  = $_.LocalAddress
            LocalPort     = $_.LocalPort
            RemoteAddress = "-"
            RemotePort    = "-"
            State         = "-"
            PID           = $_.OwningProcess
            ProcessName   = (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName
            Description   = Get-PortDescription($_.LocalPort)
        }
    }
}
catch {
    Write-Warning "Get-NetUDPEndpoint nicht verfügbar. Fallback zu netstat..."
    $udp = netstat -ano | Select-String "UDP" | ForEach-Object {
        $parts = $_ -split "\s+"
        [PSCustomObject]@{
            Protocol      = $parts[1]
            LocalAddress  = ($parts[2] -split ":")[0]
            LocalPort     = ($parts[2] -split ":")[1]
            RemoteAddress = "-"
            RemotePort    = "-"
            State         = "-"
            PID           = $parts[-1]
            ProcessName   = (Get-Process -Id $parts[-1] -ErrorAction SilentlyContinue).ProcessName
            Description   = Get-PortDescription(($parts[2] -split ":")[1])
        }
    }
}

# ------------------------
# Ausgabe zusammenfassen
# ------------------------
$all = $tcp + $udp | Sort-Object ProcessName, LocalPort

"Netzwerkverbindungen - $(Get-Date)" | Out-File $OutputFile
"======================================" | Out-File -Append $OutputFile
$all | Format-Table -AutoSize | Out-String | Out-File -Append $OutputFile

"`nZusammenfassung nach Prozessen:" | Out-File -Append $OutputFile
"--------------------------------" | Out-File -Append $OutputFile
$all | Group-Object ProcessName | Sort-Object Count -Descending |
    ForEach-Object { "{0,-25} {1,5}" -f $_.Name, $_.Count } | Out-File -Append $OutputFile

Write-Host "`n✅ Fertig. Datei gespeichert unter:`n$OutputFile" -ForegroundColor Green
