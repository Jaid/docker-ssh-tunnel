#!/usr/bin/env bash
set -o errexit -o pipefail

if [[ -n $xtrace && $xtrace != 0 && $xtrace != false ]]; then
  set -o xtrace
fi

function makeConfig {
  # shellcheck disable=2154
  printf '  HostName %s\n' "$remoteHost"
  # shellcheck disable=2154
  identityFile=$HOME/identity
  if [[ -d $identityFile ]]; then
    identityFile=$(find "$identityFile" -type f -print)
  fi
  printf '  User %s\n' "${remoteUser?}"
  printf '  IdentityFile %s\n' "$identityFile"
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
        host=localhost
        port=$variableValue
        if [[ $port =~ : ]]; then
          host=$(cut --delimiter ":" --fields 1 <<<"$port")
          port=$(cut --delimiter ":" --fields 2- <<<"$port")
        fi
        printf '  #         %s:%s → %s:%s\n' "$remoteHost" "${!remoteVariableName}" "$host" "$port"
        printf '  RemoteForward %s %s:%s\n' "${!remoteVariableName}" "$host" "$port"
      fi
    fi
  done <.env
}

makeConfig >>ssh_config
if [[ -n $debug && $debug != 0 && $debug != false ]]; then
  cat ssh_config
fi
if [[ -n $managePermissions && $managePermissions != 0 && $managePermissions != false ]]; then
  chmod 600 ssh_config
  chmod 600 "$HOME/identity"
fi
${sshCommand?}
