$title=Welcome to Afterburst!

Welcome to Afterburst! This guide is intended to give new clients an introduction to the basics of our services, and a few walkthroughs for common uses of our services.

#### Useful Links

VPS Control Panel: <a href=https://vps.afterburst.com>https://vps.afterburst.com</a>

Your username for the VPS control panel will start with vmuser and will be followed by a number (e.g. vmuser000). Your initial password will have been sent to you in the New VPS Information email, please change it immediately after login. 

Client Area: <a href=https://client.afterburst.com>https://client.afterburst.com</a>

Your username and password will be as entered on sign up. You can use this area to submit support tickets, pay invoices and update your information.
	
#### KVM VPS

This section is specifically for KVM. Our KVM services come either pre-installed via a template, or unconfigured with an ISO loaded. You can choose a template by selecting Reinstall in the VPS control panel, or mount an ISO. If you choose to mount an ISO, you'll be able to install your OS by following these steps:


1) Mount the ISO you'd like to install (E.g. CentOS Minimal) to the CD/DVD drive.

2) Reboot your VPS

3) Connect via the VNC applet or HTML5 console and install as you would a normal Linux server. 

4) Configure your network interface. IPv4 uses DHCP and IPv6 uses static allocation (please contact us if you need help). For getting basic IPv4 connectivity up so you can configure over SSH instead of VNC, "ifup eth0" should do the job. 

On our new SSD KVM packages, IPv6 is automatically configured when installing from a template. However, if you are installing from an ISO you will need to configure IPv6 manually. Your /64 is within a larger /48. Unfortunately the /64 isn't routable, so you will need to use the gateway from the /48. You can find the necessary details in the VPS control panel, in the Network Tab - > IPv6 Subnets - > Manage.

#### Getting Started

We highly recommend following a couple of steps once you've logged in to your VPS. 

1) Set up key-based authentication for SSH. You can do this by using a tool such as ssh-keygen (if your PC is Linux/Mac based) or PuTTYGen (Windows). Once you've generated a key pair, you'll need to enter the public key into .ssh/authorized\_keys in the directory of the user you'd like to enable the key for.
	E.g. for root, enter the public key in /root/.ssh/authorized\_keys (this being said - root login isn't recommended)
	Once you've entered the key, configure your SSH client to use the private key. Test the connection using key authentication, and if successful, move to the next step.
	
2) Disable PasswordAuthentication for SSH. You can do this by modifying /etc/sshd/sshd_config and changing "PasswordAuthentication yes" to "PasswordAuthentication no"

Some people at this point may like to change their SSH port. That's entirely personal preference, though it will only really stop automated SSH attackers. If you do want to change your SSH port, please keep it below 1024. This prevents rogue user accounts on your VPS from crashing your SSH daemon and replacing it with a malicious one - as only processes run by privileged users can bind to ports under 1024.

3) Update your system! You'll be able to do this by running "yum update" when running CentOS/RHEL-based operating systems, or "apt-get update && apt-get upgrade" for Debian/Ubuntu based systems.

#### Private Network

We run a global encrypted private network. If you want to take advantage of this, just let us know in a support ticket and we'll assign your VPS's private IP addresses (2 or more VPS required).

The private network allows you to have connectivity between two VPS (e.g. for private/not internet facing services like mysql). To take full advantage of it we recommend that you bind such software specifically to the private IP address. The private network is shared for all customers, so we recommend you take further security steps by blocking private network traffic to your secure services that doesn't come from one of your private IP addresses. 

	iptables -A INPUT -p tcp --dport 3306 -s 192.168.1.xyz -j ACCEPT
	
	iptables -A INPUT -p tcp --dport 3306 -s 192.168.1.zyx -j ACCEPT
	
	iptables -A INPUT -p tcp --dport 3306 -i lo -j ACCEPT # Accept loopback/localhost
	
	iptables -A INPUT -p tcp --dport 3306 -j DROP
	
#### FAQS
	
#####When will my order be activated?

Orders from new customers are processed within 24h of payment. Orders from existing customers are typically processed immediately (depending on stock)
	
#####Can I set up TUN/TAP? 

OpenVZ: Yes - TUN/TAP can be enabled in the VPS control panel. 
KVM: Yes - No action required -- you can configure in the OS as normal. 

#####Can I enable PPTP/PPP? 

OpenVZ: Yes - PPP can be enabled in the VPS control panel.
KVM: Yes - No action required -- you can configure in the OS as normal. 

#####Can I enable FUSE?

OpenVZ: FUSE requires a support ticket. Just let us know.
KVM: Yes - No action required -- you can configure in the OS as normal. 

