# syntax=docker/dockerfile:1

ARG builderImage
ARG runnerImage

FROM $builderImage AS build

FROM $runnerImage

COPY --from=build /usr/bin/ports /usr/bin/ports
ADD --chown=$userId:$groupId content .
ENV debug false
ENV managePermissions false
# -T = Disable pseudo-tty allocation.
# -N = Do not execute a remote command. This is useful for just forwarding ports.
# -n = Redirects stdin from /dev/null (actually, prevents reading from stdin). This must be used when ssh is run in the background.
# -x = Disables X11 forwarding.
# -v = Verbose mode. Causes ssh to print debugging messages about its progress. This is helpful in debugging connection, authentication, and configuration problems.
# -F = Specifies the path to an alternative per-user configuration file. If a configuration file is given on the command line, the system-wide configuration file (/etc/ssh/ssh_config) will be ignored.
# See: https://linux.die.net/man/1/ssh
ENV sshCommand ssh -T -N -n -x -v -F ssh_config tunnel
VOLUME /app/identity
