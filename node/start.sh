#!/bin/bash -l

if [ ! -z ${MEANGO_HOST+x} ]
  then
    echo "$MEANGO_HOST meango.meangohost.com meango">>/etc/hosts
fi

if [ ! -z ${MEANGO_DEBUG+x} ]
  then
    echo '>>>>>>>>>>>>>>DEBUG<<<<<<<<<<<<<<<<<<<<'
    env
    cat /etc/hosts
    echo "meango host = $MEANGO_HOST"
    if [[ ${MEANGO_DEBUG} == "du" ]]; then
      echo '>>>>HOGS in meanshop are:<<<<'
      du -sh /meanshop/*
      echo '<<<<<<<<<END HOGS>>>>>>>>>'
    fi
    echo '>>>>>>>>>>>>>>>>>END_DEBUG<<<<<<<<<<<<<<<<<<'
fi

npm start
