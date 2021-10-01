#!/bin/bash
# © 2021 Reece W. <reecepbcups@gmail.com> | Reece#3370
# MC Console Panel | Debian 9, 10 & Ubuntu Tested

SERVER_INFO_FILE_LOC="/root/server/server_info.sh"

# -= To Do =- 
# test new firewallBlockProxyPort

# add this for PORT ALREADY BOUND, then kill that java instance upon reading log file
# https://unix.stackexchange.com/questions/12075/best-way-to-follow-a-log-and-execute-a-command-when-some-text-appears-in-the-log

# ----------------
dos2unix --quiet $SERVER_INFO_FILE_LOC && source $SERVER_INFO_FILE_LOC


# Server Functions
is_running() {	
	local value=0;
	if screen -ls | grep -q $1; then
		value=1; # online
	fi
	return $value;
}
sendServerCommand() {
	is_running $1
	isItRunning=$? # return of previous command
	
    if [ "$isItRunning" == "1" ]; then
        screen -r $1 -X stuff "${2}\015"
    else
		if [ -z $3 ] && [ "$3" == "ouput" ]; then
			echo -e "${RED}[X] $1 is offline."
		fi
    fi
}

# deprecated
getServerPort() { # could make splitValues function or something
	IFS='='
	read -ra ADDR <<< "$(grep "server-port=" $SERVER_ROOT/$1/server.properties)"
	#ADDR="${ADDR[1]}" 
	echo "${ADDR[1]}";
}

# Server Access / ON/OFF
startAllServers() {
	printTitle ${LGREEN} "STARTING SERVERS"
	
    for _server in "${SERVER_FOLDERS[@]}"; do
		is_running $_server
		isItRunning=$?

		isServerOnBungee "$_server"
		isItOnTheBungee=$?
		#echo "$isItOnTheBungee" # 0 or 1

		# if server is on bungee, block port from outside connection
		if [ "$isItOnTheBungee" == 1 ]; then
			# echo "startAllServers blocking $_server port!"
			firewallBlockProxyPort "$_server"
		fi	


        if [ "$isItRunning" == "1" ]; then
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
        if [ "$isItRunning" == "1" ]; then
			printf "${GREEN}> ${_program} already running\n"  
		else
			screen -S $_program -dmS ${OTHER[$_program]}
			echo "Started $_program"
		fi
	done
}
runningServersList() {
	printf "\n$(screen -ls)\n"
}
stopAllServers() {
	
	printTitle ${RED} "STOP SERVERS"

    # Alert Users
    for server in "${PROXY_SERVERS[@]}"; do    
        sendServerCommand $server "alert &c[!] &4Servers stopping from script" "output"
    done
    sleep 3

    # Send end message + add to logs its down
    for server in "${SPIGOT_SERVERS[@]}"; do
        sendServerCommand $server "stop"
    done
    for server in "${PROXY_SERVERS[@]}"; do
        sendServerCommand $server "end"		
    done

    # Quits everything
	ALL=(${SPIGOT_SERVERS[@]} ${PROXY_SERVERS[@]} ${!OTHER[@]}); 
	# This SHOULD work given ${!OTHER[@]} makes it read the key values to quick from the screen
    for server in ${ALL[@]}; do    
		is_running $server
		isItRunning=$?
        if [ isItRunning ]; then 
			sleep 3 && screen -XS $server quit >/dev/null &
		fi		
    done
	
	for server in "${SERVER_FOLDERS[@]}"; do
		if [ -d $SERVER_ROOT/$server/logs ]; then
			echo "[!] Server stopped from script" >> $SERVER_ROOT/$server/logs/latest.log
		fi
	done
	
	printf "\n${GREEN}Following servers are closed: ${YELLOW}${ALL[@]}"
}


# DB functions ------
createDatabase() {
	printTitle ${LGREEN} "Create Database"
	printf "Database Name: "; read databse_name;
	sudo mysql -u root -e "CREATE DATABASE ${databse_name};"	
	printf "${LGREEN} \nDatabase \" ${databse_name} \" has been created!\n"
}
deleteDatabase() {
	printTitle ${LGREEN} "Delete Database"
	sudo mysql -u root -e "SHOW DATABASES;"
	printf "\nDatabase TO DELETE: "; read delete_database;
	sudo mysql -u root -e "DROP DATABASE ${delete_database};"	
	printf "${LRED} \nDatabase \" ${delete_database} \" has been deleted!\n"
}
showDatabases() {
	printTitle ${LGREEN} "Show Databases"	
	sudo mysql -u root -e "SHOW DATABASES;"		
}

