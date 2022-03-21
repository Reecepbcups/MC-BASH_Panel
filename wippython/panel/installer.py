import subprocess
import os
from cosmetics import color

INSTALL_SCRIPT = os.getcwd() + "/wippython/shell"
INSTALLS = os.getcwd() + "/wippython/installs"
PAPERMC_LEGACY = "papermc-legacy"
SPIGOT = "spigot"

papermc_legacy_versions = {
    "1.8.8": "https://papermc.io/api/v2/projects/paper/versions/1.8.8/builds/445/downloads/paper-1.8.8-445.jar",
    "1.9.4": "https://papermc.io/api/v2/projects/paper/versions/1.9.4/builds/775/downloads/paper-1.9.4-775.jar",
    "1.10.2": "https://papermc.io/api/v2/projects/paper/versions/1.10.2/builds/918/downloads/paper-1.10.2-918.jar",
    "1.11.2": "https://papermc.io/api/v2/projects/paper/versions/1.11.2/builds/1106/downloads/paper-1.11.2-1106.jar",
    "1.12.2": "https://papermc.io/api/v2/projects/paper/versions/1.12.2/builds/1620/downloads/paper-1.12.2-1620.jar",
    "1.13.2": "https://papermc.io/api/v2/projects/paper/versions/1.13.2/builds/657/downloads/paper-1.13.2-657.jar",
    "1.14.4": "https://papermc.io/api/v2/projects/paper/versions/1.14.4/builds/245/downloads/paper-1.14.4-245.jar",
    "1.15.2": "https://papermc.io/api/v2/projects/paper/versions/1.15.2/builds/393/downloads/paper-1.15.2-393.jar",
    "1.16.5": "https://papermc.io/api/v2/projects/paper/versions/1.16.5/builds/794/downloads/paper-1.16.5-794.jar",
    "1.17.1": "https://papermc.io/api/v2/projects/paper/versions/1.17.1/builds/409/downloads/paper-1.17.1-409.jar"
}

# contains the buildtools download link and version arguments for a server jar
spigot_versions = {
    "buildtools": "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar",
    "latest": "latest",
}


def install_server(type, version):
    if type.lower() == PAPERMC_LEGACY:
        if version in papermc_legacy_versions:
            download(papermc_legacy_versions[version])
        else:
            print(f'the version {version} does not exist for the type {type}')
    elif type.lower() == SPIGOT:
        run_buildtools(version)


def run_buildtools(version, args=""):
    '''
    Runs spigots build tools and downloads it if it doesn't exist already
    '''
    wd = chdir(INSTALLS)

    # Installs BuildTools.jar if it doesn't exist
    if not os.path.isfile(os.getcwd() + "/BuildTools.jar"):
        download(spigot_versions["buildtools"])
    
    if os.path.isfile(INSTALLS + f'/spigot-{version}.jar'):
        print(color("&a Found Server Version: " + f'spigot-{version}.jar'))
    else:
        subprocess.call(['java', '-jar', 'BuildTools.jar', f'--rev', f'{version}'])
        print(color("&aFinished installing the spigot server for the version " + str(version)))
    os.chdir(wd)


def download(link):
    '''
    Downloads a file form the internet using the basic-installer.sh script
    More details about this script in the file itself
    '''
    wd = chdir(INSTALL_SCRIPT)
    subprocess.call([f'./basic-installer.sh', link])
    os.chdir(wd)

def chdir(dir, credir=True):
    '''
    A better version of os.chdir
    '''
    wd = os.getcwd()
    if not os.path.isdir(dir):
        os.mkdir(dir)
        print(f'created directory at {dir}')
        os.chdir(dir)
    else:
        os.chdir(dir)
    return wd
    

if __name__ == "__main__":
    version = input("What version do you want: ")
    type = input("What type of server do you want: [paper/spigot]")
    install_server(type, version)
    
