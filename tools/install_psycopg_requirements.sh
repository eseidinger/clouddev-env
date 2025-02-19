#!/usr/bin/env bash

# TODO

if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} apt-get update
${SUDO} apt-get install -y libpq-dev
