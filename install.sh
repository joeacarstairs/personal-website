#!/bin/sh

DEPENDENCIES="podman podman-compose yq envsubst bash"
for dep in ${DEPENDENCIES}
do
  if [ -z "$(which ${dep} 2>/dev/null)" ]
  then
    echo "Cannot install: missing required dependency ${dep}. Install ${dep}, then try again."
    exit 1
  fi
done

set -e

if [ -z "$(grep "\bjoeac.net\b" /etc/group)" ]
then
  doas adduser -h /home/joeac.net joeac.net
fi

cd /home/joeac.net
if ! [ -d joeac.net/.git ]
then
  sudo -u joeac.net git clone https://git.joeac.net/joeac.net.git joeac.net
fi
cd joeac.net

if ! [ -h /usr/local/lib/joeac.net ]
then
  sudo ln -s /home/joeac.net/joeac.net /usr/local/lib/joeac.net
fi

if [ -z "${DIGITALOCEAN_TOKEN}" ]
then
  read -sp "DIGITALOCEAN_TOKEN: " DIGITALOCEAN_TOKEN
fi
echo ${DIGITALOCEAN_TOKEN} > DIGITALOCEAN_TOKEN

if ! ( podman secret exists remote_smtp_password )
then
  if [ -z "${REMOTE_SMTP_PASSWORD}" ]
  then
    read -sp "REMOTE_SMTP_PASSWORD: " REMOTE_SMTP_PASSWORD
  fi
  echo "${REMOTE_SMTP_PASSWORD}" | podman secret create remote_smtp_password -
  unset REMOTE_SMTP_PASSWORD
fi

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
