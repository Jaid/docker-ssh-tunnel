# syntax=docker/dockerfile:1

ARG builderImage
ARG runnerImage

FROM $builderImage AS build

FROM $runnerImage

COPY --from=build /usr/bin/ports /usr/bin/ports
ADD --chown=$userId:$groupId content .
ENV debug=
ENV sshCommand ssh -- -T -N -n -x -v -F ssh_config tunnel
VOLUME /app/identity
