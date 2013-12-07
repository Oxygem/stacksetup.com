$title=IP Tables Tricks

One of the more negative sides to VM hosting is the potential for abuse (bad client, hacked, rooted, etc). We can use IPTables on the host node to enforce network-based limits on VM's within that node.

OpenVZ traffic flows through the FORWARD table (in both directions) before hitting INPUT or OUTPUT.

COMING SOON.