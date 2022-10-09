#!/usr/bin/env bash

function makeConfig {
  printf 'Host tunnel\n'
  printf '  Port 22\n'
  printf '  BatchMode yes\n'
  printf '  StrictHostKeyChecking no\n'
  printf '  AddKeysToAgent yes\n'
  printf '  ForwardAgent yes\n'
  # shellcheck disable=2154
  printf '  HostName %s\n' "$remoteHost"
  # shellcheck disable=2154
  printf '  User %s\n' "$remoteUser"
  printf '  IdentityFile %s\n' "$HOME/identity"
  declare -a envNames=()
  # shellcheck disable=SC2312
  env >.env
  while read -r line; do
    variableName=$(cut --delimiter "=" --fields 1 <<<"$line")
    variableValue=$(cut --delimiter "=" --fields 2- <<<"$line")
    regex="^[a-z][a-zA-Z0-9]+Local$"
    if [[ $variableName =~ $regex ]]; then
      project=${variableName%Local}
      # printf '  # Line = %s\n' "$line"
      # printf '  # Name = %s\n' "$variableName"
      # printf '  # Value = %s\n' "$variableValue"
      remoteVariableName=${project}Remote
      if [[ -n ${!remoteVariableName} ]]; then
        printf '  # Project %s\n' "$project"
        printf '  #         %s:%s → localhost:%s\n' "$remoteHost" "${!remoteVariableName}" "$variableValue"
        printf '  RemoteForward %s localhost:%s\n' "${!remoteVariableName}" "$variableValue"
      fi
    fi
  done <.env
}

makeConfig >sshconfig
cat sshconfig
