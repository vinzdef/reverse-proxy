#!/bin/sh

docker-compose \
    -f docker-compose.yml \
    -f docker-compose-letsencrypt.yml \
    up -d
