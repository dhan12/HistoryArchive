import os
import sys
import glob
import subprocess

HISTORY_ARCHIVE_DIR = ''

def getLatest():
    return max(glob.iglob(HISTORY_ARCHIVE_DIR+'/*.txt'), key=os.path.getctime)

def main(args):
    if len(args) == 0:
        latestFile = getLatest()
        subprocess.call(['tail','-10',latestFile])
    # TODO replace this else block with other argument parsing/processing
    else:
        latestFile = getLatest()
        subprocess.call(['tail','-10',latestFile])

if __name__ == '__main__':

    if len(sys.argv) <= 1:
        print 'Error: Not enough arguments for ', sys.argv[0]

    HISTORY_ARCHIVE_DIR = sys.argv[1]

    main(sys.argv[2:])
