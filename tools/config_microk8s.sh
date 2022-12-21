#!/usr/bin/env bash

username=$1

usermod -a -G microk8s $username
