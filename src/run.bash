#!/usr/bin/env bash
set -o errexit -o pipefail

function makeConfig {
  # shellcheck disable=2154
  printf '  HostName %s\n' "$remoteHost"
  # shellcheck disable=2154
  printf '  User %s\n' "$remoteUser"
  printf '  IdentityFile %s\n' "$HOME/identity"
  printf '  UserKnownHostsFile %s\n' "$HOME/known_hosts"
  declare -a envNames=()
  env >.env
  while read -r line; do
    variableName=$(cut --delimiter "=" --fields 1 <<<"$line")
    variableValue=$(cut --delimiter "=" --fields 2- <<<"$line")
    regex="^[a-z0-9][a-zA-Z0-9]+Local$"
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

makeConfig >>ssh_config
if [[ -n $debug ]]; then
  cat ssh_config
fi
${sshCommand?}
