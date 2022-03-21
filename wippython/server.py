import subprocess
import utils

# java -Xms2G -Xmx4G -jar server.jar nogui
# THIS FILE ISDEPRICATED

def start_server(server_path, jar_name):
    '''
    Fetches the servers start script from the path specified
    '''
    return subprocess.Popen("java -jar " + server_path+jar_name, stdin=subprocess.PIPE, shell=True)

def create_server():
    '''
    walks through creating new server instance
    '''