#!/usr/bin/env bash

pid=$(pgrep --uid "$userId" --exact ssh)
ramUsed=$(ps --pid "$pid" -o vsz h)
if [[ $ramUsed -lt 100 ]]; then
  exit 1
fi
