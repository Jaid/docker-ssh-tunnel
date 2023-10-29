# syntax=docker/dockerfile:1

FROM jaidchen/builder:6.0.0 AS build

FROM jaidchen/runner:5.0.0

COPY --from=build /usr/bin/ports /usr/bin/ports
ADD --chown=$userId:$groupId content .
VOLUME /app/identity
