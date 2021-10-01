
# for season only, context 'lp user %player% permission set essentials.fly true seasononly=true' added
# just bulk update remove permissions with seasononly

print("  Prizes:")
crateFormat = f"""    '%key%':
      DisplayName: '&8❚ %name%'
      DisplayItem: %material%
      DisplayAmount: 1
      MaxRange: 100
      Chance: %chance%
      Firework: false
      Commands:
      - '%command%'
      Messages:
      - '&a&l[+]&r %name%' """

# Boosters ?? need to add Vak Booster plugin
prizes = [

#===# RARE KEY -------------------------------------------------------------------------------------------------
    # ['money1', '10.0', 'PAPER', f'&a$1,000 DOLLARS', 'withdraw 1000 %player%'],
    # ['money2', '8.0', 'PAPER', f'&a$1,500 DOLLARS', 'withdraw 1500 %player%'],
    # ['money3', '4.0', 'PAPER', f'&a$2,500 DOLLARS', 'withdraw 2500 %player%'],
    # ['money4', '1.0', 'PAPER', f'&a$5,000 DOLLARS', 'withdraw 5000 %player%'],
    
    # ['exp1', '10.0', 'EXP_BOTTLE', f'&a&lExperience &a50', 'xpbottle 50 %player%'],
    # ['exp2', '8.0', 'EXP_BOTTLE', f'&a&lExperience &a100', 'xpbottle 100 %player%'],
    # ['exp3', '4.0', 'EXP_BOTTLE', f'&a&lExperience &a200', 'xpbottle 200 %player%'],
    # ['exp4', '1.0', 'EXP_BOTTLE', f'&a&lExperience &a250', 'xpbottle 250 %player%'],
   
    # ['mobcoins1', '10.0', 'DOUBLE_PLANT', f'&eMOBCOINS &f&ox10', 'mobadmin give %player% 10'],
    # ['mobcoins2', '5.0', 'DOUBLE_PLANT', f'&eMOBCOINS &f&ox30', 'mobadmin give %player% 30'],
    # ['mobcoins3', '1.0', 'DOUBLE_PLANT', f'&eMOBCOINS &f&ox50', 'mobadmin give %player% 50'],
    
    # ['goldenApple1', '10.0', 'GOLDEN_APPLE', f'&f&lGOLDEN APPLE &f&ox5', 'give %player% golden_apple 5'],
    # ['goldenApple2', '6.0', 'GOLDEN_APPLE', f'&f&lGOLDEN APPLE &f&ox10', 'give %player% golden_apple 10'],
    # ['godApple', '1.0', 'GOLDEN_APPLE:1', f'&f&lGOD APPLE &f&ox1', 'give %player% golden_apple:1 1'],
    
    # ['iron', '8.0', 'IRON_BLOCK', f'&e&lIRON &f&ox16', 'give Reecepbcups iron_block 16'],
    # ['gold', '6.0', 'GOLD_BLOCK', f'&e&lGOLD &f&ox16', 'give Reecepbcups gold_block 16'],
    # ['diamond', '4.0', 'diamond_block', f'&b&lDIAMOND &f&ox16', 'give Reecepbcups diamond_block 16'],
    # ['emmy', '2.0', 'emerald_block', f'&a&lEMERALD &f&ox16', 'give Reecepbcups emerald_block 16'],

    # ['hopper', '2.0', 'hopper', f'&f&lHOPPER &7&ox1', 'give Reecepbcups hopper 1'],
    # ['hopper', '1.5', 'hopper', f'&f&lHOPPER &7&ox3', 'give Reecepbcups hopper 3'],

    # ['beacon', '0.1', 'beacon', f'&f&lBEACON &7&ox1', 'give Reecepbcups beacon 1'],

    # ['spawnerSheep', '2.0', 'MOB_SPAWNER', f'&f&lSPAWNER &7Sheep', 'silkspawner give %player% sheep 1'],
    # ['spawnerChicken', '1.5', 'MOB_SPAWNER', f'&f&lSPAWNER &7Chicken', 'silkspawner give %player% chicken 1'],
    # ['spawnerPig', '1.5', 'MOB_SPAWNER', f'&f&lSPAWNER &7Pig', 'silkspawner give %player% pig 1'],
    

    # ['tempFly2h', '3.5', 'FEATHER', f'&f&lTEMPERARY FLY &7&o(( 2 hours ))', 'voucher give perkFly2h 1 %player%'],
    # ['sellwand100_0-5', '0.5', 'GOLD_HOE', f'&f&lSELL WAND &&7T1', 'sellwand give %player% default'],

    # ['randomTag1', '6.0', 'NAME_TAG', f'&b&lRANDOM TAG &f&lI', 'voucher give Tags1 1 %player%'],

    # ['keyRare', '4.0', 'TRIPWIRE_HOOK', f'&7RARE KEY x1', 'crate give P rare 1 %player%'],
    # ['rankIron', '0.1', 'NETHER_STAR', f'&fIRON RANK &7Season', 'voucher give rankIronTemp 1 %player%'],
#===#/RARE KEY
 

#===# LEGENDARY KEY -------------------------------------------------------------------------------------------------
    ['money2', '8.0', 'PAPER', f'&a$25,000 DOLLARS', 'withdraw 25000 %player%'],
    ['money3', '6.0', 'PAPER', f'&a$50,000 DOLLARS', 'withdraw 50000 %player%'],
    ['money4', '1.0', 'PAPER', f'&a$100,000 DOLLARS', 'withdraw 100000 %player%'],
    ['money5', '0.1', 'PAPER', f'&a$250,000 DOLLARS', 'withdraw 250000 %player%'],
    
    ['exp3', '5.0', 'EXP_BOTTLE', f'&a&lExperience &a2000', 'xpbottle 2000 %player%'],
    ['exp4', '2.0', 'EXP_BOTTLE', f'&a&lExperience &a5000', 'xpbottle 5000 %player%'],
    ['exp5', '0.5', 'EXP_BOTTLE', f'&a&lExperience &a7500', 'xpbottle 7500 %player%'],
   
    ['mobcoins1', '5.0', 'DOUBLE_PLANT', f'&eMOBCOINS &f&ox100', 'mobadmin give %player% 100'],
    ['mobcoins2', '3.0', 'DOUBLE_PLANT', f'&eMOBCOINS &f&ox250', 'mobadmin give %player% 250'],
    ['mobcoins3', '1.0', 'DOUBLE_PLANT', f'&eMOBCOINS &f&ox500', 'mobadmin give %player% 500'],
    
    ['godApple1', '1.0', 'GOLDEN_APPLE:1', f'&f&lGOD APPLE &f&ox6', 'give give %player% golden_apple:1 6'],
    ['godAppl2', '0.5', 'GOLDEN_APPLE:1', f'&f&lGOD APPLE &f&ox12', 'give give %player% golden_apple:1 12'],
    
    ['dBlock', '4.0', 'diamond_block', f'&b&lDIAMOND &f&ox128', 'give Reecepbcups diamond_block 128'],
    ['eBlock', '2.0', 'emerald_block', f'&a&lEMERALD &f&ox128', 'give Reecepbcups emerald_block 128'],

    ['hopper', '2.0', 'hopper', f'&f&lHOPPER &7&ox16', 'give Reecepbcups hopper 16'],
    ['hopper2', '1.5', 'hopper', f'&f&lHOPPER &7&ox32', 'give Reecepbcups hopper 32'],

    ['beacon2', '0.1', 'beacon', f'&f&lBEACON &7&ox2', 'give Reecepbcups beacon 2'],
    ['beacon3', '0.1', 'beacon', f'&f&lBEACON &7&ox3', 'give Reecepbcups beacon 3'],

    ['mS1', '5.0', 'MOB_SPAWNER', f'&f&lRANDOM SPAWNER &7(1-2x) &fx1', 'voucher give Spawners 1 %player%'],
    ['mS1-2', '3.0', 'MOB_SPAWNER', f'&f&lRANDOM SPAWNER &7(1-2x) &fx1', 'voucher give Spawners 1 %player%'],
    ['mS2', '3.0', 'MOB_SPAWNER', f'&c&l[OP] &f&lRANDOM SPAWNER &7(1-2x) &fx2', 'voucher give Spawners2 2 %player%'],
    ['mS2-2', '1.0', 'MOB_SPAWNER', f'&c&l[OP] &f&lRANDOM SPAWNER &7(1-2x) &fx2', 'voucher give Spawners2 2 %player%'],

    ['s1', '5.0', 'MOB_SPAWNER', f'&f&lSPAWNER &7Skeleton &fx4', 'silkspawner give %player% skeleton 4'],
    ['s2', '4.0', 'MOB_SPAWNER', f'&f&lSPAWNER &7Spider &fx4', 'silkspawner give %player% spider 4'],
    ['s3', '3.0', 'MOB_SPAWNER', f'&f&lSPAWNER &7Squid &fx2', 'silkspawner give %player% squid 2'],
    ['s4', '2.0', 'MOB_SPAWNER', f'&f&lSPAWNER &7Squid &fx3', 'silkspawner give %player% squid 3'],
    ['s5', '1.0', 'MOB_SPAWNER', f'&f&lSPAWNER &7Enderman &fx2', 'silkspawner give %player% enderman 2'],
    ['s6', '0.5', 'MOB_SPAWNER', f'&f&lSPAWNER &7Blaze &fx2', 'silkspawner give %player% blaze 2'],
    ['s7', '0.5', 'MOB_SPAWNER', f'&f&lSPAWNER &7Iron Golem &fx1', 'silkspawner give %player% irongolem 1'],
    ['s7', '0.1', 'MOB_SPAWNER', f'&f&lSPAWNER &7Iron Golem &fx2', 'silkspawner give %player% irongolem 2'],
    
    ['fly48h', '0.5', 'FEATHER', f'&f&lTEMPERARY FLY &7&o(( 48 hours ))', 'voucher give perkFly24h 2 %player%'],

    ['buildW1', '2.5', 'DIAMOND_HOE', f'&f&lBUILDERS WAND &6&lII', 'bw give %player% 1'],
    ['buildW2', '1.0', 'DIAMOND_HOE', f'&f&lBUILDERS WAND &6&lIII', 'bw give %player% 2'],

    ['sellW1', '3.5', 'GOLD_HOE', f'&f&lSELL WAND &71.5x &f25', 'sellwand give %player% 25_1-50 25'],
    ['sellW2', '2.0', 'GOLD_HOE', f'&f&lSELL WAND &71.5x &f50', 'sellwand give %player% 25_1-50 50'],
    ['sellW3', '1.5', 'GOLD_HOE', f'&f&lSELL WAND &70.25x &fInfinite', 'sellwand give %player% inifinite_0-25'],
    ['sellW3', '0.1', 'GOLD_HOE', f'&f&lSELL WAND &71.00x &fInfinite', 'sellwand give %player% inifinite_1'],

    ['key1', '1.0', 'TRIPWIRE_HOOK', f'&7LEGENDARY KEY x2', 'crate give P legendary 2 %player%'],
    ['key2', '0.1', 'TRIPWIRE_HOOK', f'&7LEGENDARY KEY x5', 'crate give P legendary 5 %player%'],

    ['goldRank', '0.05', 'NETHER_STAR', f'&6GOLD RANK &7Season', 'voucher give rankGoldTemp 1 %player%'],
    ['IronRank', '0.05', 'NETHER_STAR', f'&fIRON RANK &7Lifetime', 'lp user %player% parent add iron server=skyblock_emc'],
    ['GoldRank', '0.01', 'NETHER_STAR', f'&7GOLD RANK &7Lifetime', 'lp user %player% parent add gold server=skyblock_emc'],
    ['DiamondRank', '0.005', 'NETHER_STAR', f'&bDIAMOND RANK &7Lifetime', 'lp user %player% parent add diamond server=skyblock_emc'],
    ['EmeraldRank', '0.001', 'NETHER_STAR', f'&aEMERALD RANK &7Lifetime', 'lp user %player% parent add emerald server=skyblock_emc'],

    ['emeraldSKit', '0.001', 'EMERALD', f'&aEMERALD sKIT &7Lifetime', 'lp user %player% permission set emerald.skit server=skyblock_emc'],

    ['customTag', '0.05', 'NAME_TAG', f'&fCUSTOM TAG', 'give %player% paper 1 name:&fTagVoucher lore:&a%player%_&7&o(Legendary_Crate)'],
    ['buycraftVoucher', '0.001', 'PAPER', f'&fBUYCAFT VOUCHER &7&o$25', 'give %player% paper 1 name:&fBuycraftVoucher lore:&a$25_%player%_&7&o(Legendary_Crate)'],
#===#/LEGENDARY KEY -------------------------------------------------------------------------------------------------

]


