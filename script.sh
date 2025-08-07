#!/usr/bin/env bash

read -p "Enter Domain Name: " name

regex='^[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])*(\.[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])*)+$'

if [[  $name =~ $regex ]]; then

	ip=$(nslookup -type=A "$name" 2>/dev/null \
      | awk '
          /^Name:/      { in_answers = 1; next }
          in_answers && /^Address: / { print $2 }
        '
  )
	echo -e "Blocking ip: $ip\n"

	iptables -A INPUT -s "$ip" -j DROP
	iptables -A OUTPUT -d "$ip" -j DROP
	echo 'Successful...'
	exit 0 
else
	echo $'Invalid Domain\nExiting...'
	exit 1
fi
