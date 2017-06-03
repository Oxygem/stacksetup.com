$title=Minecraft Game Server on Debian

This entry will guide you through the process of setting up a server for Minecraft 1.11.2 on Debian 8

#### Initial steps

Make sure your system is up to date

`sudo apt-get update && sudo apt-get dist-upgrade`

Install the required dependencies. You will need at least Java 7, but Java 8 is HIGHLY recommended. OpenJDK is fine.

`sudo apt-get install openjdk-7-jre-headless`

Or for Java 8 (requires jessie-backports repository enabled in your system, unless you are using Debian Stretch or Sid)

`sudo apt-get -t jessie-backports install openjdk-8-jre-headless`

If you want to run a Spigot or Bukkit server, you also need git and tar.

`sudo apt-get install git tar`

If you want your server to continue running after you disconnect from SSH, you also need screen or tmux.

`sudo apt-get install screen` or `sudo apt-get install tmux`

For the purposes of this guide you should also have wget, nano, and ca-certificates.

`sudo apt-get install wget nano ca-certificates`

#### Set up an official Minecraft (any version) server

If you just want to run Mojang's official server (for small private servers for you and your friends, no plugins) you just need to download the official Minecraft 1.11.2 server.

`wget https://s3.amazonaws.com/Minecraft.Download/versions/1.11.2/minecraft_server.1.11.2.jar`

If you want an older (or newer) version of Minecraft (such as 1.6.4 or 1.7.10), simply replace the two instances of `1.11.2` in the above command with the version you desire. (i.e. `wget https://s3.amazonaws.com/Minecraft.Download/versions/1.7.10/minecraft_server.1.7.10.jar`)

After you have downloaded it, you need to run it with the following command.

`java -Xmx1G -Xms1G -jar minecraft_server.1.11.2.jar nogui`

This will run the server with 1 gigabyte of RAM. If you want to use more or less RAM, just replace the `-Xmx1G` and `Xms1G` with the amount you want to use. (i.e. `java -Xmx512M -Xms512M -jar minecraft_server.1.11.2.jar nogui` will start a server with a half a gigabyte of RAM. As before, if you downloaded a different version of Minecraft, you have to replace the `1.11.2` in the above command with the version you downloaded.

In the most recent versions of Minecraft, you must also accept the EULA for the server to actually start up. First, read the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula), then open up the eula.txt file with `nano eula.txt` and replace the third line that says `eula=false` with `eula=true`. After you have accepted the EULA, start the server again using the above command.

The world will take a few seconds to generate the world. Once you see a line similar to `Done (5.779s)! For help, type "help" or "?"`, you're ready to connect to the server and play! Just use your server's IP address or domain as the server address in the game's server menu. When you want to shut down the server, just type `stop` into the terminal window, or `/stop` into the game's chat from an opped account.

#### Set up a Spigot or Bukkit (1.11.2) server

If you want to run a Spigot or Bukkit server for a public server, or you just want some of the awesome features you can get from plugins, you will need to go about it a little bit differently.

Unfortunately, due to a DMCA problem, Bukkit and it's derivatives are no longer available for download, so you'll need to compile it from source. Luckily, the Spigot BuildTools make this process very straightforward. First, download the BuildTools.

`wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar`

Now, you need to run the BuildTools. This will automatically download and compile the latest version of Minecraft.

`java -jar BuildTools.jar`

As of this writing, the latest version is 1.11.2. If you would like to compile another version of Spigot/Bukkit, use the following command.

`java -jar BuildTools.jar --rev 1.10.2` (you can replace 1.10.2 with another version)

After you have compiled it, you need to run your server with the following command.

`java -Xmx1G -Xms1G -jar spigot-1.11.2.jar nogui`

This will run the server with 1 gigabyte of RAM. If you want to use more or less RAM, just replace the `-Xmx1G` and `Xms1G` with the amount you want to use. (i.e. `java -Xmx512M -Xms512M -jar minecraft_server.1.11.2.jar nogui` will start a server with a half a gigabyte of RAM.

In the most recent versions of Minecraft, you must also accept the EULA for the server to actually start up. First, read the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula), then open up the eula.txt file with `nano eula.txt` and replace the third line that says `eula=false` with `eula=true`. After you have accepted the EULA, start the server again using the above command.

The server will take a few seconds (or possibly minutes) to set up the server and generate the world. Once you see the line similar to `Done (8.167s)! For help, type "help" or "?"`, you're ready to connect to the server and play! Just use your server's IP address or domain as the server address in the game's server menu. When you want to shut down the server, just type `stop` into the terminal window, or `/stop` into the game's chat from an opped account.

#### Opping players

If you want to be able to do cheats and other admin commands, you will need to be opped. To op someone, simply type `op Player` into the terminal window, replacing `Player` with their Minecraft username. The player may have to log on to the server before you can do this. Once at least one player is opped, they can op other players by saying `/op Player` in chat, replacing Player with the other players' Minecraft username.

#### Startup script

The commands for starting your server are long and hard to remember. If you want to simplify it, you can create a startup script, so you can easily start your server with a much shorter and simpler command. For this example I will be creating a startup script called `server.sh`.

First you need to create the file.

`touch server.sh`

Next, you need to mark it as executable, so the system will give you permission to run it.

`chmod +x server.sh`

Now, you need to open it up and tell it what commands to run.

`nano server.sh`

And in the file, add the following lines.

```
#!/bin/bash
cd ~/minecraft # Replace ~/minecraft with the actual directory where your server is
java -Xmx1G -Xms1G -jar minecraft_server.jar nogui # Replace minecraft_server.jar with the name of your Minecraft server executable.
exit
```

Now, when you want to run your server, just cd to the directory where your server is and run

`./server.sh`

#### Automatically restarting the server

If you want the server to automatically restart after someone shuts it down, you need to make some adjustments to your startup script. Open your startup script.

`nano server.sh`

After the `java` line and before the `exit` line, add the following lines.

```
echo Server stopped. Waiting 3 seconds to restart the server. To cancel, press Ctrl-C
sleep 3
./server.sh
```

Now, as long as you started the server with the startup script, it will automatically restart whenever someone shuts it down. It will also wait 3 seconds before restarting, so you have a chance to press Ctrl-C to stop it from restarting.

#### Make the server continue running after disconnecting from SSH

By default, your server will be killed if your SSH session dies. This is generally undesireable. To prevent this, we must run the server inside a tmux or screen session. Before running your server, just open a screen or tmux session.

`screen` or `tmux new`

If you're using screen, you'll see a small informational text about screen. Just hit enter to clear it, then you can run your server.

`./server.sh`

When you want to disconnect from your screen session, just press Ctrl-A, then press D. If you want to disconnect from your tmux session, just press Ctrl-B, then press D. Your Minecraft server will continue running safe and sound inside your screen or tmux session.

To reconnect to the server's console, just attatch to your screen or tmux session.

`screen -r` or `tmux a`

Note: If screen is already connected elsewhere, it will not let you connect again. Use `screen -rd` to connect to it and forcibly disconnect the other session.
