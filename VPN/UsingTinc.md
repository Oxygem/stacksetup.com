$title=Using Tinc to create a mesh network

[Tinc](http://tinc-vpn.org) is a fantastic, mesh based VPN. It can be used to build a secure, encrypted pseudo-VLAN over the public internet. Tinc is a fairly complicated process so this page is broken down into sections:

+ [Structure](#structure)
+ [Installing Tinc](#install)
+ [Basic two node network](#basic)
+ [Debugging Tinc](#debug)


<h3 id="structure">Structure</h3>

Below is an example directory tree for Tinc, which all participating nodes must hold:

+ **/etc/tinc/<interface_name\>**
    * `tinc.conf`
    * `tinc-up`
    * `tinc-down`
    * `rsa_key.priv`
    * **hosts/**
        - `myhost`
        - `myhost2`


`hosts/` contains files, each representing a node in the Tinc network. Nodes which directly connect to each other will need to have each others hosts files. Nodes which don't directly connect will exchange keys automatically over the Tinc network once they join it. Each file contains details of the nodes public IP, private IP and the public RSA key.

`tinc.conf` tells the local server where to connect to, what device to use and what mode to use. The file will basically be the same for all hosts in the network:

    Name=myhost2
    Device=/dev/net/tun
    Mode=switch
    ConnectTo=myhost

`tinc-up` and `tinc-down` are executed by the Tinc daemon upon starting and ending, these are useful to actually bring the Tinc interface online and setup routes so your server knows how to talk to the Tinc network.

`rsa_key.priv` is the private key of the local server.


<h3 id="install">Installing Tinc</h3>

When installing Tinc remember it is important that the protocol versions (_not the same as Tinc versions_) match up across your network. I would advise using the same Tinc version on all nodes to make this easier. It's very easy to compile Tinc yourself, you will need headers/devel versions of the following: `libssl`, `liblzo`, `libzlib`.

    wget http://tinc-vpn.org/packages/tinc-1.0.23.tar.gz
    tar -xf tinc-1.0.23.tar.gz
    cd tinc-1.0.23
    ./configure --prefix=
    make
    sudo make install


<h3 id="basic">Basic two node Tinc setup</h3>

For this second we're going to deploy two servers to talk to each other via Tinc, I shall refer to them as the 'master' and 'client'. Note that technically Tinc is a mesh network, so there's no real 'master' server, simply a node which doesn't connect to any others, but is connected to. This is great because we can use multiple `ConnectTo` statements in `tinc.conf` to achieve a highly-available VPN. For this we are building our Tinc network on the `10.10.0.0/24` VPN which allows us to use addresses in the range `10.10.0.1` => `10.10.0.254`. We will set the master on `10.10.0.1` and the client on `10.10.0.2`.

We're going to call our VPN interface `vpn`, so on both servers install Tinc as per the above instructions and then lets create some directories/files we're going to use:

    mkdir -p /etc/tinc/vpn/hosts/
    touch /etc/tinc/vpn/tinc.conf
    touch /etc/tinc/vpn/tinc-up
    touch /etc/tinc/vpn/tinc-down

Firstly, let's edit `tinc.conf` on the master:

    Name=master
    Device=/dev/net/tun
    Mode=switch

And on the client:

    Name=client
    Device=/dev/net/tun
    Mode=switch
    ConnectTo=master

Now we've named each machine, we're ready to have Tinc generate private/public key pairs for each node. On each run:

    tincd -n vpn -K4096
    ...
    Please enter a file to save private RSA key to [/etc/tinc/vpn/rsa_key.priv]: 
    Please enter a file to save public RSA key to [/etc/tinc/vpn/hosts/master]:

Save the keys with the default names (`/etc/tinc/vpn/hosts/master` and `/etc/tinc/vpn/hosts/client`). Now let's setup these files completely. On the master edit `/etc/tinc/vpn/hosts/master`, and put at the top:

    Address=public-ip
    Port=655
    Compression=0
    Subnet=10.10.0.1/32

    --RSA KEY FROM TINC--

And do exactly the same on the client to `/etc/tinc/vpn/hosts/client`, except change the address to `10.10.0.2/32`. Next you need to copy the `hosts/client` file to the master node and the `hosts/master` file to the client node, so both nodes have identical copies of both `hosts/master` and `hosts/client`. That's everything directly Tinc related complete!

However, the network won't run yet, we need to edit `tinc-up` and `tinc-down` on each node to setup the interface, IP (must be configured in `tinc-up` AND the hosts file) and routing. These files will look very similar on both master & client, only the IP of the interface will change:

    $ cat tinc-up:
    #!/bin/bash
    # Up tinc, add IP
    ifconfig vpn <10.10.0.1 OR 10.10.0.2> netmask 255.255.255.0 up
    route add -net 10.10.0.0 netmask 255.255.255.0 gw 10.10.0.1 dev vpn

All you do is replace `<10.10.0.1 OR 10.10.0.2>` with the IP of whichever node you are on (master or client). Note the gateway IP is `10.10.0.1`, the IP of the master. Finally:

    $ cat tinc-down:
    #!/bin/bash
    # Down tinc
    ifconfig vpn down

And, that should be that! Just run `sudo tincd -n vpn` on each box and hopefully they should both be able to ping each other on `10.10.0.1` and `10.10.0.2`. Not working? Checkout the debug section below to ways to find out what's going wrong:


<h3 id="debug">Debugging Tinc</h3>

Tinc isn't the most user friendly application, and documentation is scarce, especially when you're seeing weird routing or network issues. Luckily there's a bunch of things we can use to get more information from Tinc. The best is simply running in the foregroud with a high debug level:

`tincd -D -d 5`

`-D` keeps tincd in the foreground and `-d` sets the debug level (0-5). Once running, ctrl+c to switch between debug levels.

It's also possible to get some information out of running daemon tincd's:

+ `kill -USR1 <tinc pid>` - dumps the connection list
+ `kill -USR2 <tinc pid>` - dumps virtual network statistics



#### Related:

+ [http://www.tinc-vpn.org/docs/](http://www.tinc-vpn.org/docs/)
+ [http://www.tinc-vpn.org/examples/](http://www.tinc-vpn.org/examples/)
