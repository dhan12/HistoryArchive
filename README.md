# HistoryArchive

Archive your unix history better

# How to get this working

1. Save files to your machine.

   `git clone git@github.com:dhan12/HistoryArchive.git`

2. Add the following two lines to your `~/.bashrc`

   a. `HISTORY_ARCHIVE_DIR=/Users/username/Dropbox/archive/`

   (Change the HISTORY_ARCHIVE_DIR path to some folder where you want to store your history).

   b. `source ~/Projects/HistoryArchive/history_archive.bash`

   (Change the source command to the file you cloned the directory to).

3. Restart your terminal or run `source ~/.bashrc`

   Use unix as usual, and your history should be archived.

   Use `ha` commands for additional functionality.

# Prerequisites / Dependencies

You will need bash and Python (version 2.7). The main script (`history_archive.bash`) is written in bash and a helper function (`ha_commands.py`) is written in Python (for Python 2.7).

# What can you do

1. Get recent history (not much different than regular `history`:

   `ha`

2. See help documentation via

   `ha --help`

3. Personal hack # 1 - use this to keep a quick log of what I am working on.

   In the command line enter comments (non-functional commands like this).

   `# Start work on project a`.

   `# break`

   `# Start work on project b`.

   `# This is another note.`

   Then, view recent notes like this

   `ha -c`
