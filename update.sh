#!/bin/sh

cd /home/joeac.net/joeac.net \
  && sudo -u joeac.net git pull \
  && sudo -u joeac.net make \
  && sudo -u joeac.net XDG_RUNTIME_DIR=/tmp/xdg/$(id -u joeac.net)-xdg-runtime-dir make reinstall
