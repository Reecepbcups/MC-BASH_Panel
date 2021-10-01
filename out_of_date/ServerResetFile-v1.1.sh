#!/bin/bash

# To Do
# Add ability to ls through ROOT_DIR/plugins and see which we have ability to reset

echo "---------------------------"
echo "--=  Reseting Server  =--"
echo "---------------------------"

# FILE="Location of where the server is"
# THIS HAS NOT BEEN TESTED YET WITH NEW CHANGES. DOUBLE CHECK
ROOT_DIR="/root/server/HUB"

printf "What server do you want to reset?"; read server
PARENT_DIR="$ROOT_DIR $server"

printf "\nYou want to reset $PARENT_DIR ??"; read answer
if [ "$answer" = "yes" ]; then
	clear
	echo "Reseting $PARENT_DIR... Ctrl+C to stop...";sleep 3
else
	exit
fi


removeDir () {
	location=$1
	if [ -d "$location" ]; then
		rm -rf $location
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
}

# World Data
rm "$PARENT_DIR/usercache.json" 
rm "$PARENT_DIR/logs/*.log.gz" 
rm "$PARENT_DIR/world/playerdata/*.dat" 
rm "$PARENT_DIR/world/stats*.json"



# ASkyBlock Files
printf "\n[!] Deleting $FILE/ASkyBlock in 3 seconds [!]"; sleep 3

removeDir "$FILE/ASkyBlock"
removeDir "$FILE/ASkyBlock_nether"
removeDir "$FILE/plugins/ASkyBlock/players"

rm "$FILE/plugins/ASkyBlock/islands.yml" 
rm "$FILE/plugins/ASkyBlock/messages.yml" 
rm "$FILE/plugins/ASkyBlock/topten.yml" 

echo "removed ASkyblock world folder & nether"

# -= Superior Files =-
#removeDir "$ROOT_DIR/SuperiorWorld"
#removeDir "$ROOT_DIR/SuperiorWorld_nether"
#rm "$ROOT_DIR/plugins/SuperiorSkyblock2/database.db"


# Core Plugins --------------------------------------------

# Essentials
rm "$FILE/plugins/Essentials/userdata/*.yml" 
# Player Vaults
removeDir "$FILE/plugins/PlayerVaults/uuidvaults"

#Mobcoins
removeThenTouch "$FILE/plugins/MobCoins/Balances.yml"
removeThenTouch "$FILE/plugins/Mobcoins/Balances.yml"
removeThenTouch "$FILE/plugins/SuperMobCoins/profiles.yml"
# ChestShop
rm "$FILE/plugins/ChestShop/items.db"
rm "$FILE/plugins/ChestShop/users.db"
rm "$FILE/plugins/ChestShop/ChestShop.log"
# AuctionHouse
removeThenTouch "$FILE/plugins/CrazyAuctions/Data.yml"
# PlayTimeRewards
removeThenTouch "$FILE/plugins/PlaytimeRewards/playerData.yml"
# MCMMO
rm "$FILE/plugins/mcMMO/flatfile/mcmmo.users" 
rm "$FILE/plugins/mcMMO/flatfile/parties.yml"
rm "$FILE/plugins/mcMMO/backup/*.zip"
touch "$FILE/plugins/mcMMO/flatfile/mcmmo.users"
# SpaceChestSell
rm "$FILE/plugins/SpaceChestSell/signs.bin" 
#Buycraft Cache
removeDir "$FILE/plugins/BuycraftX/cache"
# LiteBans
rm "$FILE/plugins/LiteBans/litebans.mv.db"
# No Cheat Plus
rm "$FILE/plugins/NoCheatPlus/*.log"
# Quests
rm "$FILE/plugins/Quests/playerdata/*.yml"
# TAB
rm "$FILE/plugins/TAB/errors.txt"
# TokenManager
rm "$FILE/plugins/TokenManager/data.yml"

# COSMETICS ----------------------------------------------
# UltraCosmetics
rm "$FILE/plugins/UltraCosmetics/data/*.yml"
# Deluxe Tags
rm "$FILE/plugins/DeluxeTags/userdata/player_tags.yml" 
#ChatColor
rm "$FILE/plugins/ChatColor/ChatColor.yml"


# OTHER ------------------------------------------------------

# CoinFlip
removeThenTouch "$FILE/plugins/CoinFlipper/stats.yml"
removeThenTouch "$FILE/plugins/CoinFlipper/bets.yml"
removeThenTouch "$FILE/plugins/CoinFlipper/stats.db"
# ItemFilter
rm "$FILE/plugins/ItemFilter/player-data/*.yml"
# AAC
rm "$FILE/plugins/AAC/logs/*.log"
# AdvasncedAchievements
rm "$FILE/plugins/AdvancedAchievements/*.db"
# BuildersWand
rm "$FILE/plugins/BuildersWand/storage/ *.yml"
# Scyther - MCMarket Hoes Plugin
rm "$FILE/plugins/Scyther/data.yml"

#V Vote - GAListener
rm "$FILE/plugins/GAListener/GAL.db"
# SuperbVote
rm "$FILE/plugins/SuperbVote/votes.json"
rm "$FILE/plugins/SuperbVote/queued_votes.json"

# Reece Custom things ---------------------------------------------------

# VaccumChestSeller - Cactus Edition
rm "$ROOT_DIR/plugins/VacuumChestSeller/User Data Chest.yml"
rm "$ROOT_DIR/plugins/VacuumChestSeller/Recent Storage Interaction.yml"
rm "$ROOT_DIR/plugins/VacuumChestSeller/VCS To Offline.yml"

# ReecesMobPoints
#echo "[!] REMOVE REECEMOBPOINTS CONFIG.YML PLAYERS in $FILE/plugins/ReecesMobPoints"


# other
echo "[!] MAKE SURE TO LUCKPERMS BULKUPDATE . Something like this VVVVVVVVVVV"
echo '/lp bulkupdate users delete "permission ~~ %.gkit" "server == skyblock"'