createNewUser() {
	printTitle ${LGREEN} "Create User"
	printf "Users Username: "; read username;
	printf "Users Password: "; read password;
	sudo mysql -u root -e "CREATE USER ${username}@localhost IDENTIFIED BY '${password}';"
	sudo mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO ${username}@localhost; FLUSH PRIVILEGES;"		
	printf "${GREEN} \nUser \" ${username} \" has been created!\n"
}
deleteUser() {
	printTitle ${LGREEN} "Delete User"	
	sudo mysql -u root -e "select host, user, password from mysql.user;"
	printf "\nUser you want to delete: "; read delete_user;
	sudo mysql -u root -e "drop user ${delete_user}@'localhost';"
	printf "\n"	
}
showUser() {
	printTitle ${LGREEN} "Users List"	
	printf "\n"
	sudo mysql -u root -e "select host, user, password from mysql.user;"
	printf "\n"	
}
# /DB functions ------


printTitle() { # Title Creator ( printTitle ${LRED} "TITLE TEXT" )
	clear; printf "${1}"
	figlet -w 200 -f standard "${*:2}"
	printf "${NC}"
}

sendCMD() { printf "\n>>> "; while read line; do printf "\n>>> "; tmux send-keys -t TEST.1 "echo ${line}"; line=""; done; }


console(){

	printTitle ${LYELLOW} "CONSOLE"
	#echo "${BASH_SOURCE[0]}" # ${0##*/} - gets location of console script file
	
    # Loop through server array and enumerate them ( [0] SERVER1 )
    for i in "${!MISC_SERVERS[@]}"; do 
      printf "%s\t%s\n" "[$i] ${MISC_SERVERS[$i]}"
    done
    echo ""
    read consoleconnect	
    server=${MISC_SERVERS[consoleconnect]}
    clear 	
		
	# Checks if server is online or offline
	is_running $server
	isItRunning=$?	
	
	printTitle ${MAGENTA} $server
	
	statusMessage="${LRED}STATUS: OFFLINE\n"
	statusCommand="${LGREEN} -> 'start-server'\n"
	if [ "$isItRunning" == "1" ]; then
		statusMessage="${LGREEN}STATUS: ONLINE\n" 
		statusCommand="${LRED} -> 'stop-server'\n"
	fi
	printf "$statusMessage"	
    
	printf "\n${YELLOW}Commands: \n"
	printf "$statusCommand"
	printf "${RED} -> 'exit' to exit\n%.0s" {1..1}			
	printf "\n"
	printf "${YELLOW}Information: \n"
	printf "${BOLD} PORT: $(getServerPort $server) \n"
	printf "${BOLD} $(grep "MEM_HEAP=" $SERVER_ROOT/$server/start.sh) \n"
	
	
	# Output log. If Ctrl+z done it stops log (CTRL+C does not)
	# ORGINAL: tail -f $SERVER_ROOT/$server/logs/latest.log &
    tail -qF --pid=$$ --retry $SERVER_ROOT/$server/logs/latest.log &
	tailpid=$!	
	printf "${BOLD} LOG-PID: $tailpid\n\n"	
	printf "${NC}" # End of Initial Message 
	
	# TMUX TRANSITION - may not do this, just the code for if I do
	# https://www.reddit.com/r/bash/comments/mz5ovg/tail_a_file_and_prompt_for_user_inputat_the_same/
	# tmux new-session -d 'tail -F $SERVER_ROOT/$server/logs/latest.log' && tmux split-window -h 'echo "test"' && tmux -2 attach-session -d
	# tmux new-session -d '$SERVER_ROOT/$server/logs/latest.log' ';' split-window ';' while read line; do printf ">"&& tmux select-window -t:0 'say $1'; done;	
	# tmux has-session -t TEST 2>/dev/null
	# if [ $? != 0 ]; then
		# tmux new -d -s TEST 'tail -F /root/server/SKYBLOCK/logs/latest.log'
		# tmux split-window -t TEST.1 -h -p 5
	# fi
	##### tmux attach -t SERVER
	# tmux send-keys -t TEST.1 'sendCMD() { printf ">>> "; while read line; do printf ">>> "; tmux send-keys -t "$1" "${line}" & && printf "\n"; done; }' C-m
	#screen -r $server -X stuff "${line}\015" &		
	#tmux send-keys -t TEST:bash Enter;

    while read line; do
        
		if [ "$line" == "start-server" ]; then
			# cant do return statements here with the &'s
			if screen -ls | grep -q $server; then
				echo "${server} already running" >> $SERVER_ROOT/$server/logs/latest.log
			else
				cd $SERVER_ROOT/$server
				echo "${GREEN} Starting ${server} :D" 
				screen -S $server -dms ./start.sh
				cd $SERVER_ROOT
			fi
		elif [ "$line" == "stop-server" ]; then
			sendServerCommand $server "bc&4Server going down in 3 seconds..."
			echo "${RED} Server going down..."
			sendServerCommand $server "stop"
			sendServerCommand $server "end"
			sleep 6
			screen -XS $server quit >/dev/null
			echo "Server shutdown"
			initMenu "$@"; 
		elif [ "$line" == "exit" ]; then
			#kill -15 $tailpid
			killall tail			
			echo "Exiting Console, stopping .log reading" >> $SERVER_ROOT/$server/logs/latest.log 			
			initMenu "$@";	
		else
			screen -r $server -X stuff "${line}\015" &
		fi	
    done
}

