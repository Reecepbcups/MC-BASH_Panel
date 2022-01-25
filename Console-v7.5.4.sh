#!/bin/bash

# Reecepbcups main control script ${0##*/}
# Debian 9, 10 & Ubuntu Compatable

# -= To Do =-
# fix killing tail on exit
# add `ps aux | grep java` to console panel
# killall tail ? 
# ADMIN > KillAll Java  -run:  kill -9 $(ps -ef | pgrep -f "java")

#crontab -e
#0 3 * * * /root/server/Console.sh reboot SERVERNAME
#0 2 * * * /minecraft/BetterBackupScript-v12.sh
	

# -----------------------------------------------------------------------------------------------------------------

# PUT *.sh into /root/server
dos2unix /home/craft/server/server_info.sh && source /home/craft/server/server_info.sh
# SERVER_ROOT=/home/chalabi/server

# -----------------------------------------------------------------------------------------------------------------

# Cosmetic Things
colors() { # COLOR CODES - https://misc.flogisoft.com/bash/tip_colors_and_formatting
	# \033 = \e
	RED='\e[31m'; 		LRED='\e[91m'
	GREEN='\e[32m'; 	LGREEN='\e[92m'
	YELLOW='\e[33m'; 	LYELLOW='\e[93m'
	BLUE='\e[34m'; 		LBLUE='\e[94m'
	MAGENTA='\e[35m'; 	CYAN='\e[36m'
	# Other Colors
	STOP='\e[0m'; 		BOLD='\e[1m'; 
	UNDERLINE='\e[4m'; 	BLINKING='\e[5m'
	NC='\e[0m'; 		WHITE='\e[0;39m' 
	#\COLOR CODES
}
printTitle() { # Title Creator ( printTitle ${LRED} "TITLE TEXT" )
	clear; printf "${1}"
	figlet -w 200 -f standard "${*:2}"
	printf "${STOP}"
}

# Server Functions
is_running() {
	# Returns 0 if on, 1 if off.
	if screen -ls | grep -q $1; then
		#echo -e "${GREEN} $1 already running"
		return 0
	else
		return 1
	fi
}
sendServerCommand() {
	is_running $1
	isItRunning=$? # return of previous command
	
    if [ "$isItRunning" == "0" ]; then
        screen -r $1 -X stuff "${2}\015"
    else
		if [ -z $3 ] && [ "$3" == "ouput" ]; then
			echo -e "${RED}[X] $1 is not online."
		fi
    fi
}


