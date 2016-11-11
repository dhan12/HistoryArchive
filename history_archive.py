#!/usr/bin/python

from os import listdir
from os import path
import time
import subprocess

timeSinceEpoch = time.time()

# Save archived files to this directory
homedir = path.expanduser('~')
archive  = homedir + '/history_archive/'
subprocess.call(['mkdir', '-p', archive])

# Get mac bash_sessions history from here
mac_sessions_dir = homedir + '/.bash_sessions/'
numFilesUpdated = 0
files = [f for f in listdir(mac_sessions_dir)]
for f in files:
    oldPath = mac_sessions_dir + f
    lastModified = path.getmtime(oldPath)
    hoursSinceLastUpdate = (timeSinceEpoch - lastModified) / 3600

    # Parse file name to get new file name
    items = f.split('.')
    if len(items) != 2 or items[1] != 'historynew':
        print __file__, ':Unexpected file name. {}. Will not archive'.format(f)
        continue
    idStr = items[0]
    newFileName = archive + '/' + idStr + '.history'

    # Check if file exists
    fileExists = False
    try:
        with open(newFileName) as input:
            fileExists = True
    except:
        pass

    # Check how old the file is
    # if hoursSinceLastUpdate < 96:

    if not fileExists or hoursSinceLastUpdate < 96:
        # print 'Creating file. File does not exist or its relatively new'
        subprocess.call('uniq ' + oldPath + '>' + newFileName, shell=True)
        numFilesUpdated += 1
    else:
        pass
        # print 'not creating file', newFileName

print 'Exiting ', __file__,'. Updated {} files'.format(numFilesUpdated)
