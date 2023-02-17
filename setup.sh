#!/bin/bash

echo "installation process initialized ...starting in 2s "

echo "######################execution#####################################"

if [ -d usr/bin/python3 ]
then
	sudo apt install -y python3
else
	echo "python3 is installed"
fi

sudo apt install -y build-essential

sudo apt install -y gnome-tweaks 

sudo apt install gnome-shell-extension-manager -y

sudo apt install snapd
function snap_setup(){
	#installs vlc,whatsapp,firefox and postman
	snap_packs=['vlc','whatsie','firefox','postman']
	for snap in snap_packs
	do
	     sudo snap install $snap
	done
}	

function mysql_setup(){
	#installs mysql server
	sudo apt install -y mysql-server
	sudo systemctl start mysql.service
	return 0
}
function mssql_tools(){
	curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
	sudo ACCEPT_EULA=Y apt install mssql-tools unixodbc-dev -y

	#path config
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
	source ~/.bash_profile
	return 0
}
function mssql_setup(){
	#installs microsoft sql server
      wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
      sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)"
      sudo apt-get install -y mssql-server

      #installs mssql-tools
      mssql_tools()
      return 0
}


function vs(){
	#sets up vscode for instalation
	sudo apt install software-properties-common apt-transport-https wget -y
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	return 0
}
function code_blocks(){
	#installs codeblock and necessary dependancies
	sudo apt install g++ -y
	sudo add-apt-repository universe -y
	sudo apt intall codeblocks -y
	sudo apt install codeblocks-contrib -y
	return 0
}
function code_editors(){
	#installs vscode and sublime text
	vs
	sudo apt install code
	code_blocks
	sudo snap install sublime-text --classic
	return 0

}
function inst_browsers(){
	#installs chrome browser
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo apt install ./google-chrome-stable_current_amd64.deb
	return 0
}

function verification(){
	#checks if packages installed successfully
	gcc --version
	subl --version
	postman --version
	vlc --version
	firefox --version
	mysql --version
	git --verion
	return 0
}

function shell_config(){
	sudo apt install zsh -y
	chsh -s $(which zsh)
	return 0
}
function get_git(){
	sudo apt intall git -y
	#personal info 
	
	gitName="kefason"
	gitEmail="joshkefason@gmail.com"
	git config --global user.name $gitName
	git config --global user.email $gitEmail
	return 0
}

######################execution call#####################################
snap_setup
sleep(0.5)
echo "[+]process A complete"
mysql_setup
sleep(0.5)
echo "[+]process B complete"
mssql_setup
sleep(0.5)
echo "[+]process C complete"
code_editors
sleep(0.5)
echo "[+]process D complete"
inst_browsers
sleep(0.5)
echo "[+]process E complete"
verification
sleep(0.5)
echo "[+]process F complete"

get_git

echo "[+] starting shell configuration "
shell_config

#####updating system kernels

sudo apt update -y && sudo apt upgrade -y
