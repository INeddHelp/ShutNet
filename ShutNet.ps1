$ipAddresses = @()
1..254 | ForEach-Object {
    $ip = "192.168.1.$_"
    if (Test-Connection -ComputerName $ip -Count 1 -ErrorAction SilentlyContinue) {
        $ipAddresses += $ip
    }
}

Set-Content -Path "Ips.txt" -Value $ipAddresses

Param (
    [Parameter(Mandatory=$true)]
    [string[]]$IPAddress
)

foreach ($ip in $IPAddress) {
    if (Test-Connection -ComputerName $ip -Count 1 -ErrorAction SilentlyContinue) {
        $computerName = (Resolve-DnsName -Name $ip -ErrorAction SilentlyContinue).NameHost

        if ($computerName) {
            Stop-Computer -ComputerName $computerName -Force -Confirm:$false
        } else {
            Write-Warning "Could not resolve computer name for IP address $ip"
        }
    } else {
        Write-Warning "Could not connect to IP address $ip"
    }
}
