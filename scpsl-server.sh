#!/bin/bash
clear
echo "Created by GoodKingJohn (aka dodo721). Send some love to Paypal dodoworkspr@gmail.com <3"
echo "Give hugs to Hubert for SCP: Secret Laboratory and Grover and Kigen for MultiAdmin and ServerMod!"
echo "Enter a name for your server:"
read server_name
echo "server_name = $server_name;" >> ./config-template.txt
echo "ban_database_folder = /home/$USER/.config/SCP Secret Laboratory/Bans;" >> ./config-template.txt
echo "Enter steam username:"
read username
echo "Enter steam password:"
read password
echo "Installing SteamCMD..."
sudo apt-get install -y steamcmd
echo "Installing SCP Secret Laboratory..."
steamcmd +@sSteamCmdForcePlatformType windows +login $username $password +app_update 700330 -beta linux validate +quit
echo "Installing Mono..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/ubuntu stable-xenial main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt-get update
sudo apt-get -y install mono-complete
echo "Do you want to install server modules (MultiAdmin and ServerMod)? [y/n]"
read install_modules
if [ $install_modules = "y" ]
then
	mkdir /tmp/scpsl
	while IFS='' read -r line || [[ -n "$line" ]]; do
		echo "Downloading: $line"
		wget "$line"
	done < "./Module_URLs.txt"
	echo "Installing ServerMod..."
	mkdir "./Backup"
	mv "/home/$USER/.local/share/Steam/steamapps/common/SCP Secret Laboratory/SCPSL_Data/Managed/Assembly-CSharp.dll" "./Backup/Assembly-CSharp.dll"
	mv "./Assembly-CSharp.dll" "/home/$USER/.local/share/Steam/steamapps/common/SCP Secret Laboratory/SCPSL_Data/Managed/Assembly-CSharp.dll"
	echo "Backup of Assembly-CSharp.dll made"
	echo "Installing MultiAdmin..."
	mv "./MultiAdmin.exe" "/home/$USER/.local/share/Steam/steamapps/common/SCP Secret Laboratory/MultiAdmin.exe"
	mkdir "/home/$USER/.local/share/Steam/steamapps/common/SCP Secret Laboratory/servers"
	mkdir "/home/$USER/.local/share/Steam/steamapps/common/SCP Secret Laboratory/servers/firstserver"
	config_path="/home/$USER/.local/share/Steam/steamapps/common/SCP Secret Laboratory/servers/firstserver/config.txt"
	mv "./config-template.txt" "${config_path}"
	printf "cd \"/home/$USER/.local/share/Steam/steamapps/common/SCP Secret Laboratory\"\nmono MultiAdmin.exe" > start_server.sh
else
	config_path="/home/$USER/.config/SCP Secret Laboratory/config.txt"
	mv "./config-template.txt" "${config_path}"
	printf "cd \"/home/$USER/.local/share/Steam/steamapps/common/SCP Secret Laboratory\"\nmono LocalAdmin.exe" > start_server.sh
fi
chmod +x start_server.sh
echo "Server installed! Use ./start_server.sh to start it!"

