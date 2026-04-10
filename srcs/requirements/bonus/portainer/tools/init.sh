#!/bin/bash

HASH=$(htpasswd -nbB "${PORTAINER_USER}" "${PORTAINER_PASSWORD}" | cut -d: -f2)

exec /opt/portainer/portainer --admin-username "${PORTAINER_USER}" --admin-password "${HASH}"
