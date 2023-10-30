#!/bin/bash
set -o errexit -o pipefail

if [[ -n $xtrace && $xtrace != 0 && $xtrace != false ]]; then
  set -o xtrace
fi

if [[ -n $debug && $debug != 0 && $debug != false ]]; then
  /usr/bin/ports --mine
fi
pid=$(pgrep --uid "${userId?}" ^ssh)
if [[ -n $debug && $debug != 0 && $debug != false ]]; then
  printf 'pid = %s\n' "$pid"
fi
ramUsed=$(ps --pid "$pid" -o vsz h)
if [[ -n $debug && $debug != 0 && $debug != false ]]; then
  printf 'ramUsed = %s\n' "$ramUsed"
fi
if [[ $ramUsed -lt 100 ]]; then
  exit 1
fi
netLine=$(netstat --wide --tcp | grep --extended-regexp ':22\s+ESTABLISHED$')
if [[ -n $debug && $debug != 0 && $debug != false ]]; then
  printf 'netLine = %s\n' "$netLine"
fi
if [[ -z $netLine ]]; then
  exit 1
fi
