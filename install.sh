#!/bin/sh

set -e

if [ -z "$(which podman 2>/dev/null)" ]
then
  sudo apk add podman
fi

if [ -z "$(which podman-compose 2>/dev/null)" ]
then
  sudo apk add podman-compose
fi

if [ -z "$(which yq 2>/dev/null)" ]
then
  YQ_PLATFORM="linux_$(expr "$(arch)" : "armv7" && echo arm || expr "$(arch)" : "x86_64" && echo amd64 || arch)"
  sudo wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_PLATFORM}
  sudo chmod +x /usr/local/bin/yq
fi

if [ -z "$(which envsubst 2>/dev/null)" ]
then
  if [ "$(arch)" = "x86_64" ] || [ "$(arch)" = "arm64" ]
  then
    ENVSUBST_VERSION=1.4.3
    sudo wget -O /usr/local/bin/envsubst https://github.com/a8m/envsubst/releases/download/v${ENVSUBST_VERSION}/envsubst-Linux-$(arch)
    sudo chmod +x /usr/local/bin/envsubst
  else
    sudo apk add go
    go install github.com/a8m/envsubst/cmd/envsubst@latest
  fi
fi

if [ -z "$(which bash 2>/dev/null)" ]
then
  sudo apk add bash
fi

if [ -z "$(grep "\bjoeac.net\b" /etc/group)" ]
then
  sudo adduser -D -h /home/joeac.net joeac.net
  sudo adduser joeac.net joeac.net
  sudo adduser $(whoami) joeac.net
fi

if ! [ -d /home/joeac.net/joeac.net/.git ]
then
  sudo -u joeac.net git clone https://git.joeac.net/joeac/joeac.net.git /home/joeac.net/joeac.net
fi
sudo chown joeac.net:joeac.net /home/joeac.net/joeac.net
sudo chmod 765 /home/joeac.net/joeac.net

if ! [ -h /usr/local/lib/joeac.net ]
then
  sudo ln -s /home/joeac.net/joeac.net /usr/local/lib/joeac.net
fi

if ! [ -f DIGITALOCEAN_TOKEN ]
then
  if [ -z "${DIGITALOCEAN_TOKEN}" ]
  then
    read -sp "DIGITALOCEAN_TOKEN: " DIGITALOCEAN_TOKEN
  fi
  echo ${DIGITALOCEAN_TOKEN} > /home/joeac.net/joeac.net/DIGITALOCEAN_TOKEN
fi

if ! ( podman secret exists remote_smtp_password )
then
  if [ -z "${REMOTE_SMTP_PASSWORD}" ]
  then
    read -sp "REMOTE_SMTP_PASSWORD: " REMOTE_SMTP_PASSWORD
  fi
  echo "${REMOTE_SMTP_PASSWORD}" | podman secret create remote_smtp_password -
  unset REMOTE_SMTP_PASSWORD
fi

sudo -u joeac.net touch /home/joeac.net/joeac.net/.env
while read line
do
  if expr "${line}" : "[[:alnum:]_]\+=" 1>/dev/null
  then
    var_name="$(expr "${line}" : "\([[:alnum:]_]\+\)=")"

    if [ -n "$(grep "^${var_name}=" /home/joeac.net/joeac.net/.env)" ]
    then
      continue
    fi

    if [ -z "$(expr "$(env | grep "^${var_name}=")" : "${var_name}=\(.*\)\$")" ]
    then
      default_value="$(expr "${line}" : "[[:alnum:]_]\+=\(.*\)\$")"
      read -sp "${var_name}: " ${var_name}
      if [ -z "${!var_name}" ]
      then
        eval ${var_name}="${default_value}"
      fi
    fi

    echo "${var_name}=${!var_name}" >> /home/joeac.net/joeac.net/.env
  fi
done </home/joeac.net/joeac.net/example.env

sudo -u joeac.net make --directory=/home/joeac.net/joeac.net
sudo -u joeac.net make --directory=/home/joeac.net/joeac.net install
