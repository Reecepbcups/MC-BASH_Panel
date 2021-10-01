

# Future to do: add 'boosters give %player% Mobcoins Personal 1'

voucherFormat = """  %key%:
    Item: '%material%'
    Name: '&f&l✧&7&l✧&f&l✧ %name%&r &f&l✧&7&l✧&f&l✧'
    Lore:
      - ''
      - '&f&lUSAGE: &7Click to claim this Voucher'
      - ''
      - '&7&o(( &f&nRight Click&r &7&oto redeem this voucher ))'
    Options:
      Message: '&a&l[+]&a You redeemed the &f%name%&r'
    Glowing: true
    Commands:
      - '%command%'"""

print("""Settings:
  Prefix: '&c&l[!] '
  Updater: false
Vouchers:""")


# NEW
vouchers = [
  
  # Perks
  ['perkFly2h', '____', 'FEATHER', f'&f&lFLY PERK &7&o(( 2 Hours))', 'lp user %player% permission settemp essentials.fly true 2h accumulate server=skyblock_emc'],
  ['perkFly6h', '____', 'FEATHER', f'&f&lFLY PERK &7&o(( 6 Hours))', 'lp user %player% permission settemp essentials.fly true 6h accumulate server=skyblock_emc'],
  ['perkFly24h', '____', 'FEATHER', f'&f&lFLY PERK &7&o(( 1 Day ))', 'lp user %player% permission settemp essentials.fly true 24h accumulate server=skyblock_emc'],

  # Ranks
  ['rankIronTemp', '____', 'NETHER_STAR', f'&f&lIRON RANK &7&o(( 5 Days ))', 'lp user %player% parent addtemp iron 5d accumulate server=skyblock_emc'],
  ['rankGoldTemp', '____', 'NETHER_STAR', f'&6&lGOLD RANK &7&o(( 3 Days ))', 'lp user %player% parent addtemp gold 3d accumulate server=skyblock_emc'],
  ['rankDiamondTemp', '____', 'NETHER_STAR', f'&b&lDIAMOND RANK &7&o(( 1 Day ))', 'lp user %player% parent addtemp diamond 1d accumulate server=skyblock_emc'],






]

for voucher in vouchers:   
    info = {"key": voucher[0],"material": voucher[2],
            "name": voucher[3],"command": voucher[4],
            }

    f = voucherFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key]).replace("Reecepbcups", "%player%")
    print(f)


print("""  Tags1:
    Item: 'NAME_TAG'
    Name: '&f&l✧&7&l✧&f&l✧ &b&lRANDOM TAG #1&r &f&l✧&7&l✧&f&l✧'
    Lore:
      - ''
      - '&f&l#1: &8&l<&6BossTag&8&l>'
      - '&f&l#2: &8&l<&c&lS&a&lP&c&lI&a&lC&c&lY&8>'
      - '&f&l#3: &8&l<&b&lOG&8&l>'
      - '&f&l#4: &8&l<&d&lSIMP&8&l>'
      - '&f&l#5: &8&l<&6&lP&e&lO&6&lG&8&l>'
      - '&f&l#6: &8&l<&6&lKing&8&l>'
      - ''
      - '&7&l(&6&l!&7&l) &7Right click to redeem.'
    Glowing: true
    Random-Commands:
      - 'tags give %player% boss'
      - 'tags give %player% spicy'
      - 'tags give %player% OG'
      - 'tags give %player% simp'
      - 'tags give %player% pog'
      - 'tags give %player% king'""")
print("""  Spawners:
    Item: 'MOB_SPAWNER'
    Name: '&f&l✧&7&l✧&f&l✧ &f&lRANDOM SPAWNER&r &f&l✧&7&l✧&f&l✧'
    Lore:
      - '&7&oChances are equal for all spawners'
      - ''
      - '&f&l#1: &bChicken &fx1-2'
      - '&f&l#2: &bPig &fx1-2'
      - '&f&l#3: &bCow &fx1-2'
      - '&f&l#4: &bZombie &fx1-2'
      - '&f&l#5: &bCreeper &fx1-2'
      - '&f&l#6: &bIron Golem &fx1-2'
      - ''
      - '&7&l(&6&l!&7&l) &7Right click to redeem.'
    Glowing: true
    Random-Commands:
      - 'spawner give %player% chicken 1'
      - 'spawner give %player% chicken 2'
      - 'spawner give %player% pig 1'
      - 'spawner give %player% pig 2'
      - 'spawner give %player% cow 1'
      - 'spawner give %player% cow 2'
      - 'spawner give %player% zombie 1'
      - 'spawner give %player% zombie 2'
      - 'spawner give %player% creeper 1'
      - 'spawner give %player% creeper 2'
      - 'spawner give %player% iron_golem 1'
      - 'spawner give %player% iron_golem 2'""")
