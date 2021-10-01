
# allCommands = []
# def addToCommands(keyname):
#     global allCommands
#     allCommands.append(f"/vouchers give {keyname} 1 %player%")
#     print(allCommands)

voucherFormat = """%key%:
    Item: '%itemid%'
    Name: '&d&l✧&5&l✧&d&l✧ %title%&r &d&l✧&5&l✧&d&l✧'
    Lore:
      - ''
      - '&d&lUSAGE: &7Click to claim this %type%'
      - ''
      - '&7&o(( &f&nRight Click&r &7&oto redeem this voucher ))'
    Options:
      Message: '&a&l[+]&a You redeemed the &f%title%&r'
    Glowing: %glowing%
    Commands:
      - '%command%'"""

print("""Settings:
  Prefix: '&d&l[!] '
  Updater: false
Vouchers:""")

print("# RANKS " + "-"*50)
for rank in ['goblin', 'wizard', 'king', 'dragon']:   

    info = {"key": f"  rank{rank.title()}",
            "type": "Rank",
            "title": f"&f&l{rank.upper()} &f&lRANK &7&o((30 Days))",
            "itemid": "399",            
            "glowing": "true",
            "command": f"lp user %player% parent addtemp {rank} 30d true server=skyblock"
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)


print("# KITS " + "-"*50)
for kit in ['member','goblin', 'wizard', 'king', 'dragon']:   
    info = {"key": f"  kit{kit.title()}",
            "type": "Kit",
            "title": f"&f&l{kit.upper()} KIT",
            "itemid": "351:5",            
            "glowing": "true",
            "command": f"kit {kit} %player%"
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)



print("# SKit One Time " + "-"*50)
for gkit in ['cactus', 'grinder','cyborg','monthly']:   

    info = {"key": f"  skit{gkit.title()}",
            "type": "SKit",
            "title": f"&f&l{gkit.upper()} SKIT &7(One Time)",
            "itemid": "351:6",            
            "glowing": "true",
            "command": f"ae givegkit %player% {gkit}"
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)



# /lp bulkupdate users delete "server == skyblock" "permission ~~ %.skit"
print("# Skit_Perm " + "-"*50)
for gkit in ['cactus', 'grinder','cyborg','monthly']:   

    info = {"key": f"  permSkit{gkit.title()}",
            "type": "SKit",
            "title": f"&f&l{gkit.upper()} SKIT &7(Season)",
            "itemid": "351:14",            
            "glowing": "true",
            "command": f"lp user %player% permission set {gkit}.skit server=skyblock"
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)



print("# Border " + "-"*50)
for isBorder in ["150", "200", "250", "300"]:  
    info = {"key": f"  {isBorder.title()}x{isBorder.title()}",
            "type": "Island Border",
            "title": f"&f&l{isBorder.title()}x{isBorder.title()} ISLAND SIZE &7(Owner Only)",
            "itemid": "166", # Barrier            
            "glowing": "true",
            "command": f"is admin setsize %player% {int(int(isBorder)/2)}"
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)


print("# KOTH STARTER " + "-"*50)
for koth in ['koth1', 'koth2']:   

    info = {"key": f"  koth{koth.title()}",
            "type": "Rank",
            "title": f"&f&l{koth.upper()} &f&lSTARTER",
            "itemid": "276",            
            "glowing": "true",
            "command": f"koth start {koth} 5 30 2" # 5m, 30m Max, 2 items
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)

print("# BOOSTERS " + "-"*50)
for booster in ['Experience', 'Mobcoins', 'Money', 'PersonalExperience', 'PersonalMobcoins', 'PersonalMoney']:   

    info = {"key": f"  booster{booster.title()}",
            "type": "Booster",
            "title": f"&f&l{booster.upper()} &f&l BOOSTER",
            "itemid": "138", # beacon            
            "glowing": "true",
            "command": f"booster give %player% {booster} 1"
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)




