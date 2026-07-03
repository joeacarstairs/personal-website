#!/bin/sh

set -e

doas adduser -h /home/joeac.net joeac.net

cd /home/joeac.net
sudo -u joeac.net git clone https://git.joeac.net/joeac.net.git joeac.net
sudo ln -s /home/joeac.net/joeac.net /usr/local/lib/joeac.net
cd joeac.net

if [ -z "${DIGITALOCEAN_TOKEN}" ]
then
  read -sp "DIGITALOCEAN_TOKEN: " DIGITALOCEAN_TOKEN
fi
echo ${DIGITALOCEAN_TOKEN} > DIGITALOCEAN_TOKEN

while read line
do
  if expr "${line}" : "^[[:alnum:]_]\+=" 1>/dev/null
  then
    var_name="$(expr "${line}" "^\([[:alnum:]_]\+\)=")"
    if [ -z "${!var_name}" ]
    then
      default_value="$(expr "${line}" "^[[:alnum:]_]\+=\(.*\)\$")"
      read -sp "${var_name}: " ${var_name}
      if [ -z "${!var_name}" ]
      then
        eval ${var_name}="${default_value}"
      fi
    fi
    echo "${var_name}=${!var_name}" >> .env
  fi
done <example.env

sudo -u joeac.net make
sudo -u joeac.net make install
