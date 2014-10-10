$title=Welcome to Afterburst!

Welcome to Afterburst! This guide is intended to give new clients an introduction to the basics of our services, and a few walkthroughs for common uses of our services.

Useful links: 

    VPS Control Panel: https://vps.afterburst.com
	Your username for the VPS control panel will start with vmuser and will be followed by a number (e.g. vmuser000). Your initial password will have been sent to you in the New VPS Information email, please change it immediately after login. 
	
	Client Area: https://client.afterburst.com
	Your username and password will be as entered on sign up. You can use this area to submit support tickets, pay invoices and update your information.
	
KVM VPS:

    This section is specifically for KVM. Our KVM services don't come with the OS preinstalled, so you'll need to install it over VNC. You'll be able to do this in the VPS control panel by following these steps:
	
	1) Mount the ISO you'd like to install (E.g. CentOS Minimal) to the CD/DVD drive.
	2) Reboot your VPS
	3) Connect via the VNC applet and install as you would a normal Linux server. 
	4) Configure your network interface. IPv4 uses DHCP and IPv6 uses static allocation (please contact us if you need help). For getting basic IPv4 connectivity up so you can configure over SSH instead of VNC, "ifup eth0" should do the job. 
	
Getting started:

	We highly recommend following a couple of steps once you've logged in to your VPS. 
	
	1) Set up key-based authentication for SSH. You can do this by using a tool such as ssh-keygen (if your PC is Linux/Mac based) or PuTTYGen (Windows). Once you've generated a key pair, you'll need to enter the public key into .ssh/authorized_keys in the directory of the user you'd like to enable the key for.
		E.g. for root, enter the public key in /root/.ssh/authorized_keys (this being said - root login isn't recommended)
		Once you've entered the key, configure your SSH client to use the private key. Test the connection using key authentication, and if successful, move to the next step.
	2) Disable PasswordAuthentication for SSH. You can do this by modifying /etc/sshd/sshd_config and changing "PasswordAuthentication yes" to "PasswordAuthentication no"
	
	Some people at this point may like to change their SSH port. That's entirely personal preference, though it will only really stop automated SSH attackers. If you do want to change your SSH port, please keep it below 1024. This prevents rogue users from crashing your SSH daemon and replacing it with a malicious one.
	
	3) Update your system! You'll be able to do this by running "yum update" when running CentOS/RHEL-based operating systems, or "apt-get update" for Debian/Ubuntu based systems.
	
What next?: 
	
	The world is your oyster. It's entirely up to you what you do, as long as you stay within our Terms of Service and Acceptable Use Policy - whether its running a webserver for your blog, a minecraft server or your latest app. Good luck, and please do let us know if you run into any issues at support@afterburst.com!
