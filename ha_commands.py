import os
import sys
import glob
import subprocess
import argparse

def getLatest(fileDir):
    return max(glob.iglob(fileDir+'/*.txt'), key=os.path.getctime)

def parseArgs():
    parser = argparse.ArgumentParser(description='History Archive commands', prog="ha")
    parser.add_argument('-d', '--dir', required=True,
            help='Directory for history archive files.',
            dest='historyArchiveDir')
    parser.add_argument('-c', '--comments', action='store_true',
            help='Show recent comments',
            dest='getComments')

    return parser.parse_args()

def main():
    args = parseArgs()

    if args.getComments:
        latestFile = getLatest(args.historyArchiveDir)
        proc = subprocess.Popen(['tail','-1000',latestFile], stdout=subprocess.PIPE)
        out, err = proc.communicate()
        for line in out:
            if '#' in line:
                print line
    else:
        latestFile = getLatest(args.historyArchiveDir)
        subprocess.call(['tail','-10',latestFile])

if __name__ == '__main__':
    main()
