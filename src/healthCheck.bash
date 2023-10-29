#!/bin/bash
set -o errexit -o pipefail

ports --mine
pid=$(pgrep --uid "$userId" ^ssh)
ramUsed=$(ps --pid "$pid" -o vsz h)
if [[ $ramUsed -lt 100 ]]; then
  exit 1
fi
netLine=$(netstat --wide --tcp | grep --extended-regexp ':22\s+ESTABLISHED$')
if [[ -z $netLine ]]; then
  exit 1
fi
