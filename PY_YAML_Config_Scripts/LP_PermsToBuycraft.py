# LP EXPORT, edit it to be only permissions in this format
# then copy paste in. Most likely use notepad++ with bookmark lines



permissions = """"tag.*",
"Friends.FriendLimit.25",
"askyblock.island.range.400",
"askyblock.nohunger",
"chatcooldown.bypass",
"crazyauctions.sell.10",
"ctag.use",
"displayname.Emerald",
"emerald.skit",
"essentials.afk",
"essentials.kits.diamond",
"value": false,
"essentials.kits.emerald",
"essentials.nick",
"group.diamond",
"nofalldamage.use",
"playervaults.amount.10",
"prefix.1.&7[&2Emerald&7] &2",
"weight.8",
"displayname.Emerald",
"""

ignore = ["weight.", "displayname.", "tags.", "value: false"]
types = { # do not put & in the value of pair
    "essentials.kits.": "Kit ",     
    "prefix.": "Prefix ",        
    "chatcooldown.bypass": "No Chat Cooldown",        
    "ctag.use": "Custom Tag (/ctag)",        
    "essentials.nick": "Nickname (/nick)",        
    "shopguiplus.sell.hand.all": "Shop /sell handall",        
    "emerald.skit": "Unique Emerald Special Kit (/skit)", 
    "askyblock.island.range.": "Island Range ", 
    "chatcolor.": "Chatcolor: ", 
    "askyblock.island.maxhomes.": "Max Homes: ", 
    "essentials.back.ondeath": "Back On Death (/back)", 
    "essentials.back": "Back (/back)", 
    "essentials.invsee": "Inventory See (/invsee)", 
    "essentials.msgtoggle": "Message Toggle (/msgtoggle)", 
    "essentials.near": "Near Players (/near)", 
    "essentials.ptime": "Player Time (/ptime <time>)", 
    "essentials.pweather": "Player Weather (/pweather <type>)", 
    "essentials.tptoggle": "Toggle Teleport Request", 
    "group.": "All Perks from Rank: ", 
    "essentials.speed.*": "Flight Speed (/speed)", 
    "essentials.condense": "Condense Command (/condense)", 
    "essentials.ext": "Extinguish Fire (/ext)", 
    "essentials.feed": "Feed Yourself (/feed)", 
    "essentials.joinfullserver": "Join the Full Server", 
    "shopguiplus.sell.all": "Sell Inventory (/sell all)", 
    "essentials.fly": "Access to Fly (/fly)", 
    "isborder.color.": "Island Border Color: ",
    "buildersWand.storage": "Access to Wand Storage",
    "crazyauctions.sell.": "AH Max Item Sell: ",
    "essentials.compass": "/compass",
    "essentials.fix": "Access to /fix items",
    "essentials.hat": "Put blocks on your head (/hat)",
    "essentials.recipe": "View all recipes (/recipe)",
    "essentials.workbench": "Portable Crafting (/craft)",
    "item.hold": "Chat Item ( [item] )",
    "playervaults.amount.": "Player Vaults: ",
    "tools.rename": "Rename items (/rename)",
    "silkspawners.silkdrop.*": "Mine Spawners (silk touch)",
    "nickname.use": "Use /nickname in game",
    "Friends.FriendLimit.": "Max Friends: ",
    "askyblock.nohunger": "No Hunger on Skyblock",
    "chatcooldown.bypass": "Bypass Chat Cooldown",
    "crazyauctions.sell.": "Auctions Sell: ",
    "essentials.afk": "Showcase AFK Status (/afk)",
    "nofalldamage.use": "No Fall Damage",
    "askyblock.team.maxsize.": "Island Member Size: ",
    "essentials.keepxp": "Keep EXP on death",
    "essentials.speed.fly": "Faster Fly (/speed)",
    "tags.": "Tag: ",
    "": "",
}

errors = []
final = []
def replaceListItem(line):
    #global permissions

    for key in types.keys():

        if(key is ""):
            continue

        if (line not in types.keys()): #and ():
            import string
            # if the line does not end in a way which my script would not know how to do correctly
            if(len(line)> 1 and (line[-1] != "." and line[-1] != "*" and line[-1] not in string.digits)):                
                if line not in errors and excudeErrors(line):
                    errors.append(line)

        if (key in line):
            lastValue = ""
            if key[-1] == ".": # if last elem is a dot, get the final element
                lastValue = line.split(".")[-1].title()
                if(lastValue == "*"):
                    lastValue = "All"

            # removes duplicates
            newLine = types[key] + lastValue
            if(newLine not in final):
                final.append(removeColorCodes(types[key] + lastValue))
            continue

def excudeErrors(line):
    errorsToExclude = ["prefix.", "group.", "essentials.kits.", "essentials.fly.safelogin"]
    for item in errorsToExclude:
        if line.startswith(item):
            return False
    return True

def removeColorCodes(string):
    '''Removes &# colorcodes'''
    wasAndSign = False
    final = ""
    for letter in string:
        if wasAndSign:
            wasAndSign = False
            continue
        if letter is "&":
            wasAndSign = True
            continue
        final+=letter
    return final

def containedInList(permission, _list):
    #global permissions
    # if the line contains a substring from ignore, set wasIn true
    # meaning it had a sub string
    for _ignore in _list:
        if _ignore in line:
            return True
    return False        

for line in permissions.split("\n"):
    line = line.replace("\"", "")
    line = line.replace(",", "")

    if(containedInList(line, ignore)): 
        # things to ignrore
        continue
    else:
        replaceListItem(line)
    

print("""<ul style="list-style:none;padding-left:0;">""")
final.sort(key = len)
for item in final:
    print("""\t<li style="text-align:center;">"""+item+"""</li>""")
print("</ul>\n")


if(len(errors)>0):
    print("-= ERRORS =- ( not in dict) ")
    for line in errors:
        print("|",line)




