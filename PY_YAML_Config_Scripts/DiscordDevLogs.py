#!/usr/bin/python
"""
https://discordpy.readthedocs.io/en/latest/api.html#discord.TextChannel.send
https://discordpy.readthedocs.io/en/latest/api.html#embed
"""
import time, discord
from datetime import datetime
client = discord.Client()

LOCAL = True
UPDATE_NOTES = '''
No hunger in the main Skyblock world
Fixed Whitelist Issues for perms vs command
Lowered store prices (Not Final, still have to go over with Phasha) 
Switched to new Player vault system
Lowered keys given from crates / mcrates
Balanced Crates & Envoys out
StackablePotions throwing patch 
Fixed Bucket Stacking issue with transparent blocks
Changed DisabledWorlds commands getting cleared by Java GC
New Koth Crate + Key
Setup new Koth + Schedule & placeholders
Cactus Collecors are now in Mobcoins & /features
TODO: Fix Collectors on loadup null, add payments to other teams, Configured Bosses to auto run
'''

# Local Channel
LOCAL_DISC = 844041116285927444
FANTASY = 000000000000000




# ======= BOT START =======
COLORS_DICT = {"pink": 0xff08ff, "blue": 0x2fffed}

@client.event
async def on_message(message):
    # Do not allow bot to msg itself accidently.
    if message.author == client.user:
        return

    if message.content.startswith('$logout'):
        await client.logout()

    if message.content.startswith('$update'):
        if len(message.content.split(" ")) < 3: 
            await message.channel.send("Incorrect usage: $update <COLOR> ListOfItems")
            return

        color = message.content.split(" ")[1]
        if(color.lower() not in COLORS_DICT):
            await message.channel.send("That color does not exsist, try: " + str(COLORS_DICT.keys()))
        else:
            CHANNEL = client.get_channel(LOCAL_DISC if LOCAL else FANTASY)
            await CHANNEL.send(embed=makeEmbed(message, color))     
     

        # setChannel command? (save to text file in directory based off of guild ID)

@client.event
async def on_ready():
    print(f'Logged in {client.user.name} Bot!')


def checkForAdmin(msg): # Change this to check if author has permission admin
    if(msg.author.id == 288822117993283604):
        return True
    return False


def makeEmbed(message, color):
    #global CHANNEL

    if(checkForAdmin(message) == False):
        return

    finalLOG = ""
    #newMSG = message.content.split("\n")[1::]
    newMSG = message.content.split(" ")[2]
    #print(newMSG)
    for log in newMSG.split("\n"):
        if log.strip() == "":
            continue
        finalLOG+=f"» {log}\n"
    else:
        embedVar = discord.Embed(title="Skyblock Dev Notes", description=" ", color=COLORS_DICT[color.lower()])
        embedVar.add_field(name=datetime.today().strftime('%a, %B %d (%Y) [%I:%M] CST'), value=finalLOG, inline=False)
        return embedVar #await message.channel.send(embed=embedVar)    


# EVNT Changelogs BOT
TOKEN = "some.token" 
client.run(TOKEN)