# HistoryArchive
Archive your unix history better

# How to get this working
Add the following to your `~/.bashrc`

    source ~/Projects/HistoryArchive/history_archive.bash
    PROMPT_COMMAND="${PROMPT_COMMAND:-:} ; PostCommand;"

Change the path to history_archive.bash to match your file path.

# How this works
history_archive.bash sets up a trap to save the current command 

    $(BASH_COMMAND)

Then it saves the timestamp, the current directory and this command to a file in ~/history_archive/*.txt files.
