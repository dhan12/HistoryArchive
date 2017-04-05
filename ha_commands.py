import argparse
import glob
import os
import subprocess
import sys
import get_next_prefix

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
    parser.add_argument('-f', '--full', action='store_true',
            help='Show full details of a command, including directory)',
            dest='fullDetails')
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
        lastDate = ''
        index = 0
        prefix = get_next_prefix.getNextPrefix()
        for f in getFiles(args.historyArchiveDir, args.getAll):
            with open(f, 'r') as input:
                for line in input:
                    thisDate = line[:8]
                    if thisDate != lastDate:
                        lastDate = thisDate
                        index = 0
                        prefix = get_next_prefix.getNextPrefix(prefix)
                    if args.fullDetails:
                        print prefix + str(index) + '. ' + line[:-1]
                    else:
                        # Print the id and the command.
                        # This has a bug if the directory has a space.
                        print prefix + str(index) + '. ' + ' '.join(line[:-1].split(' ')[2:])
                    index += 1

if __name__ == '__main__':
    main()
