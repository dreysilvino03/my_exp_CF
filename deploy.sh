#!/bin/bash

if [[ $# -ge 1 ]]; then
    cd "$1"
fi
sh stack.sh APM-PROD