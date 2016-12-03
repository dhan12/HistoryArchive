# HistoryArchive
Archive your unix history better

# How to get this working

1. Save history_archive.bash to your machine.

2. Add the following two lines to your `~/.bashrc`

   HISTORY_ARCHIVE_DIR=/Users/username/Dropbox/archive/
   source ~/Projects/HistoryArchive/history_archive.bash

   (Change the HISTORY_ARCHIVE_DIR path to some folder where you want to store your history).

3. Restart your terminal or run `source ~/.bashrc`

# Prerequisites / Dependencies
The main script (history_archive.bash) is written in bash and a helper function (`ha_commands.py`) is written in Python. 

# What can you do

1. Get recent history (not much different than regular `history`:

   `ha`

2. Use command line history as a note taking tool. 

   In the command line enter comments (non-functional commands like this).
   
   `# This is a note.`
   `# This is another note.`

   Then, we can expose notes by doing a command like

   `ha --notes`

   which could print out recent notes.

