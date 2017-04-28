#!/bin/bash -l
: ${BRANCH=master}

npm install
bower install
grunt build
npm start
