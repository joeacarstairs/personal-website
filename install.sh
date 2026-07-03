#!/bin/sh

set -e

if [ -z "$(which podman 2>/dev/null)" ]
then
  doas apk add podman
fi

if [ -z "$(which podman-compose 2>/dev/null)" ]
then
  doas apk add podman-compose
fi

if [ -z "$(which yq 2>/dev/null)" ]
then
  YQ_PLATFORM="linux_$(expr "$(arch)" : "armv7" && echo arm || expr "$(arch)" : "x86_64" && echo amd64 || arch)"
  wget -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_PLATFORM}
  chmod +x /usr/local/bin/yq
fi

if [ -z "$(which envsubst 2>/dev/null)" ]
then
  if [ "$(arch)" = "x86_64" ] || [ "$(arch)" = "arm64" ]
  then
    wget -O /usr/local/bin/envsubst https://github.com/a8m/envsubst/releases/download/latest/envsubst-Linux-$(arch)
    chmod +x /usr/local/bin/envsubst
  else
    doas apk add go
    go install github.com/a8m/envsubst/cmd/envsubst@latest
  fi
fi

if [ -z "$(which bash 2>/dev/null)" ]
then
  doas apk add bash
fi

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

if ! [ -f DIGITALOCEAN_TOKEN ]
then
  if [ -z "${DIGITALOCEAN_TOKEN}" ]
  then
    read -sp "DIGITALOCEAN_TOKEN: " DIGITALOCEAN_TOKEN
  fi
  echo ${DIGITALOCEAN_TOKEN} > DIGITALOCEAN_TOKEN
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

while read line
do
  if expr "${line}" : "^[[:alnum:]_]\+=" 1>/dev/null
  then
    var_name="$(expr "${line}" "^\([[:alnum:]_]\+\)=")"

    if [ -n "$(grep "^${var_name}=" .env)" ]
    then
      continue
    fi

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