print("# Perks " + "-"*50)
for perks in [
                 # Key,      title ,    item   permission,              
                 ["FixAll", ["FIX ALL", "145", "essentials.repair.all"] ],
                 ["Fly", ["FLY", "288", "superior.island.fly"] ]
            ]:

    info = {"key": f"  perk{perks[0]}",
            "type": "Perk",
            "title": f"&f&l{perks[1][0]} PERK",
            "itemid": f"{perks[1][1]}",            
            "glowing": "true",
            "command": f"lp user %player% permission set {perks[1][2]}"
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)


# /voidchest give default %player% 1 (( default, one, two, three, four ))
print("# VOIDCHEST " + "-"*50)
for voidchest in [
                 # Key,      title ,    item   command, 
                 ["default", ["1.00x", "342"] ],             
                 ["one", ["1.25x", "342"] ],
                 ["two", ["1.50x", "342"] ],
                 ["three", ["2.00x", "342"] ],
                 ["four", ["2.50x", "342"] ],
            ]:

    info = {"key": f"  voidChest{voidchest[0]}",
            "type": "VoidChest",
            "title": f"&f&lVOID CHEST &d{voidchest[1][0]}",
            "itemid": f"{voidchest[1][1]}",            
            "glowing": "true",
            "command": f"voidchest give {voidchest[0]} %player% 1"
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)

print("# Bundle " + "-"*50)
print("""  ScrollBundle:
    Item: '341'
    Name: '&d&l✧&5&l✧&d&l✧ &f&lSCROLL BUNDLE VOUCHER &d&l✧&5&l✧&d&l✧'
    Lore:
      - ''
      - '&d✧ &d&lINFORMATION: &fScroll Bundles are packages that can be'
      - '&f redeemed to receive special scrolls on the server.'
      - '&f These scrolls each have their own unique ability'
      - '&f to help further you in your skyblock adventure'
      - ''
      - '&d&lUSAGE: &7Click to claim this item'
      - ''
      - '&7&o(( &f&nRight Click&r &7&oto redeem this voucher ))'
    Player: ''
    Glowing: true
    Commands:
      - 'ae giveitem %player% blackscroll 1 1'
      - 'ae giveitem %player% whitescroll 1 1'
      - 'ae giveitem %player% blocktrak 1 1'
      - 'ae giveitem %player% stattrak 1 1'
      - 'ae giveitem %player% transmog 1'
    Options:
      Message: ''""")

Tags = """Boss: '&8&l<&6BossTag&8&l>'
Spicy: '&8&l<&c&lS&a&lP&c&lI&a&lC&c&lY&8>'
OG: '&8&l<&b&lOG&8&l>'
Simp: '&8&l<&d&lSIMP&8&l>'
Pog: '&8&l<&6&lP&e&lO&6&lG&8&l>'
Twitch: '&8&l<&5&lT&d&lW&5&lI&d&lT&5&lC&d&lH&8&l>'
YouTube: '&8&l<&c&lYOU&f&lTUBE&8&l>'
King: '&8&l<&6&lKing&8&l>'
Abuse: '&8&l<&4&lABUSE&8&l>'
Grinder: '&8&l<&6&lGRINDER&8&l>'
Pay2Win: '&8&l<&2&lPay&a&l2&2&lWin&8&l>'
DumDum: '&8&l<&7&oDumDum&8&l>'
Beta: '&8&l<&b&oBeta&8&l>'
Salty: '&8&l<&f&l&oSalty&8&l>'
Fantasy: '&8&l<&d&lFantasy&8&l>'
EGirl: '&8&l<&d&lE-Girl&8&l>'
Captain: '&8&l<&b&lCaptain&8&l>'
CactusGod: '&8&l<&2Cactus&aGod&8&l>'
Tryhard: '&8&l<&4&lTryhard&8&l>'"""

print("# TAGS " + "-"*65)
for tag in Tags.split("\n"):
    tag = tag.replace("'","").split(": ") # ["OG", "&8&l<&b&lOG&8&l>""]
    info = {"key": f"  Tag{tag[0].title()}",
            "type": "Tag",
            "title": f"{tag[1].upper()} &f&lTAG",
            "itemid": "421",            
            "glowing": "true",
            "command": f"lp user %player% permission set Tags.{tag[0]}"
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key])
    print(f)