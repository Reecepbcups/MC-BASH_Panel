import time
import sys
import select


# THIS FILE ISDEPRICATED

def live_read(file_path, read_all=False):
    '''
    Reads from a file live
    '''
    with open(file_path, 'r') as f:
        while True:
            where = f.tell()
            line = f.readline()
            if not line:
                time.sleep(0.1) # Sleep briefly
                f.seek(where)
                continue
            yield line

def begin_read(file_path):
    '''
    Begins Reading Session async
    '''
    livelog = live_read(file_path)
    for line in livelog:
        print(line, end='')

def tinput(timeout):
    '''
    like the native input() function, but with a timeout
    '''
    ready, _, _ = select.select([sys.stdin], [], [], timeout)
    if ready:
        print(sys.stdin.readline().strip())
        return sys.stdin.readline().strip()