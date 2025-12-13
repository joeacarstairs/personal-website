#!/bin/bash

DOCKER_BIN=podman
CONTAINER=joeac.net
PORT=80

set -eu

running_containers=`$DOCKER_BIN ps | tail -n +2`
IFS=$'\n'
for line in $running_containers; do
	if [[ "$line" =~ ^[a-z0-9]+[[:space:]]+localhost/$CONTAINER:[0-9a-z]+[[:space:]] ]]; then
		$DOCKER_BIN stop $(echo "$line" | cut -d' ' -f 1)
	fi
done

set -x
$DOCKER_BIN run -dt -p $PORT:4321 $CONTAINER