# _pass_to_tmux() {
		## https://superuser.com/questions/732344/run-function-in-tmux-within-bash-script
		# _FUNC_TO_PASS="${1}"
		# _IFS_BACKUP="${IFS}"
		# IFS=$'\n'
		# for i in $(type ${_FUNC_TO_PASS} | tail -n +2); do
			# tmux send-keys "${i}" C-m
		# done 
		# IFS="${_IFS_BACKUP}"
	# }

# used for firewall
parse_yaml() { 
   # https://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

isServerOnBungee() {
	# Checks if server is on bungee with spigot bungee=true.
	# if so, return 1 - will iptables block it on startup for security
	
	FILE="$SERVER_ROOT/$1/spigot.yml"
	
	if [ ! -f "$FILE" ]; then
		#echo "File not found!"
		return 0		
	elif parse_yaml "$FILE" | grep -q "settings_bungeecord=\"true\""; then
		#echo "$1 is on bungee, block port"
		return 1 # is on proxy
	else
		#echo "$1 allow port"
		return 0
	fi
}






# Networking
fixPort() { 
	# could automate this by checking latest log, 
	# tail -f file | grep --line-buffered "FAILED TO BIND PORT"
	printTitle ${MAGENTA} "Fix Bound Port"
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
	# change to UFW eventually
    echo -e "\nAre you sure you want to reset the firewall back to all OPEN? (Y/<N>)"
    read firewall_check

    if [ "$firewall_check" == "Y" ]; then
	
		# Clears all firewall rules and allow ALL connections
        iptables -F; iptables -X
		iptables -t nat -F; iptables -t nat -X
		iptables -t mangle -F; iptables -t mangle -X
		iptables -P INPUT ACCEPT; iptables -P OUTPUT ACCEPT; iptables -P FORWARD ACCEPT
		
		#Allow Loobback connections
		iptables -A INPUT -i lo -j ACCEPT; iptables -A OUTPUT -o lo -j ACCEPT
	
		# ALLOW SSH
		iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
		iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT		
		echo "Done!"
    fi

}

firewallBlockProxyPort() { 
	# argument: server (ex, SKYBLOCK)
	# if server is used on proxy instance, deny connections from outside.
	
	IFS='='
	read -ra ADDR <<< "$(grep "server-port=" $SERVER_ROOT/$1/server.properties)"
	
	BUNGEE_HOST_IPS=${BUNGEE_HOST_IPS// /,}
	
	# host IPS found in server_info.sh. If not found, default 127.0.0.1
	[ -z "$BUNGEE_HOST_IPS" ] || BUNGEE_HOST_IPS="127.0.0.1"
	
	#iptables -A INPUT -p tcp -m multiport --dports ${ADDR[1]} -s $BUNGEE_HOST_IPS -j ACCEPT # should this be drop?
	echo "Would drop port ${ADDR[1]} here from $BUNGEE_HOST_IPS"
}

applyNewFirewallRules() {
	printf "\nAre you sure you want to set the firewall settings? (Y/<N>)"
    read set_firewall_check
    if [ "$set_firewall_check" == "Y" ]; then
        echo ""
	else
		echo "Not setting firewall..."
		return 0
    fi

	#apt-get install iptables
    set -e # not sure if this messes with things

    # Check if we are root
    [ $EUID == 0 ] || { echo "This script must be run as root"; exit 0; }

    # Support both space and comma delimited configuration strings
    ALLOW_PORTS=${ALLOW_PORTS// /,}
    BUNGEE_HOST_IPS=${BUNGEE_HOST_IPS// /,}
    # BUNGEE_BACKEND_PORTS=${BUNGEE_BACKEND_PORTS// /,} - depricated

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

    # Firewall our BungeeCord network (Won't run if $BUNGEE_HOST_IPS is empty) - moved from server info 
    # [ -z "$BUNGEE_HOST_IPS" ] || iptables -A INPUT -p tcp -m multiport --dports $BUNGEE_BACKEND_PORTS -s $BUNGEE_HOST_IPS -j ACCEPT

	# Loop through all servers here and check if bungee or not?

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

    echo "Server Name (ex. SKYBLOCK)"; read _server_name
    echo "Paper Spigot Version (ex. 1.8.8)"; read VERSION
    echo "RAM (ex. 512M or 2G)"; read RAM
    echo "Port (ex. 25570)"; read PORT
    echo ""
    echo "[!] Leave the following blank for defaults <default>"
    echo "Nether? (true/<false>)"; read NETHER
	echo "Bungee? (y/<n>)"; read BUNGEE
    echo "Max Players: (<20>)"; read MAX_PLAYERS
    echo "View Distance (<4>)"; read SERVER_VIEW_DISTANCE

    SERVER_DIR=$SERVER_ROOT/$_server_name

    # Double Checks its not already a server first before continuing
    if [[ -d "${SERVER_DIR}" ]] ; then echo "Dir ${SERVER_DIR} exists. exit." && exit ; fi

    # Move to DIR and download paper spigot jar
    mkdir $SERVER_DIR && cd $SERVER_DIR
	# wget -bqc https://papermc.io/api/v1/paper/${VERSION}/latest/download -O Paper-${VERSION}.jar # BACKGROUND
    wget --quiet --show-progress https://papermc.io/api/v1/paper/${VERSION}/latest/download -O Paper-${VERSION}.jar


    # Start.sh script - Credit to MegaPvP for insperation here
    echo "#!/bin/sh
# Reecepbcups - start.sh script for servers. 
# Use the 1st JAVA_ARGS option (long) if you use more than 12GB of ram on the server instance
            
MEM_HEAP=\"${RAM}\"
JAR_FILE=\"Paper-${VERSION}.jar\"
#JAVA_ARGS=\"-Dfile.encoding=utf-8 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=40 -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:-OmitStackTraceInFastThrow -XX:+AlwaysPreTouch  -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=8 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=true -Daikars.new.flags=true -jar\"
JAVA_ARGS=\"-Dfile.encoding=utf-8 -jar\"

while true; do
	java -Xms\$MEM_HEAP -Xmx\$MEM_HEAP \$JAVA_ARGS \$JAR_FILE nogui
	echo \"Restarting server in 5 seconds\"
	sleep 4
	echo \"Restarting...\"
	sleep 1
done" >> start.sh && chmod +x start.sh && dos2unix --quiet start.sh


    ## Server.properties file  default values
	#if [[ -z  ]]; then ; fi;
    if [[ -z "$MAX_PLAYERS" ]]; then MAX_PLAYERS=20; fi;
    if [[ -z "$PORT" ]]; then PORT=25599; fi;
    if [[ -z "$SERVER_VIEW_DISTANCE" ]]; then SERVER_VIEW_DISTANCE=4; fi;
    if [[ -z "$NETHER" ]]; then NETHER=false; fi;
    if [[ -z "$BUNGEE" ]]; then BUNGEE="n" ; fi;
    
	# If bungee, set spigot.yml file to correct bungee settings
	if [ "$BUNGEE" == "y" ]; then 
		ONLINEMODE=false && NETWORKCOMPRESSION=-1
		echo "settings:
  bungeecord: true
  restart-on-crash: false
  restart-script: ./DoneByStartScript.sh" >> spigot.yml
	else
		ONLINEMODE=true && NETWORKCOMPRESSION=256
	fi

	# Adds default values to the server properties. 
	# If vars set during input, value is set to theirs
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
	clear
	printf "${LGREEN} Machine Setup Installer ${WHITE}\n"
	printf "Make sure this file is in the ${LGREEN}'/root/server'${WHITE} directory!\n";
	printf "Are you sure you want to install the MC Panel? (${LGREEN}Y/${LRED}n${WHITE}): "; read answer
	
	if [ "$answer" == "Y" ]; then
		apt-get update --allow-releaseinfo-change
		
		# Append user to sudo file for no password request. Depends on debian host ISO
		echo "root ALL=(ALL) ALL" >> /etc/sudoers
		echo "sudo ALL=(ALL) ALL" >> /etc/sudoers
		
		echo "alias console='/root/server/Console-v*.sh'" >> /root/.bashrc
		source /root/.bashrc
		
		# Add NodeJS keys
		apt-get --yes --force-yes install curl software-properties-common
		curl -sL https://deb.nodesource.com/setup_12.x | bash -
		
		# Install other programs
		apt-get --yes --force-yes install build-essential sudo zip unzip lsof dos2unix nginx screen htop glances 
		apt-get --yes --force-yes install nodejs cpufrequtils figlet redis default-jre sysstat slurm speedometer
		cpufreq-set -r -g performance	
		timedatectl set-timezone America/Chicago
		
		# Java 11 - doesnt work for my 1.8 MC
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
		
	# server_info.sh file
		echo '# ____
#/ ___|  ___ _ ____   _____ _ __ ___
#\___ \ / _ \  __\ \ / / _ \  __/ __|
# ___) |  __/ |   \ V /  __/ |  \__ \
#|____/ \___|_|    \_/ \___|_|  |___/
#
export SERVER_ROOT="/root/server"
export BACKUP_DIRECTORY="/root/BACKUPS/$(date +%m-%d-%Y_[Hour_%H])"

# Stop All
export PROXY_SERVERS=("BUNGEE"); 
export SPIGOT_SERVERS=("HUB" "MAIN");

# Start All Servers list
export SERVER_FOLDERS=("${PROXY_SERVERS[@]}" "${SPIGOT_SERVERS[@]}"); 

# other programs to start with startall and stopall
#export declare -A OTHER=( ["DISCORD"]="node /root/server/DISCORD_BOT/src/index.js" ) # start all
# Extra MC servers you do not want to have in start all, but to pop up and tear down temp.
export MISC_SERVERS=(${SERVER_FOLDERS[@]} "MODDED"); 

# _____ _                        _ _
#|  ___(_)_ __ _____      ____ _| | |
#| |_  | |  __/ _ \ \ /\ / / _` | | |
#|  _| | | | |  __/\ V  V / (_| | | |
#|_|   |_|_|  \___| \_/\_/ \__,_|_|_| 
#
export ALLOW_PORTS="21 22 80 443 1337 25565"

# Firewall (bungeecord network)
export BUNGEE_HOST_IPS="127.0.0.1"
export BUNGEE_BACKEND_PORTS="25570 30000" # REMOVED

#__        __   _       ____  _                _
#\ \      / /__| |__   / ___|| |__   ___  _ __| |_ _ __   ___ _ __
# \ \ /\ / / _ \  _ \  \___ \|  _ \ / _ \|  __| __|  _ \ / _ \  __|
#  \ V  V /  __/ |_) |  ___) | | | | (_) | |  | |_| | | |  __/ |
#   \_/\_/ \___|_.__/  |____/|_| |_|\___/|_|   \__|_| |_|\___|_|
#   
export SERVER_WEBSITE=/var/www/html/l
export WEBSITE_DOMAIN="reece.sh/l/"
' >> $SERVER_INFO_FILE_LOC
		source $SERVER_INFO_FILE_LOC
		mkdir $BACKUP_DIRECTORY
		
		
		echo -e "\nInstall backup script? (2am cron job) (Y/N)"; read installbackupscript;
		if [ "$installbackupscript" == "Y" ]; then
			echo '#!/bin/bash
# Reece#3370 Backup Script for Linux. 
# REQUIRES `zip`
# ____             _                  ____            _       _
#| __ )  __ _  ___| | ___   _ _ __   / ___|  ___ _ __(_)_ __ | |_
#|  _ \ / _` |/ __| |/ / | | |  _ \  \___ \ / __|  __| |  _ \| __|
#| |_) | (_| | (__|   <| |_| | |_) |  ___) | (__| |  | | |_) | |_
#|____/ \__,_|\___|_|\_\\__,_| .__/  |____/ \___|_|  |_| .__/ \__|
#                            |_|                       |_|
#
# SERVER_ROOT & BACKUP_DIRECTORY
dos2unix /root/server/server_info.sh && source /root/server/server_info.sh
MYSQL_USED="False"

function backup {
	mkdir -p $BACKUP_DIRECTORY
	
	ScriptName=$1; filename="$(date +%m-%d-%Y)-$ScriptName"
	location=$2; fileTypes=$3 # set to "*" for all
	thingstoignore=${*:4}
	
	screen -dmS $ScriptName bash	
	screen -S $ScriptName -X stuff "cd \"$location\"\015"
	screen -S $ScriptName -X stuff "pwd \015" 
	screen -S $ScriptName -X stuff "zip --symlinks -r $filename $fileTypes -x $thingstoignore\015"
	screen -S $ScriptName -X stuff "mv ${filename}.zip $BACKUP_DIRECTORY\015"	
	screen -S $ScriptName -X stuff "sleep 1\015"
	screen -S $ScriptName -X stuff "exit\015"
	echo "$location $filename to $BACKUP_DIRECTORY" >> /root/backup_logs.txt
}

# Areas to ignore - leave space at end
USELESS="usercache.json /cache/* /logs/* crash-reports/* "
PLAYER_DATA="/world/playerdata/* /world/stats/* /plugins/Essentials/userdata/* /world/advancements/* "

SKIN_RESTORER="/plugins/SkinsRestorer/Skins/* /plugins/SkinsRestorer/Players/* "
WORLD_EDIT="/plugins/FastAsyncWorldEdit/history/* /plugins/FastAsyncWorldEdit/clipboard/* "
DYNMAP="/plugins/dynmap/* "
NO_PLUGINS="/plugins/* "
NO_SKYBLOCK_WORLDS="/ASkyBlock/* /ASkyBlock_nether/* "

#--------------------------------------------------------------------------------------------
# Servers - [!] DO NOT END WITH A /

## Scripts backup
FILENAME="SCRIPT-Backup"
LOCATION="$SERVER_ROOT"
FILETYPES="*.sh"
FILES_TO_IGNORE="nothing" 
backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

## Bungee backup
FILENAME="BUNGEE-Backup"
LOCATION="$SERVER_ROOT/BUNGEE"
FILETYPES="*"
FILES_TO_IGNORE="${USELESS[@]} ${SKIN_RESTORER[@]}" 
backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

## HUB backup
FILENAME="HUB-Backup"
LOCATION="$SERVER_ROOT/HUB"
FILETYPES="*"
FILES_TO_IGNORE="${USELESS[@]} ${SKIN_RESTORER[@]} ${NO_PLAYER_DATA[@]}" 
backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

# Skyblock backup
FILENAME="SKYBLOCK-Backup"
LOCATION="$SERVER_ROOT/SKYBLOCK"
FILETYPES="*"
FILES_TO_IGNORE="${USELESS[@]} ${SKIN_RESTORER[@]} ${WORLD_EDIT[@]} ${DYNMAP[@]}" 
backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

## Website backup
FILENAME="WEBSITE-Backup"
LOCATION="/var/www/html"
FILETYPES="*"
FILES_TO_IGNORE="nothing" 
backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

#--------------------------------------------------------------------------------------------
# __  __       ____   ___  _
#|  \/  |_   _/ ___| / _ \| |
#| |\/| | | | \___ \| | | | |
#| |  | | |_| |___) | |_| | |___
#|_|  |_|\__, |____/ \__\_\_____|
#        |___/
if [ "$MYSQL_USED" != "False" ]; then
	mysqldump --all-databases > $BACKUP_DIRECTORY/sql_backup.sql
	# mysqldump --databases luckperms > $BACKUP_DIRECTORY/luckperms.sql
	# mysqldump --databases litebans > $BACKUP_DIRECTORY/litebans.sql
fi' >> BetterBackupScript-v12_1.sh

		# Every day at 2am - /root/server/BetterBackupScript*.sh
		(crontab -l 2>/dev/null; echo "0 0 * * * /root/server/BetterBackupScript*.sh") | crontab -
		
		fi
		
		echo -e "\nInstall Database? (MariaDB) (Y/N)"; read database
		if [ "$database" == "Y" ]; then
			sudo apt-get install mariadb-server mariadb-client
			echo " "
			mysql_secure_installation	
		fi
		
		echo -e "\nApply Current Firewall Rules? (double check server_info) (Y/N)"; read checkfirewall
		if [ "$checkfirewall" == "Y" ]; then
			applyNewFirewallRules
		fi
		
		echo "DONE"
	fi
}

newUserSetup() {  
  printTitle ${LGREEN} "User Creator"

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
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 5 minutes\015"; sleep 4m
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 1 minute\015"; sleep 30s
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 30 seconds\015"; sleep 27s
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 3 seconds\015"; sleep 1s
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 2 seconds\015"; sleep 1s
	sendServerCommand $SERVER "broadcast &c[!] Server Restart in 1 second\015"; sleep 1s
	sendServerCommand $SERVER "broadcast &c[!] Restarting...\015"; sleep 3s
	sendServerCommand $SERVER "stop\015"

	echo "$(date) REBOOT FROM SCRIPT" >> $SERVER_ROOT/$SERVER/logs/${SERVER}-Reboot.log
}

dailyServerRebootSetup() {
	printTitle ${LGREEN} "Daily Reboot Setup"
	echo "Time of day to reboot (24 hour, ex: 13): "; read timeofDay;
	echo "Server Name (caseSensisitve) "; read serverName;
	FINAL_STR="0 $timeofDay * * * console reboot $serverName";
	
	echo "Is the following correct? (Y/n)"
	echo "$FINAL_STR"; read isFinalStrCorrect;
	
	if [ "$isFinalStrCorrect" == "Y" ]; then
		(crontab -l 2>/dev/null; echo "$FINAL_STR") | crontab -
		echo "Added $serverName to reboot at $timeofDay daily"
	fi
}



colors() { # COLOR CODES - https://misc.flogisoft.com/bash/tip_colors_and_formatting
	RED='\e[31m'; 		LRED='\e[91m';		GREEN='\e[32m'; 	LGREEN='\e[92m'; 	YELLOW='\e[33m'; 	LYELLOW='\e[93m'; 	WHITE='\e[0;39m';	MAGENTA='\e[35m';
	BLUE='\e[34m'; 		LBLUE='\e[94m';		CYAN='\e[36m'; 		NC='\e[0m'; 		BOLD='\e[1m'; 		UNDERLINE='\e[4m'; 	BLINKING='\e[5m'	
}


# ADMIN DEBUGGINS
changeJavaVersion() {
  sudo update-alternatives --config java
}  
killalljava() {
	kilall -9 java;
	echo "Killed all java virtual machines on this machine instance"
}
viewNetworkStats() {
	printf "ctrl + c to exit"
	speedometer -l -r eth0 -t eth0 -m $(( 1024 * 1024 * 3 / 2 ))
}
viewRAMUsage() {
	printf "RAM usage in GB:\n"; free -g -l
	free -t | awk 'NR == 2 {printf("\n\nCurrent Memory Utilization is : %.2f%\n\n"), $3/$2*100}'
}
viewStorageusage() {
	iostat && df -h
}
# END OF ADMIN DEBUGGING


# PANELS
adminPanelMenu() {
	printTitle ${LRED} "ADMIN PANEL"
	
	declare -A adminPanelDict=(
		 ['1']=newServerInstance
		 ['2']=stopAllServers
		 ['3']=dailyServerRebootSetup
		 
		 ['WEB']=linkShortener							['w']=linkShortener					['web']=linkShortener
		 ['RESET-FIREWALL']=resetFirewall	
		 ['CHANGE-JAVA-VERSION']=changeJavaVersion		
		 ['KILL-ALL-JAVA']=killalljava					
		 ['APPLY-FIREWALL']=applyNewFirewallRules		
			 
		 ['STORAGE']=viewStorageusage					['storage']=viewStorageusage		['s']=viewStorageusage
		 ['NETWORK']=viewNetworkStats					['network']=viewNetworkStats		['n']=viewNetworkStats
		 ['RAM']=viewRAMUsage							['ram']=viewRAMUsage				['r']=viewRAMUsage
		 
		 ['NEW-USER']=newUserSetup
		 ['NEW-DB']=newDatabase
		 
		 # ['ScrConn']=screenCommands "Join"
		 # ['ScrQuit']=screenCommands "Quit"
		 # ['ScrNew']=screenCommands "New"
		 ['CP']=initMenu
		 ['exit']=exit
	)
	
	while true; do
		printf "\n${LRED}"
		echo "[1] Make New Server"		
		echo "[2] STOP-ALL Servers"
		echo "[3] Daily Reboot Setup"
		#echo " "
		# echo "[ScrConn] Connect to Screen"
		# echo "[ScrQuit] Quit Screen"
		# echo "[ScrNew]  New Screen"
		echo " "
		echo "[RESET-FIREWALL] Reset Firewall to OPEN"
		echo "[APPLY-FIREWALL] Apply/Restore Firewall"
		echo " "
		echo "[STORAGE] Show IO speeds"
		echo "[NETWORK] Live Network Chart"
		echo "[RAM] RAM Usage"
		echo " "
		echo "[CHANGE-JAVA-VERSION] changes default java version"
		echo "[KILL-ALL-JAVA] kills all JVM instances"
		echo " "
		echo "[WEB] Link Shortener"
		echo "[NEW-USER] Create a new user"
		echo "[NEW-DB] Create a new Database"
		echo "[CP] back to control panel"
		
		printf "\n\n${WHITE}ACP> "

		read admininput
		${adminPanelDict[$admininput]}
		
		printf "===========================\n"
		
	done
}

databasepanel(){
	printTitle ${LGREEN} "DATABASE PANEL"
	
	declare -A dbPanelDict=(
		 ['1']=createDatabase	 
		 ['2']=deleteDatabase	 
		 ['3']=showDatabases	 
		 ['4']=createNewUser	 
		 ['5']=deleteUser	 
		 ['6']=showUser	 
		 ['exit']=exit 
	)
	
	printf "\n${LGREEN}"
	echo "[1] Create DB"
	echo "[2] Delete DB"
	echo "[3] Show All"
	echo ""
	echo "[4] Create User"
	echo "[5] Delete User"
	echo "[6] Show Users"		
	printf "\n${WHITE}DATABASE> "
	
	read mysqlpanelinput
	${dbPanelDict[$mysqlpanelinput]}
	
}

initMenu() {

	

	# If serverinfo not found, request new machine setup.
	if [ ! -f $SERVER_INFO_FILE_LOC ]; then
		echo "server.info file not found... Fresh machine install"
		newMachineSetup
	fi
	
	printTitle ${LBLUE} "Control Panel"
	
	declare -A initMenuDict=(
		 ['1']=console	 
		 ['2']=runningServersList 
		 ['3']=startAllServers	 
		 ['port']=fixPort	 		 ['p']=fixPort
		 ['ADMIN']=adminPanelMenu	 ['a']=adminPanelMenu	 ['A']=adminPanelMenu	
		 ['DB']=databasepanel	 	 ['db']=databasepanel	 ['d']=databasepanel	['D']=databasepanel
		 ['exit']=exit	 			 ['e']=exit
	)

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
		${initMenuDict[$userinput]}
		printf "\n===========================\n"			
    done
}
# END OF PANELS

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

	echo "<html><head><title>Link Redirect | $URL</title></head>
<body><script>
window.location.replace('$URL');
</script></body></html>" >> index.html

	echo -e "\n\n ${WEBSITE_DOMAIN}${FOLDER_LINK} >> $URL"

	fi
}

# CLI arguments
if [ -n "$1" ]; then 
	# move to array?
    if [ "$1" == "startall" ]; then startAllServers && exit; fi
	if [ "$1" == "reboot" ]; then serverReboot $2 && exit; fi
	if [ "$1" == "test" ]; then echo "testing CLI args$1" && exit; fi
	exit
fi


# Call the Initial Menu if no arguments were given
colors
initMenu