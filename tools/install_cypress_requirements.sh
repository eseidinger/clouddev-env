#!/usr/bin/env bash

# TODO

if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} apt-get update
${SUDO} apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb
