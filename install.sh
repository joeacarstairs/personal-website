#!/bin/sh

doas adduser -h /home/joeac.net joeac.net \
  && cd /home/joeac.net \
  && sudo -u joeac.net git clone https://git.joeac.net/joeac.net.git joeac.net \
  && sudo ln -s /home/joeac.net/joeac.net /usr/local/lib/joeac.net \
  && cd joeac.net \
  && sudo -u joeac.net make \
  && sudo -u joeac.net make install
