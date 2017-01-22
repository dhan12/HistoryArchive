#!/bin/bash


# Prerequisite 1 -- Is HISTORY_ARCHIVE_DIR defined?
if [ -z ${HISTORY_ARCHIVE_DIR+x} ]; then
    echo "ERROR $(pwd)/history_archive.bash HISTORY_ARCHIVE_DIR is not defined. Exiting now"
    return 2
fi

# Prerequisite 2 -- Can we create a directory for history archive files?
mkdir -p $HISTORY_ARCHIVE_DIR
rc=$?
if [ $rc -ne 0 ]; then
    echo "ERROR $(pwd)/history_archive.bash Failed to create history archive dir at $HISTORY_ARCHIVE_DIR . Exiting now."
    return 3
fi

# Parameters

# Print out debugging echo statements
declare -i _VERBOSE=0

# Each file will contain commands that are grouped together by date/time.
# Change this variable to put more or less commands in a given file.
NUM_OF_DAYS_PER_FILE__HA=7

# Name of directory to put files.
# Files will be put into $(HOME)/ARCHIVE_NAME__HA
ARCHIVE_NAME__HA=Dropbox/history_archive/home/

# Constants for this script
declare -i _TRUE=1


# Function to print things for debugging
function log() {
  if [ "$_VERBOSE" -eq "$_TRUE" ]; then
    echo $*
  fi
}
log $(pwd) history_archive.bash heartbeat ...

# Function that will run prior to each command
# Set some variables for later usage, see PostCommand.
function PreCommand() {
  CURRENT_COMMAND=$BASH_COMMAND
  if [ -z ${START_DIR} ]; then
    START_DIR=$(printf %q pwd)
    START_TIME_STAMP=$(date +%Y%m%d%H%M%S)
    log "PreCommand set new starting dir $START_DIR"
  fi
}
trap "PreCommand" DEBUG

# Function that will run after each command.
function PostCommand() {
  log "in PostCommand"
  set -f # stop globbing (expansion of '*')

  # Get last executed line from 'history'
  history_line=$(history | tail -1)
  log "history_line '$history_line'"
  tokens=( $history_line )
  cmd=""
  for index in "${!tokens[@]}"; do
      if [ "$index" -lt 2 ]; then
          continue
      fi
      word="${tokens[index]}"
      cmd="$cmd $word"
  done

  # Line to archive is different from the data in history because 
  # it has the timestamp the command was entered
  # and the directory where the command was entered
  line_to_archive="$START_TIME_STAMP $START_DIR $cmd"

  # Check if we need to save this line.
  # This check will help us to skip empty commands.
  if [ -z ${prev_history_line+x} ]; then
      save_file=0
  elif [ "$prev_history_line" != "$history_line" ]; then
      save_file=1
  else
      save_file=0
  fi
  log "line_to_archive = $line_to_archive, save_file = $save_file"
  
  # Save file to the archive
  if [ "$save_file" -eq 1 ]; then
      SetCurrentFile
      log "echo $line_to_archive >> $ARCHIVE_FILE"
      echo "$line_to_archive" >> $ARCHIVE_FILE
  fi

  # Update variables for the next round
  prev_history_line="$history_line"
  unset START_DIR
  unset CURRENT_COMMAND
  set +f # restart globbing (expansion of '*')
}

function SetDayOfMonth() {
  time_stamp=$(date +%Y%m%d%H%M%S)

  DAY_OF_MONTH=$(date +"%d")
  log "SetDayOfMonth original DAY_OF_MONTH=$DAY_OF_MONTH"

  # Strip off leading zero
  if [[ $DAY_OF_MONTH == 0* ]]; then 
      DAY_OF_MONTH=$(echo $DAY_OF_MONTH | cut -c 2-)
      log "SetDayOfMonth stripped 0: DAY_OF_MONTH=$DAY_OF_MONTH"
  fi
  log "SetDayOfMonth DAY_OF_MONTH=$DAY_OF_MONTH"
}

# Function to get current history file
function SetCurrentFile() {
  SetDayOfMonth

  # Get the day for the history file.
  dayForHistoryFile="$(( ( ( (DAY_OF_MONTH-1) /NUM_OF_DAYS_PER_FILE__HA) * \
    NUM_OF_DAYS_PER_FILE__HA) + 1 ))"
  log "SetCurrentFile dayForHistoryFile=$dayForHistoryFile"

  # zero pad the day
  printf -v dayForHistoryFile "%02d" $dayForHistoryFile
  log "SetCurrentFile zero-padded dayForHistoryFile=$dayForHistoryFile"

  ARCHIVE_FILE="$HISTORY_ARCHIVE_DIR/$(date +%Y%m)$dayForHistoryFile.txt"
  log "ARCHIVE_FILE = $ARCHIVE_FILE"
  touch $ARCHIVE_FILE
}


# Define function to access history archive data
function ha() {
    CODE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    python2.7 $CODE_DIR/ha_commands.py -d $HISTORY_ARCHIVE_DIR $@
}




# Activate the history_archive.
PROMPT_COMMAND="${PROMPT_COMMAND:-:} ; PostCommand;"

# Change how `history` displays the last command
HISTTIMEFORMAT="%Y%m%d%H%M%S "
