#!/bin/sh

if [ -z "${XDG_RUNTIME_DIR}" ]
then
  export XDG_RUNTIME_DIR=/tmp/xdg/$(id -u joeac.net)-xdg-runtime-dir
fi

cd /home/joeac.net/joeac.net \
  && sudo -u joeac.net git pull \
  && sudo -u joeac.net make \
  && sudo -u joeac.net make reinstall