##### Does Afterburst offer cPanel?

No -- though you can get a VPS cPanel licence from third parties for around $15/m - cheaper than a dedicated server licence - which you can then use on your VPS. 

##### How does SSD caching work?

Recently written or read data is stored on a RAID1 array of SSD's. This is significantly faster than the RAID10 array of hard drives used for storage, which means you get near SSD IO speeds, with HDD capacities. Our SSD caching is a hotspot cache with LRU (least recently used) eviction policy. This means that while you may not see a performance increase in benchmarks (e.g. using dd to check disk speed); there will be a significant performance boost in regular usage. 

#####I'm worried about receiving an abuse report. What should I know?

Most of our customers don't receive abuse reports. However, if you are one of the unlucky ones who do; as long as you respond to us within the given timeframe (depends on what kind of abuse is involved) - you won't have any trouble. You can ask us for an extension to look in to the issue, e.g. if you're away and can't access your VPS. It is important that we receive some communication though. 

##### Backups

We recommend customers keep their own backups of their data. We do not guarantee that we can recover your data in the case of full data loss. In 7 years of the company's operation, we have only had one case of significant data loss where 3 hard drives in the same array failed within 3 days, causing data corruption for the affected customers. We are currently investigating backing up customers data, however even when we have our own backup system in place we recommend you maintain your own backups as we will supply no guarantee on our backups. If your data has value to you, please implement your own off site backup policy where you back up offsite and verify the backups integrity. We may in future bring back backup functionality via the VPS control panel, though this isn't currently on the roadmap. 

##### Are CPU cores dedicated or shared?

Each node's CPU is shared by customers. We monitor our nodes to ensure that in the case a CPU is overloaded, we can take action quickly (e.g. by stopping a runaway process, or moving a particularly CPU intensive customer to a more powerful/less loaded host node). This means there is always plenty of CPU power available to you.

##### Is the 1gbps network connection dedicated or shared.

Each node's network uplink is shared between all customers on the node. For this reason we have a fair usage policy (<a href=http://afterburst.com/network-policy>here</a>). Our fair usage policy doesn't affect most customers and is only enforced when a node has bandwidth related issues. If you're unsure of if your intended usage is suitable for your service, just let our support team know what it is you're doing and what your expected utilisation will be and we'll discuss it with you. 

##### Do you allow _example-illegal-activity-here_?

No. Even if something isn't specifically prohibited in our <a href=http://afterburst.com/terms-of-service>terms of service</a> or <a href=http://afterburst.com/acceptable-use-policy>acceptable use policy</a>; if it is illegal in any of the countries that we operate - or your own country - please don't do it. 

##### Do you allow IP spoofing / DDoS attacks / etc.

See above - no. DDoS attacks are illegal and specifically prohibited in our ToS. We enforce best current practice 38 (BCP38) which means we don't allow spoofed traffic to leave our network. 

##### Does the 7 day money back guarantee apply to me?

Yes - unless you've broken our terms of service or acceptable use policy; or if you're abusing the policy (e.g. signing up repeatedly every 7 days and asking for a refund each time). There's no other strings attached. 


#### I'm experiencing issues. Should I contact support? If so, what info does Afterburst need?

We list scheduled and known issues in the Network Status section of the Client Area - where you can read detailed information about current events. We also have a live status monitor which shows the up/down status of all our servers. If you're experiencing network issues, we would really appreciate reports from MTR (My traceroute) to and preferably from the VPS during the time you're experiencing issues. This helps us identify where in the internet the issue is occuring, and if it's something we can fix. You can download MTR using your Linux package manager, or on Windows by <a href=http://winmtr.net/download-winmtr/>downloading WinMTR</a>.

	[su@home #] mtr -r <vps IP here> -c 100
    [su@vps #] mtr -r <home IP here> -c 100
	
If you're not able to connect to SSH, but your VPS is online; try connecting via the HTML5 serial console in the VPS control panel. It allows you to log in to your VPS bypassing your VPS's network, firewall configurations (and SSH daemon) entirely. Common issues that prevent SSH login are incorrectly configured firewall, SSH daemon not listening/listening on the wrong port; and network configuration issues. You can clear your firewall by running

	iptables -P INPUT ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -F

You can also reconfigure your network interface via the VPS control panel by using the Reconfigure Network button.
	
#### What's next
	
The world is your oyster. It's entirely up to you what you do, as long as you stay within our Terms of Service and Acceptable Use Policy - whether its running a webserver for your blog, a minecraft server or your latest app. Good luck, and please do let us know if you run into any issues by creating a ticket at <a href=https://client.afterburst.com/>https://client.afterburst.com/</a>!