print("""  Spawners2:
    Item: 'MOB_SPAWNER'
    Name: '&f&l✧&7&l✧&f&l✧ &f&lRANDOM SPAWNER &4&l[OP]&r &f&l✧&7&l✧&f&l✧'
    Lore:
      - '&7&oChances are equal for all spawners'
      - ''
      - '&f&l#1: &bCow &fx2-8'
      - '&f&l#2: &bZombie &fx1-5'
      - '&f&l#3: &bCreeper &fx1-4'
      - '&f&l#4: &bBlaze &fx1-4'
      - '&f&l#5: &bIron Golem &fx1-4'
      - ''
      - '&7&l(&6&l!&7&l) &7Right click to redeem.'
    Glowing: true
    Random-Commands:
      - 'spawner give %player% cow 2'
      - 'spawner give %player% cow 3'
      - 'spawner give %player% cow 4'
      - 'spawner give %player% cow 8'
      - 'spawner give %player% zombie 1'
      - 'spawner give %player% zombie 2'
      - 'spawner give %player% zombie 4'
      - 'spawner give %player% creeper 1'
      - 'spawner give %player% creeper 2'
      - 'spawner give %player% creeper 4'
      - 'spawner give %player% iron_golem 1'
      - 'spawner give %player% iron_golem 2'
      - 'spawner give %player% iron_golem 4'""")


#             "command": f"lp user %player% group add {rank} server=skyblock"
#             }
#             "command": f"kit {kit} %player%"
#             }
#             "command": f"ae givegkit %player% {gkit}"
#             }

#             "command": f"lp user %player% permission set gkit.{gkit}"
#             }
#             "command": f"is admin setsize %player% {int(int(isBorder)/2)}"
#             }

#             "command": f"koth start {koth} 5 30 2" # 5m, 30m Max, 2 items
#             }


# print("# Perks " + "-"*50)
# for perks in [
#                  # Key,      title ,    item   permission,              
#                  ["FixAll", ["FIX ALL", "145", "essentials.repair.all"] ],
#                  ["Fly", ["FLY", "288", "essentials.fly"] ]
#             ]:

#     info = {"key": f"  perk{perks[0]}",
#             "type": "Perk",
#             "title": f"&f&l{perks[1][0]} PERK",
#             "itemid": f"{perks[1][1]}",            
#             "glowing": "true",
#             "command": f"lp user %player% permission set {perks[1][2]}"
#             }


# print("# Bundle " + "-"*50)
# print("""  ScrollBundle:
#     Item: '341'
#     Name: '&d&l✧&5&l✧&d&l✧ &f&lSCROLL BUNDLE VOUCHER &d&l✧&5&l✧&d&l✧'
#     Lore:
#       - ''
#       - '&d✧ &d&lINFORMATION: &fScroll Bundles are packages that can be'
#       - '&f redeemed to receive special scrolls on the server.'
#       - '&f These scrolls each have their own unique ability'
#       - '&f to help further you in your skyblock adventure'
#       - ''
#       - '&d&lUSAGE: &7Click to claim this item'
#       - ''
#       - '&7&o(( &f&nRight Click&r &7&oto redeem this voucher ))'
#     Player: ''
#     Glowing: true
#     Commands:
#       - 'ae giveitem %player% blackscroll 1 1'
#       - 'ae giveitem %player% whitescroll 1 1'
#       - 'ae giveitem %player% blocktrak 1 1'
#       - 'ae giveitem %player% stattrak 1 1'
#       - 'ae giveitem %player% transmog 1'
#     Options:
#       Message: ''""")

# Tags = """Boss: '&8&l<&6BossTag&8&l>'
# Spicy: '&8&l<&c&lS&a&lP&c&lI&a&lC&c&lY&8>'
# OG: '&8&l<&b&lOG&8&l>'
# Simp: '&8&l<&d&lSIMP&8&l>'
# Pog: '&8&l<&6&lP&e&lO&6&lG&8&l>'
# Twitch: '&8&l<&5&lT&d&lW&5&lI&d&lT&5&lC&d&lH&8&l>'
# YouTube: '&8&l<&c&lYOU&f&lTUBE&8&l>'
# King: '&8&l<&6&lKing&8&l>'
# Abuse: '&8&l<&4&lABUSE&8&l>'
# Grinder: '&8&l<&6&lGRINDER&8&l>'
# Pay2Win: '&8&l<&2&lPay&a&l2&2&lWin&8&l>'
# DumDum: '&8&l<&7&oDumDum&8&l>'
# Beta: '&8&l<&b&oBeta&8&l>'
# Salty: '&8&l<&f&l&oSalty&8&l>'
# Fantasy: '&8&l<&d&lFantasy&8&l>'
# EGirl: '&8&l<&d&lE-Girl&8&l>'
# Captain: '&8&l<&b&lCaptain&8&l>'
# CactusGod: '&8&l<&2Cactus&aGod&8&l>'
# Tryhard: '&8&l<&4&lTryhard&8&l>'"""

# print("# TAGS " + "-"*65)
# for tag in Tags.split("\n"):
#     tag = tag.replace("'","").split(": ") # ["OG", "&8&l<&b&lOG&8&l>""]
#     info = {"key": f"  Tag{tag[0].title()}",
#             "type": "Tag",
#             "title": f"{tag[1].upper()} &f&lTAG",
#             "itemid": "421",            
#             "glowing": "true",
#             "command": f"lp user %player% permission set Tags.{tag[0]}"
#             }

#     f = voucherFormat
#     for key in info.keys():
#         f = f.replace(f"%{key}%", info[key])
#     print(f)