# Server Access / ON/OFF
startAllServers() {
	printTitle ${LGREEN} "STARTING SERVERS"
	
    for _server in "${SERVER_FOLDERS[@]}"; do
		is_running $_server
		isItRunning=$?

        if [ "$isItRunning" == "0" ]; then
            printf "${GREEN}> ${_server} already running\n"        
        else			
			if [ ! -d $SERVER_ROOT/$_server ]; then 
				printf "${RED} [!] ${_server} is not a folder. Remove from ${0##*/} to fix ${NC}\n"
			else
				cd $SERVER_ROOT/$_server
				dos2unix -q start.sh && chmod +x start.sh
				screen -S $_server -dmS ./start.sh
				echo -e "${GREEN}Started $_server server"
			fi
        fi
    done;
	
	for _program in "${!OTHER[@]}"; do
		#echo "key  : $_program"; echo "value: ${OTHER[$_program]}"
		is_running $_program; isItRunning=$?
        if [ "$isItRunning" == "0" ]; then
			printf "${GREEN}> ${_program} already running\n"  
		else
			screen -S $_program -dmS ${OTHER[$_program]}
			echo "Started $_program"
		fi
	done
}
stopAllServers() {
	
	printTitle ${RED} "STOP SERVERS"

    # Alert Users
    for server in "${SPIGOT_SERVERS[@]}"; do    
        sendServerCommand $server "bc &c[!] &4Servers stopping from script" "output"
    done
    for server in "${PROXY_SERVERS[@]}"; do
        sendServerCommand $server "alert &c[!] &4Servers stopping from script\015" "output"
    done
    sleep 3

    # Send end message + add to logs its down
    for server in "${SPIGOT_SERVERS[@]}"; do
        sendServerCommand $server "stop"

    done
    for server in "${PROXY_SERVERS[@]}"; do
        sendServerCommand $server "end"
		if [ -d $SERVER_ROOT/$server/logs ]; then
			echo "[!] Spigot Server stopped from script" >> $SERVER_ROOT/$server/logs/latest.log
		fi
    done
    sleep 1

    # Quits everything
	ALL=(${SPIGOT_SERVERS[@]} ${PROXY_SERVERS[@]} ${!OTHER[@]}); 
	# This SHOULD work given ${!OTHER[@]} makes it read the key values to quick from the screen
    for server in ${ALL[@]}; do    
		is_running $server
		isItRunning=$?
        if [ isItRunning ]; then screen -XS $server quit >/dev/null; fi		
    done
	
	for server in "${SERVER_FOLDERS[@]}"; do
		if [ -d $SERVER_ROOT/$server/logs ]; then
			echo "[!] Server stopped from script" >> $SERVER_ROOT/$server/logs/latest.log
		fi
	done
	
	echo -e "\n${GREEN}Following servers are closed: ${YELLOW}${ALL[@]}"


}
console(){

	printTitle ${LYELLOW} "CONSOLE"

    # Loop through server array and enumerate them ( [0] SERVER1 )
    for i in "${!MISC_SERVERS[@]}"; do 
      printf "%s\t%s\n" "[$i] ${MISC_SERVERS[$i]}"
    done
    echo ""
    read consoleconnect

    server=${MISC_SERVERS[consoleconnect]}

    # If blank
    #[ -z "$server" ] && printf "USAGE: #";

    clear 
	printTitle ${MAGENTA} $server
    printf "${RED} \"exit\" to exit\n%.0s" {1..5}
	printf "\n${YELLOW}Commands: \n"
	printf "${YELLOW} -> 'start-server' ${WHITE}(Only if offline)\n"
	printf "${YELLOW} -> 'stop-server' \n"
	printf "${YELLOW} -> 'exit' \n"
	printf "\n"
	printf "${LBLUE} $(grep "server-port" $SERVER_ROOT/$server/server.properties) \n"
	printf "${LBLUE} $(grep "MEM_HEAP=" $SERVER_ROOT/$server/start.sh) \n"
	printf "${NC}"
	
	
	# Output log. If Ctrl+z done it stops log (CTRL+C does not)
	# tail -f $SERVER_ROOT/$server/logs/latest.log &
    tail -F --retry $SERVER_ROOT/$server/logs/latest.log &
	tailpid=$!
	
	printf "PID: $tailpid\n\n"
    while read line; do
        screen -r $server -X stuff "${line}\015" &
		
		if [ "$line" == "start-server" ]; then
			# cant do return statements here with the &'s
			if screen -ls | grep -q $server; then
				echo "${server} already running" >> $SERVER_ROOT/$server/logs/latest.log
			else
				cd $SERVER_ROOT/$server
				echo "${GREEN} Starting ${server} :D" 
				screen -S $server -dms ./start.sh
				# OLD VVV
				#echo "${server} starting... " >> $SERVER_ROOT/$server/logs/latest.log				
				#echo "Ctrl+z, then CONSOLE > ${server} number " >> $SERVER_ROOT/$server/logs/latest.log
				cd $SERVER_ROOT
			fi

		fi
		if [ "$line" == "stop-server" ]; then
			#cd $SERVER_ROOT/$server #screen -S $server -dms ./start.sh
			sendServerCommand $server "bc&4Server going down in 3 seconds..."
			echo "${RED} Server going down..."
			sendServerCommand $server "stop"
			sendServerCommand $server "end"
			sleep 6
			screen -XS $server quit >/dev/null
			echo "Server shutdown"
			initMenu "$@"; # brings user back to main menu
		fi
		if [ "$line" == "exit" ]; then
			kill $tailpid
			initMenu "$@"; # brings user back to main menu			
		fi
    done
}


