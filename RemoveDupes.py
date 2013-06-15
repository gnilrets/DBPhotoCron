#!/usr/bin/python

deduppath = '/Users/gnilrets/Dropbox/Photos-Master'
filelist = '/Users/gnilrets/filelist.txt'

import os
import re
import hashlib
import sys

# Function to calculate the md5Checksum of a file
def md5Checksum(filePath):
    with open(filePath, 'rb') as fh:
        m = hashlib.md5()
        while True:
            data = fh.read(8192)
            if not data:
                break
            m.update(data)
        return m.hexdigest()



# Loop over all image files and build a list of hashes and filenames
flist = []

try:
    flist = [line.strip() for line in open(filelist)]

except:
    fio = open(filelist,'w')

    for r,d,f in os.walk(deduppath):
        for files in f:
            sort_pref = "99"

            # Only dedupe image and movie files
            if re.search(r'(\.jpg$|\.mov$|\.mp4$)',files,re.I|re.M):
                sort_pref = "01"

            # If a file looks like File (1).mov, sort it lower on the list
            if re.search(r'\(\d*\)\.',files,re.M):
                sort_pref = "10"

            fname = os.path.join(r,files)
            bfname = os.path.basename(files)
            fmd5 = md5Checksum(fname)

            if sort_pref != "99":
                line = fmd5 + "|" + sort_pref + "|" + fname
                flist.append(line)
                fio.write(line + '\n')


# Loop through sorted list of hashes and mark duplicates
flist.sort()
last_hash = ''
duplist = []

for fname in flist:
    matchObj = re.search(r'(.*)\|(.*)\|(.*)',fname);
    this_hash = matchObj.group(1)
    if this_hash == last_hash:
        duplist.append(matchObj.group(3))
        print '***DUPE ' + fname + " - " + matchObj.group(1)
    else:
        print fname + " - " + matchObj.group(1)
    last_hash = this_hash


print "-------   REMOVED THESE DUPLICATES   -------"

try:
    for fname in duplist:
        print fname
        os.remove(fname)

    os.remove(filelist)

except:
    raise Exception("Error deleting file(s)")





