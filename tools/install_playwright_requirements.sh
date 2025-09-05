#!/usr/bin/env bash

if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} apt-get update
${SUDO} apt-get install -y libnss3 libatk-bridge2.0-0 libxss1 libasound2t64 libgbm1 libgtk-3-0 libxshmfence-dev libxrandr2 libxcomposite1 libxcursor1 libxdamage1 libxi6
