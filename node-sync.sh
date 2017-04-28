#!/bin/bash
DIRECTORY=/var/jenkins_home/node_modules
if [ -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
    echo 'Found Cache'
    #ln -s $DIRECTORY
    #cp -a $DIRECTORY ./
    #rsync -av $DIRECTORY ./
    #rsync --quiet -a $DIRECTORY ./
fi
