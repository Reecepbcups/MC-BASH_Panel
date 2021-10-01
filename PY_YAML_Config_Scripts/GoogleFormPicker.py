# VSN - Picker bot from google forms
# Made by Reecepbcups (Reece#3370) - August 20th, 2021
# * Python: https://www.python.org/downloads/

# Example Layout - https://gyazo.com/d8708949a3ad7dda8a40043db6e24f66
# Discord @ first, then minecraft IGN

import random
AMOUNT_TO_SELECT = 2
GOOGLE_FORM_CSV_NAME = "VSN-Test.csv" # download from form responses



# ----------------------------- no touchy -----------------------------
f = open(GOOGLE_FORM_CSV_NAME, 'r')
lines = f.read();
CorrectUsers = []

# loop through, remove first question line.
for line in lines.split("\n")[1::]:
    # ['Reece#3370', 'Reecepbcups']
    nameList = line.replace("\"", "").split(",")[1::] 

    # no #, not a correct username
    if '#' not in nameList[0]:
        print(f"DISCORD '{nameList[0]}' no # in name")
        continue

    # must have 4 digits after username
    if len(nameList[0].split("#")[1]) != 4:
        print(f"DISCORD '{nameList[0].split('#')[1]}': not 4 digits after name")
        continue

    # invalid MC username
    MC_IGN_LEN = len(nameList[1])
    if MC_IGN_LEN < 3:
        print(f"MINECRAFT '{nameList[1]}': too short")
        continue
    if MC_IGN_LEN > 16:
        print(f"MINECRAFT '{nameList[1]}': too long")
        continue

    CorrectUsers.append(nameList)


random.shuffle(CorrectUsers)

# randomly selects players we will use
selected = []
for i in range(AMOUNT_TO_SELECT):
    User = random.choice(CorrectUsers)
    selected.append(User)
    CorrectUsers.remove(User)

# seperates players so we can run commands correctly
igns, discords = [], []
for player in selected:
    discords.append(player[0])
    igns.append(player[1])


# saves values to  text files
with open("whitelist.txt", 'w') as f:
    for ign in igns:
        f.write(f"whitelist add {ign}\n")
    f.close()

with open("removeWhitelistLater.txt", 'w') as f:
    for ign in igns:
        f.write(f"whitelist remove {ign}\n")
    f.close()

discordstring = ""
discordsFile = open("discords.txt", 'w')
for disc in discords:
    discordstring += disc + " "
discordsFile.write(f'/malDiscordCommandForTempRoles {discordstring}')
    