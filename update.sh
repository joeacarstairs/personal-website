#!/bin/sh

cd /usr/local/lib/joeac.net \
  && git pull \
  && make \
  && make reinstall
