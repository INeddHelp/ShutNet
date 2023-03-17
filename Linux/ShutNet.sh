#!/bin/bash
ipAddresses=()

for (( i=1; i<=254; i++ )); do
    ip="192.168.1.$i"
    echo "Scanning $ip"
    if ping -c 1 "$ip" &> /dev/null; then
        ipAddresses+=("$ip")
    fi
done

printf '%s\n' "${ipAddresses[@]}" > "Ips.txt"

for ip in "${ipAddresses[@]}"; do
    echo "Shutting down $ip"
    if ping -c 1 "$ip" &> /dev/null; then
        computerName=$(nslookup "$ip" | awk '/name =/{print $NF}' | cut -d '.' -f1)
        if [ -n "$computerName" ]; then
            deviceType=""
            osName=$(ssh "$computerName" "uname -s")
            case $osName in
                Linux*)
                    deviceType="Linux"
                    ssh "$computerName" "sudo shutdown -h now"
                    ;;
                Darwin*)
                    deviceType="Mac"
                    ssh "$computerName" "sudo shutdown -h now"
                    ;;
                *)
                    echo "Unknown operating system for $ip"
                    ;;
            esac
        else
            echo "Could not resolve computer name for IP address $ip"
        fi
    else
        echo "Could not connect to IP address $ip"
    fi
done

> "Ips.txt"


# sudo ufw allow 22/tcp
