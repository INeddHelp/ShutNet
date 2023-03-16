#!/bin/bash

ipAddresses=()

for (( i=1; i<=254; i++ ))
do
  ip="192.168.1.$i"
  echo "Scanning $ip"
  pingResult=$(ping -c 1 -W 1 "$ip" 2>&1)
  if [[ $pingResult =~ "1 received" ]]; then
    ipAddresses+=("$ip")
  fi
done

printf '%s\n' "${ipAddresses[@]}" > Ips.txt

for ip in "${ipAddresses[@]}"
do
  echo "Shutting down $ip"
  pingResult=$(ping -c 1 -W 1 "$ip" 2>&1)
  if [[ $pingResult =~ "1 received" ]]; then
    computerName=$(nslookup "$ip" | grep -oP 'name = \K([^.])..' | awk '{print $1}')
    if [[ -n $computerName ]]; then
      ssh "$computerName" sudo shutdown -h now
    else
      echo "Could not resolve computer name for IP address $ip" >&2
    fi
  else
    echo "Could not connect to IP address $ip" >&2
  fi
done

# sudo ufw allow 22/tcp
