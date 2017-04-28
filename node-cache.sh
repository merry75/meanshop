#!/bin/bash
DIRECTORY=/var/jenkins_home/
if [ -d "$DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
    echo 'Caching node_modules'
    #rsync --quiet -a node_modules $DIRECTORY/
    #rm node_modules
fi
