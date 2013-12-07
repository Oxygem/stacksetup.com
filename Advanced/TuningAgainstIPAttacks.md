$title=Tuning your server to deal with IP-based attacks

- coming soon.

Notes/bits from sysctl.conf

    #Syn
    net.ipv4.tcp_syncookies = 1
    net.ipv4.tcp_synack_retries = 2
    net.ipv4.tcp_max_syn_backlog = 2048
    net.ipv4.netfilter.ip_conntrack_tcp_timeout_syn_recv = 3
    net.ipv4.netfilter.ip_conntrack_tcp_timeout_syn_sent = 10


    #conntracking
    #net.ipv4.ip_conntrack_max = 262144
    net.ipv4.ip_conntrack_max = 750000
    net.nf_conntrack_max = 750000

    net.ipv4.tcp_mem = 786432 1048576 1572864