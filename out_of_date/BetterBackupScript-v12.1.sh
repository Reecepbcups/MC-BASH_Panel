#!/bin/bash
# Reecepbcups#3370 Backup Script for Linux
# ____             _                  ____            _       _
#| __ )  __ _  ___| | ___   _ _ __   / ___|  ___ _ __(_)_ __ | |_
#|  _ \ / _` |/ __| |/ / | | | '_ \  \___ \ / __| '__| | '_ \| __|
#| |_) | (_| | (__|   <| |_| | |_) |  ___) | (__| |  | | |_) | |_
#|____/ \__,_|\___|_|\_\\__,_| .__/  |____/ \___|_|  |_| .__/ \__|
#                            |_|                       |_|
#

# ADD zip --symlinks below when making backups to see if it works!

dos2unix server_info.sh && source server_info.sh
MYSQL_USED="False" # MYSQL database dump for backups



function backup {
	mkdir -p $BACKUP_DIRECTORY
	
	ScriptName=$1; filename="$(date +%m-%d-%Y)-$ScriptName"
	location=$2; fileTypes=$3 # set to "*" for all
	thingstoignore=${*:4}
	
	screen -dmS $ScriptName bash	
	screen -S $ScriptName -X stuff "cd '$location'\015"
	screen -S $ScriptName -X stuff "pwd \015" 
	screen -S $ScriptName -X stuff "zip --symlinks -r $filename $fileTypes -x $thingstoignore\015"
	screen -S $ScriptName -X stuff "mv ${filename}.zip $BACKUP_DIRECTORY\015"	
	screen -S $ScriptName -X stuff "sleep 1\015"
	screen -S $ScriptName -X stuff "exit\015"
	
}

# ____             _                     _
#| __ )  __ _  ___| | ___   _ _ __      / \   _ __ ___  __ _
#|  _ \ / _` |/ __| |/ / | | | '_ \    / _ \ | '__/ _ \/ _` |
#| |_) | (_| | (__|   <| |_| | |_) |  / ___ \| | |  __/ (_| |
#|____/ \__,_|\___|_|\_\\__,_| .__/  /_/   \_\_|  \___|\__,_|
#                            |_|

# Areas to ignore - leave space at end
USELESS="usercache.json /cache/* /logs/* crash-reports/* "
PLAYER_DATA="/world/playerdata/* /world/stats/* /plugins/Essentials/userdata/* /world/advancements/* "

SKIN_RESTORER="/plugins/SkinsRestorer/Skins/* /plugins/SkinsRestorer/Players/* "
WORLD_EDIT="/plugins/FastAsyncWorldEdit/history/* /plugins/FastAsyncWorldEdit/clipboard/* "
DYNMAP="/plugins/dynmap/* "
NO_PLUGINS="/plugins/* "
NO_SKYBLOCK_WORLDS="/ASkyBlock/* /ASkyBlock_nether/* "

#--------------------------------------------------------------------------------------------
# ____
#/ ___|  ___ _ ____   _____ _ __ ___
#\___ \ / _ \ '__\ \ / / _ \ '__/ __|
# ___) |  __/ |   \ V /  __/ |  \__ \
#|____/ \___|_|    \_/ \___|_|  |___/

# !! DO NOT END WITH A / !!!

# Scripts backup
FILENAME="SCRIPT-Backup"
LOCATION="/home/minecraft/"
FILETYPES="*.sh"
FILES_TO_IGNORE="nothing" 
backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

## Skyblock backup
#FILENAME="SKYBLOCK-Backup"
#LOCATION="$SERVER_ROOT/SKYBLOCK"
#FILETYPES="*"
#FILES_TO_IGNORE="${USELESS[@]} ${SKIN_RESTORER[@]} ${WORLD_EDIT[@]} ${DYNMAP[@]}" 
#backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

# Bungee backup
FILENAME="BUNGEE-Backup"
LOCATION="$SERVER_ROOT/BUNGEE"
FILETYPES="*"
FILES_TO_IGNORE="${USELESS[@]} ${SKIN_RESTORER[@]}" 
backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

# HUB backup
FILENAME="HUB-Backup"
LOCATION="$SERVER_ROOT/HUB"
FILETYPES="*"
FILES_TO_IGNORE="${USELESS[@]} ${SKIN_RESTORER[@]} ${NO_PLAYER_DATA[@]}" 
backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

# MAIN backup
# FILENAME="EVENT-Backup"
# LOCATION="$SERVER_ROOT/EVENT"
# FILETYPES="*"
# FILES_TO_IGNORE="${USELESS[@]} ${SKIN_RESTORER[@]} ${WORLD_EDIT[@]}" 
# backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

# Website backup
FILENAME="WEBSITE-Backup"
LOCATION="/var/www/html"
FILETYPES="*"
FILES_TO_IGNORE="nothing" 
backup $FILENAME $LOCATION "$FILETYPES" ${FILES_TO_IGNORE[@]}

# Discord
#FILENAME="DISCORD-BOT-Backup"
#LOCATION="/root/DISCORD_BOT"
#FILETYPES="*"
#FILES_TO_IGNORE="nothing"
#backup $FILENAME $LOCATION $FILETYPES ${FILES_TO_IGNORE[@]}

#--------------------------------------------------------------------------------------------
# __  __       ____   ___  _
#|  \/  |_   _/ ___| / _ \| |
#| |\/| | | | \___ \| | | | |
#| |  | | |_| |___) | |_| | |___
#|_|  |_|\__, |____/ \__\_\_____|
#        |___/
if [ "$MYSQL_USED" != "False" ]; then
	mysqldump --all-databases > $BACKUP_DIRECTORY/sql_backup.sql
fi
