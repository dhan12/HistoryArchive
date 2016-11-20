# HistoryArchive
Archive your unix history better

# How to get this working

1. Save history_archive.bash to your machine.

2. Add the following to your `~/.bashrc`

    source ~/Projects/HistoryArchive/history_archive.bash  
    (Change the path to history_archive.bash to match your file path).

# How this works
history_archive.bash sets up a `trap` to capture the current command "$(BASH_COMMAND)". This command, along with the current timestamp and directory, are written to a txt file in ~/history_archive/.


# TODO
- fix multiple statement in one line bug
