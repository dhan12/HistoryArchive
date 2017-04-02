#!/bin/bash

#
# Enviornment variables
#
REFRESH_REQUIREMENTS=
if [ $# -gt 0 ]; then
    if [[ $1 -eq "refresh" ]]; then
        REFRESH_REQUIREMENTS=1
    fi
fi

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VENV_DIR=$THIS_DIR/../venv


#
# Setup environment
#
virtualenv $VENV_DIR
. $VENV_DIR/bin/activate
if [[ $REFRESH_REQUIREMENTS -eq 1 ]]; then
    pip install -r $THIS_DIR/requirements.txt
fi


#
# Run tests
#
coverage run $VENV_DIR/bin/pytest test
if [[ $? -eq 0 ]]; then
    coverage report -m --omit=$VENV_DIR/*
    pep8 --ignore=E402 ha_commands.py test/
fi


#
# Exit
#
deactivate
