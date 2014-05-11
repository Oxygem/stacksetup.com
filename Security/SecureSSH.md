$title=Making SSH More Secure

+ Change default port - but keep it below 1024!
+ Setup key-based auth & disable password based auth
+ setup lfd to monitor logins

Why SSH should always be below 1024:

	Unprivileged users can run daemons on ports above 1024. 
	
	This means that someone with an unprivileged user on your system would be able to perform a local privilege escalation exploit via crashing the SSH daemon and 
	starting their own, fake daemon to sniff root login. 