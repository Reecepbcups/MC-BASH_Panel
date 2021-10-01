#!/bin/bash

echo "---------------------------"
echo "--=  Reseting Server  =--"
echo "---------------------------"

# ROOT SERVER FOLDER DIR (ex. /servers/skyblock)
ROOT_DIR="/root/server/SKYBLOCK"
SKYBLOCK_CORE="Superior" # "Superior" or "ASkyBlock"

DEBUG_MODE="TRUE" # TRUE / FALSE

# end of config


printf "\nYou want to reset $ROOT_DIR ??"; read answer
if [ "$answer" = "yes" ]; then
	clear
	echo "Reseting $ROOT_DIR... Ctrl+C to stop...";sleep 3
else
	exit
fi


removeDir() {
	location=$1
	if [ -d "$location" ]; then
	
	    if [[ "$DEBUG_MODE" != "TRUE" ]]; then
			rm -r $location
			echo "Removed $location"
		else
		    echo "DIR DEBUG $location"
		fi
		
	else
		echo "$location does not seem to be a folder !!!"
	fi
}

removeFile() {
	location=$1
	if [ -f "$location" ] ; then
	
	    if [[ "$DEBUG_MODE" != "TRUE" ]]; then
			rm "$location"
			echo "Removed $location"
		else
		    echo "FILE DEBUG $location"
		fi
	else
		echo "$location does not seem to be a folder !!!"
	fi
}

removeThenTouch() {
	file=$1
	if [ -f "$file" ]; then
		rm $file && touch $file
	else
		echo "$file does not exsist"
	fi
}

# World Data
removeFile "$ROOT_DIR/usercache.json" 
removeDir "$ROOT_DIR/logs/" 
removeDir "$ROOT_DIR/cache/" 
removeDir "$ROOT_DIR/Warzone/playerdata/"
removeDir "$ROOT_DIR/spawn/playerdata/"



# Skyblock Files
if [[ "$SKYBLOCK_CORE" == "Superior" ]]; then
	printf "\n[!] Deleting $ROOT_DIR/SuperiorSkyblock in 3 seconds [!]\n"
	sleep 3

	removeDir "$ROOT_DIR/SuperiorWorld"
	removeDir "$ROOT_DIR/SuperiorWorld_nether"
	removeFile "$ROOT_DIR/plugins/SuperiorSkyblock2/database.db"
 
elif ["$SKYBLOCK_CORE" == "ASkyBlock"]; then
	printf "\n[!] Deleting $ROOT_DIR/ASkyBlock in 3 seconds [!]"
	sleep 3

	removeDir "$ROOT_DIR/ASkyBlock"
	removeDir "$ROOT_DIR/ASkyBlock_nether"
	removeDir "$ROOT_DIR/plugins/ASkyBlock/players"
	removeFile "$ROOT_DIR/plugins/ASkyBlock/topten.yml"
	removeFile "$ROOT_DIR/plugins/ASkyBlock/islands.yml"
	removeFile "$ROOT_DIR/plugins/ASkyBlock/islandnames.yml"
	removeFile "$ROOT_DIR/plugins/ASkyBlock/coops.yml"
else 
	echo "$SKYBLOCK_CORE does not seem to be a correct core...."
	exit 0
fi
#echo "removed $SKYBLOCK_CORE data and world folder"


# Core Plugins --------------------------------------------

# Essentials
removeDir "$ROOT_DIR/plugins/Essentials/userdata/" 
# AdvancedEnchantments
removeFile "$ROOT_DIR/plugins/AdvancedEnchantments/pdata.yml"
# BuildersWand
removeDir "$ROOT_DIR/plugins/BuildersWand/storage/"
#Buycraft Cache
removeDir "$ROOT_DIR/plugins/BuycraftX/cache/"
# AuctionHouse
removeThenTouch "$ROOT_DIR/plugins/CrazyAuctions/Data.yml"

#Mobcoins
removeFile "$ROOT_DIR/plugins/SuperMobCoins/profiles.yml"

# Player Vaults
#removeDir "$ROOT_DIR/plugins/PlayerVaults/uuidvaults/"
removeDir "$ROOT_DIR/plugins/PlayerVaults/base64vaults/"


# Boosters
removeFile "$ROOT_DIR/plugins/CloudBoosters/data.yml"

#ServerTools
removeDir "$ROOT_DIR/plugins/ServerTools/DATA/"

#VoidChest
removeDir "$ROOT_DIR/plugins/VoidChest/PlayerData/"

#FantasyAxes
removeFile "$ROOT_DIR/plugins/FantasyAxes/economy.yml"

# TAB
removeFile "$ROOT_DIR/plugins/TAB/errors.txt"

#Crates - keys
#removeFile "$ROOT_DIR/plugins/CrazyCrates/data.yml"

#Multiverse invs
#removeDir "$ROOT_DIR/plugins/Multiverse-Inventories/players/"
#removeDir "$ROOT_DIR/plugins/Multiverse-Inventories/worlds/"

# Spawners
removeFile "$ROOT_DIR/plugins/xSpawners/spawners.json"

# Reece Custom things ---------------------------------------------------

# Cacts Collectors
removeFile "$ROOT_DIR/plugins/Collector/BlockData.yml"
removeFile "$ROOT_DIR/plugins/Collector/Economy.yml"
removeFile "$ROOT_DIR/plugins/Collector/OpenedCollectorCache.yml"
#removeFile "$ROOT_DIR/plugins/Collector/CactusQuest.yml"


# other
echo " "
echo "[!] MAKE SURE TO LUCKPERMS BULKUPDATE . REMOVE TEMP RANKS / SKITS (__permsToReset)"
echo "[!] MAKE SURE TO LUCKPERMS BULKUPDATE . REMOVE TEMP RANKS / SKITS (__permsToReset)"
echo "[!] MAKE SURE TO LUCKPERMS BULKUPDATE . REMOVE TEMP RANKS / SKITS (__permsToReset)"













