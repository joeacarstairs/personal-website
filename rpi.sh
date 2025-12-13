#!/bin/sh

DOCKER_BIN=podman
WEBSITE_DIR="$HOME/joeac.net"
PORT=80

set -eux

$DOCKER_BIN stop --all
cd "$WEBSITE_DIR"
git pull
$DOCKER_BIN build -t joeac.net .
$DOCKER_BIN run -dt -p $PORT:4321 joeac.net