for prize in prizes:   
    info = {"key": prize[0],"chance": prize[1],"material": prize[2],
            "name": prize[3],"command": prize[4],
            }

    f = crateFormat
    for key in info.keys():
        f = f.replace(f"%{key}%", info[key]).replace("Reecepbcups", "%player%")
    print(f)




# TAGS = {'Boss': '&8&l<&6BossTag&8&l>',
# 'Spicy': '&8&l<&c&lS&a&lP&c&lI&a&lC&c&lY&8>',
# 'OG': '&8&l<&b&lOG&8&l>',
# 'Simp': '&8&l<&d&lSIMP&8&l>',
# 'Pog': '&8&l<&6&lP&e&lO&6&lG&8&l>',
# 'Twitch': '&8&l<&5&lT&d&lW&5&lI&d&lT&5&lC&d&lH&8&l>',
# 'YouTube': '&8&l<&c&lYOU&f&lTUBE&8&l>',
# 'King': '&8&l<&6&lKing&8&l>',
# 'Abuse': '&8&l<&4&lABUSE&8&l>',
# 'Grinder': '&8&l<&6&lGRINDER&8&l>',
# 'Pay2Win': '&8&l<&2&lPay&a&l2&2&lWin&8&l>',
# 'DumDum': '&8&l<&7&oDumDum&8&l>',
# 'Beta': '&8&l<&b&oBeta&8&l>',
# 'Salty': '&8&l<&f&l&oSalty&8&l>',
# 'Fantasy': '&8&l<&d&lFantasy&8&l>',
# 'EGirl': '&8&l<&d&lE-Girl&8&l>',
# 'Captain': '&8&l<&b&lCaptain&8&l>',
# 'CactusGod': '&8&l<&2Cactus&aGod&8&l>',
# 'Tryhard': '&8&l<&4&lTryhard&8&l>',
# }
# print("## TAGS")
# for tag in ['EGirl']: 
#     info = {"key": f"tags{tag}",
#             "chance": "3",
#             "name": f"&8❚ &f&l{TAGS[tag].upper()}&f&l TAG",
#             "material": f"421",                 
#             "command": f"voucher give Tag{tag} 1 %player%"        
#             }

#     f = crateFormat
#     for key in info.keys():
#         f = f.replace(f"%{key}%", info[key])
#     print(f)