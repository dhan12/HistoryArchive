import os
import sys
import glob
import subprocess
import argparse

def getLatest(fileDir):
    return max(glob.iglob(fileDir+'/*.txt'), key=os.path.getctime)

def getFiles(fileDir, getAll):
    if getAll:
        return sorted(list(glob.iglob(fileDir+'/*.txt')))
    else:
        return [getLatest(fileDir)]

def parseArgs():
    parser = argparse.ArgumentParser(description='History Archive commands', prog="ha")
    parser.add_argument('-d', '--dir', required=True,
            help='Directory for history archive files.',
            dest='historyArchiveDir')
    parser.add_argument('-c', '--comments', action='store_true',
            help='Show recent comments',
            dest='getComments')
    parser.add_argument('-a', '--all', action='store_true',
            help='Show output from all files (WARNING, this may be slow)',
            dest='getAll')
    return parser.parse_args()

def main():
    args = parseArgs()

    if args.getComments:
        for f in getFiles(args.historyArchiveDir, args.getAll):
            if args.getAll:
                proc = subprocess.Popen(['cat',f], stdout=subprocess.PIPE)
            else:
                proc = subprocess.Popen(['tail','-1000',f], stdout=subprocess.PIPE)
            out, err = proc.communicate()
            for line in out.split('\n'):
                try:
                    index = line.index('#')
                    # print YYYYMMDD HH:MM #comment
                    print line[:8],line[8:10]+':'+line[10:12],line[index:]
                except:
                    pass
    else:
        for f in getFiles(args.historyArchiveDir, args.getAll):
            if args.getAll:
                subprocess.call(['cat',f])
            else:
                subprocess.call(['tail','-1000',f])

if __name__ == '__main__':
    main()
