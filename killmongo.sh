#!/bin/bash
MONGOPID=mongopid
if [ -d "$MONGOPID" ]; then
    # Control will enter here if $MONGOPID exists.
    echo 'Killing MongoDB'
    kill -HUP `cat mongopid`
    rm mongopid
fi
