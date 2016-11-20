#!/bin/bash

# Parameters

# Each file will contain commands that are grouped together by date/time.
# Change this variable to put more or less commands in a given file.
NUM_OF_DAYS_PER_FILE__HA=7


# Name of directory to put files.
# Files will be put into $(HOME)/ARCHIVE_NAME__HA
ARCHIVE_NAME__HA=history_archive


# Function that will run prior to each command
function PreCommand() {
  current_command=$BASH_COMMAND
  # echo "in PreCommand $current_command"
  if [ -z "$READY_TO_ARCHIVE__HA" ]; then
    return
  fi
  unset READY_TO_ARCHIVE__HA

  # echo "in PreCommand $current_command (saving)"
  #
  # Execute the following before prompt is drawn.
  #

  # Set the archive_file.
  # It must be called every time. It changes over time.
  SetCurrentFile

  # Save data to the file
  line="$time_stamp $(pwd) $current_command"
  echo "$line" >> $ARCHIVE_FILE
}
trap "PreCommand" DEBUG

# Function that will run after each command.
# It just sets variables so that grouped commands like
#   $ cmd1 && cmd2 && cmd3
# will only be processed once.
function PostCommand() {
  # echo "in PostCommand"
  READY_TO_ARCHIVE__HA=1
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
alias ha='tail -100 $ARCHIVE_FILE'


# Activate the history_archive.
PROMPT_COMMAND="${PROMPT_COMMAND:-:} ; PostCommand;"
