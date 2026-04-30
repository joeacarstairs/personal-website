#!/bin/sh

make && \
  ( ( sleep 5; comitium refresh --data comitium-data/ ) & ) \
  && agate --content content/ --addr [::]:1965 --addr 0.0.0.0:1965 --lang en-GB
