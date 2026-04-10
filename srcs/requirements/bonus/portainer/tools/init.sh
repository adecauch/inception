#!/bin/bash

HASH=$(htpasswd -nbB admin "${PORTAINER_PASSWORD}" | cut -d: -f2)

exec /opt/portainer/portainer --admin-password "${HASH}"
