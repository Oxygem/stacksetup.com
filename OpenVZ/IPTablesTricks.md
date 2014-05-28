$title=IP Tables Tricks

One of the more negative sides to VM hosting is the potential for abuse (bad client, hacked, rooted, etc). We can use IPTables on the host node to enforce network-based limits on VM's within that node.

OpenVZ traffic flows through the FORWARD chain (in both directions) before hitting INPUT or after hitting OUTPUT in the container.

Useful examples:

	# Limit outgoing mail to 50/hour, log + drop others. Does not cause loss of mail (mailserver will queue/spool and retry); but will prevent spammers causing too much trouble
	iptables -A FORWARD -p tcp --sport 25 --syn -m hashlimit --hashlimit-mode srcip --hashlimit-limit 50/hour --hashlimit-burst 50 -j ACCEPT
	iptables -A FORWARD -p tcp --sport 25 --syn -j LOG
	iptables -A FORWARD -p tcp --sport 25 --syn -j DROP
	
# Todo - more rules