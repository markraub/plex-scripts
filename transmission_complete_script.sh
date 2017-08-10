#!/bin/sh

#### PARAMETERS ########################################

# Transmission Remote username
TR_USERNAME="transmission"

# Transmission Remote password
TR_PASSWORD="transmission"

# Transmission Remote port
PORT="9091"

# Choose time format (leave one uncommented or create your own)
NOW=$(date +%d.%m.%Y\ %H:%M:%S)
#NOW=$(date +%Y-%m-%d\ %H:%M:%S)

# Logfile
LOGFILE=/opt/transmission_unrar.log

# Location of unrar in jail
UNRAR=/usr/bin/unrar


#### PROCESSING ########################################

# Go to download directory
cd ${TR_TORRENT_DIR}

# Check if torrent directory is there
if [ -d "${TR_TORRENT_NAME}" ]
then
  
  # Check if torrent is compressed 
  if ls "${TR_TORRENT_NAME}"/*.rar > /dev/null 2>&1
  
  then
    
    # Find the name of the first archive file
    find "${TR_TORRENT_NAME}" -iname "*.rar" | while read archive
    do

      # Extract archive
      ${UNRAR} e -inul "${archive}" ${TR_TORRENT_DIR}/${TR_TORRENT_NAME}

    done
    
    # Send torrent stop command to Transmission
    transmission-remote localhost:${PORT} -n ${TR_USERNAME}:${TR_PASSWORD} -t${TR_TORRENT_ID} --stop &
    
    # Remove Sample directory if present
    rm -rf ${TR_TORRENT_NAME}/Sample > /dev/null 2>&1
    rm -rf ${TR_TORRENT_NAME}/sample > /dev/null 2>&1

    # Remove RAR files
    rm -rf ${TR_TORRENT_NAME}/*.r* > /dev/null 2>&1
 
    # Remove SFV file if present
    rm -rf ${TR_TORRENT_NAME}/*.sfv > /dev/null 2>&1

    # Log extraction
    echo "${NOW}: ${TR_TORRENT_NAME} extracted and stopped" >> $LOGFILE

    FULLDIR=${TR_TORRENT_DIR}${TR_TORRENT_NAME}
    python /opt/plex-scripts/move-torrent.py ${FULLDIR}
  
  else
    
    FULLDIR=${TR_TORRENT_DIR}${TR_TORRENT_NAME} 
    python /opt/plex-scripts/move-torrent.py ${FULLDIR}

  fi

fi
