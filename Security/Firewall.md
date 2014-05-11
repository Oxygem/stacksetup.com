$title=Using the IPTables firewall
$description=Useful+common ways of using iptables
$keywords=iptables firewall

Basic Info:

    iptables -F	#Clear ruleset
    iptables -nLv # List all rules (L), without resolving IP addresses to domain names (n) in verbose mode (v)
    iptables -A <chain> [matches] [-j TO-CHAIN] # E.g. iptables -A INPUT -p tcp --dport 80 -j ACCEPT


Hardening SSH:

    # Allow 2 new connections per minute per IP
	iptables -A INPUT -p tcp --dport 22 --syn -m hashlimit --hashlimit-name ssh --hashlimit-limit 2/m --hashlimit-burst 2 -j ACCEPT
	# Drop new connections that are over 2 per minute
	iptables -A INPUT -p tcp --dport 22 --syn -j DROP

	# Note : pseudocode, rules have not been tested. Change 22 to your SSH port.