#!/usr/bin/env bash

username=$1

usermod -a -G docker $username
