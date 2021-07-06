from __future__ import print_function

import sys


def stop_err(msg):
    sys.stderr.write(msg)
    sys.exit()
    
    
def __main__():
    
    print('MAIN')
    
    try:
        infile = open(sys.argv[1])
        outfile = open(sys.argv[2], 'w')
    except Exception:
        stop_err('Cannot open or create a file\n')
        

if __name__ == "__main__":
    __main__()        