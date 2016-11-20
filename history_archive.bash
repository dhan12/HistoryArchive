#!/bin/bash

# Parameters

# Each file will contain commands that are grouped together by date/time.
# Change this variable to put more or less commands in a given file.
num_of_days_per_file=7


# Name of directory to put files.
# Files will be put into $(HOME)/archive_name
archive_name=history_archive


# Function that will run prior to each command
function PreCommand() {
  current_command=$BASH_COMMAND
  if [ -z "$AT_PROMPT" ]; then
    return
  fi
  unset AT_PROMPT

  #
  # Execute the following before prompt is drawn.
  #

  # Get date/time information
  time_stamp=$(date +%Y%m%d%H%M%S)
  day=$(date +%d)
  setDayForHistoryFile $day
  archive_file="$archive_dir/$(date +%Y%m)$dayForHistoryFile.txt"

  # Save data to the file
  command_path=$(pwd)
  line="$time_stamp $command_path $current_command" 
  echo "$line" >> $archive_file
}
trap "PreCommand" DEBUG

# Function that will run after each command.
# It just sets variables so that grouped commands like
#   $ cmd1 && cmd2 && cmd3 
# will only be processed once.
FIRST_PROMPT=1
function PostCommand() {
  AT_PROMPT=1

  if [ -n "$FIRST_PROMPT" ]; then
    unset FIRST_PROMPT
    return
  fi
}


# Get the day for the history file.
function setDayForHistoryFile() {
    dayForHistoryFile=$(( ( ( (day-1) /num_of_days_per_file) * \
        num_of_days_per_file) + 1 )) 
    if [ $dayForHistoryFile -lt 10 ]; then
        dayForHistoryFile="0$dayForHistoryFile"
    fi
}

# Get the directory to save data to
current_user=$(whoami)
home_dir=$(eval echo ~${current_user})
archive_dir="$home_dir/$archive_name"
mkdir -p $archive_dir
