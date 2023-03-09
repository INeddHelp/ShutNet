$ipAddresses = @()
Get-NetNeighbor -AddressFamily IPv4 | ForEach-Object {
    if ($_.State -eq "Reachable") {
        $ipAddresses += $_.IPAddress
    }
}

Set-Content -Path "Ips.txt" -Value $ipAddresses

Stop-Computer -ComputerName $ipAddresses -Force -Confirm:$false
