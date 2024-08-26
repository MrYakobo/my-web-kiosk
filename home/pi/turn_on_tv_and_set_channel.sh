#!/usr/bin/env bash

# turn on TV
echo "on 0" | cec-client -s -d 1

sleep 1

# set channel
echo "as" | cec-client -s -d 1