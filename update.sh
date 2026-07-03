#!/bin/sh

cd /home/joeac.net/joeac.net \
  && sudo -u joeac.net git pull \
  && sudo -u joeac.net make \
  && sudo -u joeac.net make reinstall
