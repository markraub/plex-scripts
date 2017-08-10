import rclone_copy as rc
import sys, os
from pymediainfo import MediaInfo


def getTorrent(args):

    if len(args) <= 1:
        
        print("invalid entry: python rclone_upload.py [file]")

        print("[DEBUG] " + sys.argv + str(len(sys.argv)))
        exit()

    else:
        
        tor_name = ""
        
        if len(args) <= 2:

            tor_name = args[1]

        else:

            tor_name += args[1]

            for each in range(2, len(args)):

                tor_name += " " + args[each]
        
            
        tor_name = tor_name.strip()

        print(tor_name)

        return tor_name

def main():

    file = getTorrent(sys.argv)
    
    if rc.isMovie(file):

        rc.sendToDrive(file)

        print("Send complete")

    else:

        print("That file ain't a movie, moving on")

if __name__ == "__main__":

    main()

        