# Website Functions linkShortener
linkShortener(){
	printTitle ${LBLUE} "Link Shortner"
	
	# If the website dir is not set, make it
	if [ ! -d "$SERVER_WEBSITE" ]; then mkdir $SERVER_WEBSITE; fi;

	echo -e "\nShortened Link DIR (ex. serverrules)?: "; read FOLDER_LINK
	LOCATION=$SERVER_WEBSITE/$FOLDER_LINK

	# if the folder does not exist yet
	if [ ! -d "$LOCATION" ]; then
		mkdir $LOCATION && cd $LOCATION
		
		echo "Link to redirect too: (ex. https://www.google.com)"; read URL
		# If http is not in the URL start
		if [[ ! $URL == http* ]]; then URL="http://${URL}"; fi;
	
	# old
#	echo "<html><head><title>Link redirect</title>
#<meta http-equiv=\"Refresh\" content=\"0; url='$URL'\" />
#</head>
#</html>" >> index.html

	echo "<html><head><title>Link Redirect | $URL</title></head>
<body><script>
window.location.replace('$URL');
</script></body></html>" >> index.html

	echo -e "\n\n ${WEBSITE_DOMAIN}${FOLDER_LINK} >> $URL"

	fi

}


# Networking
fixPort() {  
	printTitle ${MAGENTA} "Fix Bound Server Port v1.6"
	echo ""
	for i in "${!MISC_SERVERS[@]}"; do
	  echo "${MISC_SERVERS[$i]}"
	  grep "server-port=" $SERVER_ROOT/${MISC_SERVERS[$i]}/server.properties
	  echo ""
	done

	echo "Which port is the server on?: "; read PORT
	# lsof -i :9755 && kill -9 PID
	kill -9 $(lsof -t -i:$PORT -sTCP:LISTEN)

	echo 'Port $PORT killed for server. Should be able to boot correctly now'

}
resetFirewall() {
    echo -e "\nAre you sure you want to reset the firewall back to all OPEN? (Y/<N>)"
    read firewall_check

    if [ "$firewall_check" == "Y" ]; then
        iptables -F
		iptables -X
		iptables -t nat -F
		iptables -t nat -X
		iptables -t mangle -F
		iptables -t mangle -X
		iptables -P INPUT ACCEPT
		iptables -P OUTPUT ACCEPT
		iptables -P FORWARD ACCEPT
		# Allow Loobback connections
		iptables -A INPUT -i lo -j ACCEPT; iptables -A OUTPUT -o lo -j ACCEPT
	
		# ALLOW SSH
		iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
		iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT
		#apt-get remove iptables
		echo "Done!"
    fi

}
applyNewFirewallRules() {

	echo -e "\nAre you sure you want to set the firewall settings? (Y/<N>)"
    read set_firewall_check
    if [ "$set_firewall_check" == "Y" ]; then
        echo ""
	else
		echo "Not setting firewall..."
		return 0
    fi

	#apt-get install iptables
    set -e # not sure if this messes with things
	# Config section at top with variables.

    # Check if we are root
    [ $EUID == 0 ] || { echo "This script must be run as root"; exit 0; }

    # Support both space and comma delimited configuration strings
    ALLOW_PORTS=${ALLOW_PORTS// /,}
    BUNGEE_HOST_IPS=${BUNGEE_HOST_IPS// /,}
    BUNGEE_BACKEND_PORTS=${BUNGEE_BACKEND_PORTS// /,}

    # Clear ALL iptables settings
    resetFirewall

    # Drop all connections by default
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    # Allow inter-communication
    iptables -A INPUT -i lo -j ACCEPT
    # Allow incoming connections if we initiated them
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    # Allow access to some ports
    iptables -A INPUT -p tcp -m multiport --dports $ALLOW_PORTS -j ACCEPT

    # Firewall our BungeeCord network (Won't run if $BUNGEE_HOST_IPS is empty)
    [ -z "$BUNGEE_HOST_IPS" ] || iptables -A INPUT -p tcp -m multiport --dports $BUNGEE_BACKEND_PORTS -s $BUNGEE_HOST_IPS -j ACCEPT

    echo -e "\nDONE!\nSave new settings? (Y/N)"; read save

    if [ "$save" == "Y" ] ||  [ "$save" == "y" ]; then
        apt-get install iptables-persistent
        iptables-save > /etc/iptables/rules.v4 && ip6tables-save > /etc/iptables/rules.v6
    else
		printf "\nRestore Previous settings? (Not tested) (Y/N)"; read restore
		if [ "$restore" == "Y" ]; then 
			iptables-restore < /etc/iptables/rules.v4;
		fi
	fi
}


# New Server Instance / Setup
newServerInstance() {

	printTitle ${LGREEN} "Server Creator v1.2"

    read -p "Server Name (ex. SKYBLOCK)> " _server_name
	echo ""

	if [ -x "$(command -v jq)" ]; then
        # output PaperMC packages which can be used if jq is installed
		echo "Versions Avaliable: "
        curl -s 'https://papermc.io/api/v2/projects/paper/' | jq -c '.versions'
    fi

	read -p "Paper Spigot Version (ex. 1.8.8)> " VERSION
    read -p "RAM (ex. 512M or 2G)> " RAM
    read -p "Port (ex. 25570)> " PORT
	echo ""
    read -p "Nether? (true/<false>)> " NETHER
	read -p "Bungee? (y/<n>)> " BUNGEE
    read -p "Max Players: (<20>)> " MAX_PLAYERS
    read -p "View Distance (<4>)> " SERVER_VIEW_DISTANCE

    SERVER_DIR=$SERVER_ROOT/$_server_name

    # Double Checks its not already a server first before continuing
    if [[ -d "${SERVER_DIR}" ]] ; then echo "Dir ${SERVER_DIR} exists. exit." && exit ; fi

    # Move to DIR and download paper spigot jar
    mkdir $SERVER_DIR && cd $SERVER_DIR
	
	# Download paper
	BUILD_ID=$(curl -s 'https://papermc.io/api/v2/projects/paper/versions/$VERSION/' | jq -cr '."builds" | .[-1]')
	curl -o "Paper-$VERSION.jar" "https://papermc.io/api/v2/projects/paper/versions/$VERSION/builds/$BUILD_ID/downloads/paper-$VERSION-$BUILD_ID.jar"


    # Start.sh script ##
    echo "#!/bin/sh
# Reecepbcups - start.sh script for servers. 
# Use the 1st JAVA_ARGS option (long) if you use more than 12GB of ram on the server instance
            
MEM_HEAP=\"${RAM}\"
JAR_FILE=\"Paper-${VERSION}.jar\"
JAVA_ARGS=\"-Dfile.encoding=utf-8 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=40 -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:-OmitStackTraceInFastThrow -XX:+AlwaysPreTouch  -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=true -Daikars.new.flags=true -jar\"
#JAVA_ARGS=\"-Dfile.encoding=utf-8 -jar\"

while true; do
	java -Xms\$MEM_HEAP -Xmx\$MEM_HEAP \$JAVA_ARGS \$JAR_FILE nogui
	echo \"Restarting server in 5 seconds\"
	sleep 4
	echo \"Restarting...\"
	sleep 1
done" >> start.sh && chmod +x start.sh && dos2unix --quiet start.sh


    ## Server.properties file  defaults##
    if [[ -z "$MAX_PLAYERS" ]]; then MAX_PLAYERS=20; fi;
    if [[ -z "$PORT" ]]; then PORT=25599; fi;
    if [[ -z "$SERVER_VIEW_DISTANCE" ]]; then SERVER_VIEW_DISTANCE=4; fi;
    if [[ -z "$NETHER" ]]; then NETHER=false; fi;
    if [[ -z "$BUNGEE" ]]; then BUNGEE="n" ; fi;
    #if [[ -z  ]]; then ; fi;

	if [ "$BUNGEE" == "y" ]; then 
		ONLINEMODE=false && NETWORKCOMPRESSION=-1
		echo "settings:
  bungeecord: true
  restart-on-crash: false
  restart-script: ./DoneByStartScript.sh" >> spigot.yml
	else
		ONLINEMODE=true && NETWORKCOMPRESSION=256
	fi

    echo "
max-players=$MAX_PLAYERS
server-port=$PORT
view-distance=$SERVER_VIEW_DISTANCE
allow-nether=$NETHER
online-mode=$ONLINEMODE
network-compression-threshold=$NETWORKCOMPRESSION" >> server.properties
	
    # Eula = True
    echo "eula=true" >> eula.txt

    printf '\n---------------------------------------------------\n'
    echo "Make sure to add $_server_name to the variables in this script!"

}
newMachineSetup() {

	printTitle "${LGREEN}" "Linux MC Installer"

	echo "FreshInstall, other"; read answer

	if [ "$answer" == "FreshInstall" ]; then
		apt-get update
		
		echo "Creating user 'reece' for dir /root"
		sudo useradd -m -d /root -s $(which bash) -G sudo reece
		# usermod -u 0 reece # does this work? untested
		# usermod -g 0 reece
		passwd reece		
		
		# Add user to sudo file so they dont have to enter password
		# >> is appending
		echo "root ALL=(ALL) ALL" >> /etc/sudoers
		echo "reece ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
		echo "sudo ALL=(ALL) ALL" >> /etc/sudoers
		
		echo "alias console='/root/server/Console-v*.sh'" >> /root/.bashrc
		source /root/.bashrc
		
		# Add NodeJS keys
		apt-get install curl software-properties-common
		curl -sL https://deb.nodesource.com/setup_12.x | bash -
		
		# Install other programs
		apt-get install dos2unix nginx sudo zip unzip lsof default-jre screen htop glances build-essential 
		apt-get install nodejs cpufrequtils figlet redis
		cpufreq-set -r -g performance && lscpu | grep "CPU MHz"	
		timedatectl set-timezone America/Chicago
		
		# Java 11 - doesnt work for my hub yet
		echo 'deb http://ftp.debian.org/debian stretch-backports main' | sudo tee /etc/apt/sources.list.d/stretch-backports.list
		sudo apt update && apt-get upgrade
		sudo apt install openjdk-11-jdk
		sudo apt-get install openjdk-11-jre
		
		# Java 8 / Java8
		wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
		sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
		sudo apt-get update && sudo apt-get install adoptopenjdk-8-hotspot
		
		# https://stackoverflow.com/questions/57031649/how-to-install-openjdk-8-jdk-on-debian-10-buster
		sudo apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main'
		sudo apt-get update
		sudo apt-get install openjdk-8-jdk
		
		sudo update-alternatives --config java
		mkdir $BACKUP_DIRECTORY
		
		echo "Install Database? (MariaDB) (Y/N)"; read database
		if [ "$database" == "Y" ]; then
			apt-get install mariadb-server mariadb-client
			echo " "
			mysql_secure_installation	
		fi
		
		echo "Apply Current Firewall Rules? (double check server_info) (Y/N)"; read checkfirewall
		if [ "$checkfirewall" == "Y" ]; then
			applyNewFirewallRules
		fi
		
		echo "DONE"
	fi

	if [ "$answer" == "Unpack" ]; then
		# Unzip process
		cd $SERVER_ROOT
		unzip *.zip
		rm -rf /var/www/html # Delete current HTMl folder
		cd $SERVER_ROOT/var/www/ # goes into the html folder
		mv html /var/www/
		cd $SERVER_ROOT;rm -rf var
		echo "make sure to crontab -e and add 0 0 * * * .$SERVER_ROOT start_all.sh"
	fi	


}

newUserSetup() {
  
  printTitle ${LGREEN} "User Creator v1.0"

  echo "Username: (This user gets sudo access)"; read username
  echo "Directory is /root. Press enter to continue if this is okay"; read vvv
  
  # setup new user info
  sudo useradd -m -d /root -s $(which bash) -G sudo $username
  # usermod -u 0 $username # does this work? untested
  # usermod -g 0 $username
  
  passwd $username
  echo "$username ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  
  echo "If any information is wrong for user, make sure to edit /etc/sudoers" 

}

# Screens - control menu area kinda
screenCommands() {
    echo "------------------"
    screen -ls | grep "("
    echo '------------------'
	
	if [ "$1" == "Join" ]; then
		echo "Which Client do you want to join? (Fullname - ex. SKYBLOCK)"; read screenName
		screen -r $screenName
	fi
	
	if [ "$1" == "Quit" ]; then
		echo "Which Client do you want to QUIT? (Fullname - ex. SKYBLOCK)"; read screenToQuit
		screen -XS $screenToQuit quit
		echo "Quit Screen $screenToQuit"
	fi
	
	if [ "$1" == "New" ]; then
		echo "Name of New Screen Session"; read screenname
		screen -dmS $screenname bash
		echo "Started $screenname"
		screen -ls | grep "$screenname"
	fi


}


serverReboot() {
	# crontab -e
	# 0 3 * * * /root/server/Console.sh reboot SERVERNAME

	SERVER=$1
	
	sendServerCommand $SERVER "broadcast &c[!] DAILY REBOOT\015"
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 5 minutes\015"
	sleep 4m
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 1 minute\015"
	sleep 30s
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 30 seconds\015"
	sleep 27s
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 3 seconds\015"
	sleep 1s
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 2 seconds\015"
	sleep 1s
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 1 second\015"
	sleep 1s
	sendServerCommand $SERVER "broadcast &c[!] Restarting...\015"
	sleep 3s
	sendServerCommand $SERVER "stop\015"

	echo "$(date) REBOOT FROM SCRIPT" >> $SERVER_ROOT/$SERVER/logs/${SERVER}-Reboot.log
}


changeJavaVersion() {
  sudo update-alternatives --config java
}  

# Panels
adminPanelMenu() {
	printTitle ${LRED} "ADMIN PANEL"
	
	while true; do
		printf "\n${LRED}"
		printf "[1] Make New Server\n"		
		printf "[2] STOP-ALL Servers\n"
		printf "\n"
		printf "[ScrConn] Connect to Screen\n"
		printf "[ScrQuit] Quit Screen\n"
		printf "[ScrNew]  New Screen\n"
		printf "\n"
		printf "[RESET-FIREWALL] Reset Firewall to OPEN\n"
		printf "[APPLY-FIREWALL] Apply/Restore Firewall\n"
		printf "\n"
		printf "[CHANGE-JAVA-VERSION] changes default java version\n"
		printf "\n"
		printf "[WEB] Link Shortener\n"
		printf "[REECE-NEWMACHINE] New Machine Setup (ONLY REECE)\n"
		printf "[NEW-USER] Create a new user\n"
		printf "[NEW-DB] Create a new Database\n"
		printf "[CP] back to control panel\n\n"
		
		printf "${WHITE}ACP> "
		
		read admininput
		printf "===========================\n"
		if [ "$admininput" == "1" ]; then newServerInstance ; fi;
		if [ "$admininput" == "2" ]; then stopAllServers ; fi;
		
		if [ "$admininput" == "WEB" ]; then linkShortener ; fi;
		if [ "$admininput" == "RESET-FIREWALL" ]; then resetFirewall ; fi;
		if [ "$admininput" == "CHANGE-JAVA-VERSION" ]; then changeJavaVersion ; fi;
		if [ "$admininput" == "APPLY-FIREWALL" ]; then applyNewFirewallRules ; fi;
		if [ "$admininput" == "REECE-NEWMACHINE" ]; then newMachineSetup ; fi;
		if [ "$admininput" == "NEW-USER" ]; then newUserSetup ; fi;
		if [ "$admininput" == "NEW-DB" ]; then newDatabase ; fi;
		if [ "$admininput" == "ScrConn" ]; then screenCommands "Join" ; fi;
		if [ "$admininput" == "ScrQuit" ]; then screenCommands "Quit" ; fi;
		if [ "$admininput" == "ScrNew" ]; then screenCommands "New" ; fi;
		if [ "$admininput" == "CP" ]; then initMenu ; fi;
		
		if [ "$admininput" == "exit" ]; then exit ; fi;
	done
}

# ------

createDatabase() {
	printTitle ${LGREEN} "Create Database V1.0"
	printf "Database Name: "; read databse_name;
	sudo mysql -u root -e "CREATE DATABASE ${databse_name};"
	
	printf "${LGREEN} \nDatabase \" ${databse_name} \" has been created!\n"
}
deleteDatabase() {
	printTitle ${LGREEN} "Delete Database V1.0"
	sudo mysql -u root -e "SHOW DATABASES;"
	printf "\nDatabase TO DELETE: "; read delete_database;
	sudo mysql -u root -e "DROP DATABASE ${delete_database};"	
	printf "${LRED} \nDatabase \" ${delete_database} \" has been deleted!\n"
}
showDatabases() {
	printTitle ${LGREEN} "Show Databases V1.0"	
	sudo mysql -u root -e "SHOW DATABASES;"		
}

createNewUser() {
	printTitle ${LGREEN} "Create User V1.0"
	printf "Database Username: "; read username;
	printf "Database Password: "; read password;
	sudo mysql -u root -e "CREATE USER ${username}@localhost IDENTIFIED BY '${password}';"
	sudo mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO ${username}@localhost; FLUSH PRIVILEGES;"		
	printf "${GREEN} \nUser \" ${username} \" has been created!\n"
}
deleteUser() {
	printTitle ${LGREEN} "Delete User V1.0"	
	sudo mysql -u root -e "select host, user, password from mysql.user;"
	printf "\nUser you want to delete: "; read delete_user;
	sudo mysql -u root -e "drop user ${delete_user}@'localhost';"
	printf "\n"	
}
showUser() {
	printTitle ${LGREEN} "Users List V1.0"	
	printf "\n"
	sudo mysql -u root -e "select host, user, password from mysql.user;"
	printf "\n"	
}


# -------

databasepanel(){
	printTitle ${LGREEN} "DATABASE PANEL"
	printf "\n${LGREEN}"
	printf "[1] Create DB\n"
	printf "[2] Delete DB\n"
	printf "[3] Show All\n"
	
	printf "\n[4] Create User\n"
	printf "[5] Delete User\n"
	printf "[6] Show Users\n"
	
	
	printf "\n${WHITE}DATABASE> "
	read mysqlpanelinput
	echo "===========================\n"
	if [ "$mysqlpanelinput" == "1" ]; then createDatabase; fi;
	if [ "$mysqlpanelinput" == "2" ]; then deleteDatabase; fi;	
	if [ "$mysqlpanelinput" == "3" ]; then showDatabases; fi;
	
	if [ "$mysqlpanelinput" == "4" ]; then createNewUser; fi;
	if [ "$mysqlpanelinput" == "5" ]; then deleteUser; fi;
	if [ "$mysqlpanelinput" == "6" ]; then showUser; fi;
	
	if [ "$mysqlpanelinput" == "exit" ]; then exit ; fi;
}


initMenu() {
	
	printTitle ${LBLUE} "Reece's Control Panel"

    while true; do 
        printf "\n${NC}"
		printf "========================== (( 'ctrl + c' anywhere to escape ))\n"
		printf "[1] Console\n"
        printf "[2] LIST running Servers\n"
		printf "[3] START-ALL Servers\n"
		printf "[port] Fix Broken Sever Port\n"
		printf "\n[ADMIN] Admin Functions\n"
		printf "[DB] Database Functions\n"
		
		printf "\nCP> "
        
        read userinput
		printf "\n===========================\n"
		
		if [ "$userinput" == "1" ]; then console ; fi;
		if [ "$userinput" == "2" ]; then printf "\n$(screen -ls)\n" ; fi;
		if [ "$userinput" == "3" ]; then startAllServers ; fi;
		if [ "$userinput" == "port" ]; then fixPort ; fi;
		
		if [ "$userinput" == "ADMIN" ]; then adminPanelMenu ; fi;
		if [ "$userinput" == "DB" ]; then databasepanel; fi;
		
		if [ "$userinput" == "exit" ]; then exit ; fi;
		

    done
}

# If arguments were given. API basically
if [ -n "$1" ]; then 
    if [ "$1" == "startall" ]; then startAllServers && exit; fi
	if [ "$1" == "reboot" ]; then serverReboot $2 && exit; fi
	
	exit # I guess I exit?
fi


# Call the Initial Menu if no arguments were given
colors
initMenu
