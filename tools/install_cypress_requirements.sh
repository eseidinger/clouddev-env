#!/usr/bin/env bash

if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} apt-get update
${SUDO} apt-get install libgtk2.0-0t64 libgtk-3-0t64 libgbm-dev libnotify-dev libnss3 libxss1 libasound2t64 libxtst6 xauth xvfb
