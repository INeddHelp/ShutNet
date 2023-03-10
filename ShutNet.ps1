$ipAddresses = @()
for ($i = 1; $i -le 254; $i++) {
    $ip = "192.168.1.$i"
    $pingResult = $(ping -c 1 -W 1 $ip 2>&1)
    if ($pingResult -match "1 received") {
        $ipAddresses += $ip
    }
}

Set-Content -Path "Ips.txt" -Value $ipAddresses

foreach ($ip in $ipAddresses) {
    $pingResult = $(ping -c 1 -W 1 $ip 2>&1)
    if ($pingResult -match "1 received") {
        $computerName = $(nslookup $ip | Select-String "name =" | Out-String).Trim() -replace ".*name = ([^\.]*)\..*", '$1'
        if ($computerName) {
            $(shutdown -s -f -t 0 -m \\$computerName)
        } else {
            Write-Warning "Could not resolve computer name for IP address $ip"
        }
    } else {
        Write-Warning "Could not connect to IP address $ip"
    }
}
