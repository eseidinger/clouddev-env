#!/usr/bin/env bash

username=$(whoami)

SUDO=
if type sudo >/dev/null &> /dev/null
then
    SUDO="sudo"
fi

usermod -a -G microk8s $username
