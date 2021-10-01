# ____
#/ ___|  ___ _ ____   _____ _ __ ___
#\___ \ / _ \ '__\ \ / / _ \ '__/ __|
# ___) |  __/ |   \ V /  __/ |  \__ \
#|____/ \___|_|    \_/ \___|_|  |___/
#
export SERVER_ROOT="/home/minecraft/server"
export BACKUP_DIRECTORY="/home/minecraft/BACKUPS/$(date +%m-%d-%Y_[Hour_%H])"

# Stop All
export PROXY_SERVERS=("BUNGEE"); 
export SPIGOT_SERVERS=("HUB" "EVENT");

# Start All Servers list
export SERVER_FOLDERS=("${PROXY_SERVERS[@]}" "${SPIGOT_SERVERS[@]}"); 

# other programs to start with startall and stopall
export declare -A OTHER=( ["DISCORD"]="node /root/DISCORD_BOT/src/index.js" ) # start all
# Extra MC servers you do not want to have in start all, but to pop up and tear down temp.
export MISC_SERVERS=(${SERVER_FOLDERS[@]} "MODDED"); 

# _____ _                        _ _
#|  ___(_)_ __ _____      ____ _| | |
#| |_  | | '__/ _ \ \ /\ / / _` | | |
#|  _| | | | |  __/\ V  V / (_| | | |
#|_|   |_|_|  \___| \_/\_/ \__,_|_|_| 
#
export ALLOW_PORTS="21 22 80 443 1337 25565"

# Firewall (bungeecord network)
export BUNGEE_HOST_IPS="127.0.0.1" #ex. 127.0.0.1 144.202.22.135
export BUNGEE_BACKEND_PORTS="25570 30000" # block ports behind proxy. DO NOT PUT 25565!!!

#HUB - 30000
#MAIN- 25570



#__        __   _       ____  _                _
#\ \      / /__| |__   / ___|| |__   ___  _ __| |_ _ __   ___ _ __
# \ \ /\ / / _ \ '_ \  \___ \| '_ \ / _ \| '__| __| '_ \ / _ \ '__|
#  \ V  V /  __/ |_) |  ___) | | | | (_) | |  | |_| | | |  __/ |
#   \_/\_/ \___|_.__/  |____/|_| |_|\___/|_|   \__|_| |_|\___|_|
#   
export SERVER_WEBSITE=/var/www/html/l
export WEBSITE_DOMAIN="Reecepbcups.xyz/l/"
