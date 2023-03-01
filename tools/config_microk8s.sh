#!/usr/bin/env bash

username=$(whoami)

SUDO=
if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

${SUDO} usermod -a -G microk8s $username
