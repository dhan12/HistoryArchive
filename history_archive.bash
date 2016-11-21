#!/bin/bash

# Parameters

# Each file will contain commands that are grouped together by date/time.
# Change this variable to put more or less commands in a given file.
NUM_OF_DAYS_PER_FILE__HA=7


# Name of directory to put files.
# Files will be put into $(HOME)/ARCHIVE_NAME__HA
ARCHIVE_NAME__HA=Dropbox/history_archive/home/


# Function that will run prior to each command
# Set some variables for later usage, see PostCommand.
function PreCommand() {
  CURRENT_COMMAND=$BASH_COMMAND
  if [ -z ${START_DIR} ]; then
    START_DIR=$(pwd)
    START_TIME_STAMP=$(date +%Y%m%d%H%M%S)
    # echo "PreCommand set new starting dir $START_DIR"
  fi
}
trap "PreCommand" DEBUG

# Function that will run after each command.
function PostCommand() {
  # echo "in PostCommand"

  # Get last executed line from 'history'
  history_line=$(history | tail -1)
  tokens=( $history_line )
  tokenIndex=0
  cmd=""
  for word in $history_line; do
      if [ "$tokenIndex" -lt 2 ]; then
          tokenIndex=$(( tokenIndex + 1 ))
          continue
      fi
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
  
  # Save file to the archive
  if [ "$save_file" -eq 1 ]; then
      SetCurrentFile
      echo "$line_to_archive" >> $ARCHIVE_FILE
  fi

  # Update variables for the next round
  prev_history_line="$history_line"
  unset START_DIR
  unset CURRENT_COMMAND
}


# Function to get current history file
function SetCurrentFile() {

  time_stamp=$(date +%Y%m%d%H%M%S)
  day=$(date +%d)

  # Get the day for the history file.
  dayForHistoryFile=$(( ( ( (day-1) /NUM_OF_DAYS_PER_FILE__HA) * \
    NUM_OF_DAYS_PER_FILE__HA) + 1 ))
  if [ $dayForHistoryFile -lt 10 ]; then
    dayForHistoryFile="0$dayForHistoryFile"
  fi

  ARCHIVE_FILE="$archive_dir/$(date +%Y%m)$dayForHistoryFile.txt"
  touch $ARCHIVE_FILE
}


# Get the directory to save data to
current_user=$(whoami)
home_dir=$(eval echo ~${current_user})
archive_dir="$home_dir/$ARCHIVE_NAME__HA"
mkdir -p $archive_dir


# Some convenience functions
alias ha='SetCurrentFile ; tail -100 $ARCHIVE_FILE'

# Activate the history_archive.
PROMPT_COMMAND="${PROMPT_COMMAND:-:} ; PostCommand;"

HISTTIMEFORMAT="%Y%m%d%H%M%S "
