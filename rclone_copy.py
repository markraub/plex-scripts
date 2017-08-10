import os, subprocess, sys
from pymediainfo import MediaInfo

RCLONE = "/usr/bin/rclone"
RCLONE_TRANSFERS = "4"
LOCAL_DIR = "/mnt/downloads/complete/"
REMOTE_NAME = "gdrive:"
REMOTE_DIR = "/cuckbucket/Plex/TV/"


def isMovie(file):

    if file.endswith(".prt"):

        print(file + " is not a whole file, its probably not done downloading.")

        return False

    minfo = MediaInfo.parse(file)

    for track in minfo.tracks:

        if track.track_type == 'Video':

            print(file + " checks out, lets move it to gdrive")
            
            return True

        elif track.track_type in ['General', 'Audio']:

            continue

        else:

            print(file + " is not a video file")

            return False

def sendToDrive(file):

    dest = REMOTE_NAME + REMOTE_DIR

    command = ([RCLONE, 'move', '--log-file=rclone_upload.log', '--transfers', RCLONE_TRANSFERS, '--drive-chunk-size=16M', file, dest])

    process = subprocess.Popen(command)

    process.communicate()

    return None

def find_files(curr_dir):
    
    for file in os.listdir(curr_dir):
       
        print("Trying " + file)

        if os.path.isdir(curr_dir + file):

            find_files(curr_dir + file + "/")

        else:

            if isMovie(curr_dir + file):

                sendToDrive(curr_dir + file)    

if __name__ == "__main__":

    find_files(LOCAL_DIR)
