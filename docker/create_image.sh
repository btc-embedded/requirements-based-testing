#!/bin/bash

# Create the BTC docker image based on the targetlink image
# (versions are extracted from the versions.properties file)

TARGETLINK_URL=$(grep '^TARGETLINK_URL=' ../versions.properties | cut -d'=' -f2-)
TL_RELEASE=$(echo "$TARGETLINK_URL" | grep -oE 'targetlink-[0-9]+\.[0-9]+\.[0-9]+-[0-9]+' | sed 's/targetlink-//')
BTC_RELEASE=$(grep '^BTC_RELEASE=' ../versions.properties | cut -d'=' -f2-)

# Build the docker image
docker build \
    --no-cache \
    --build-arg TL_RELEASE=$TL_RELEASE \
    --build-arg BTC_RELEASE=$BTC_RELEASE \
    -t btc-ep:$BTC_RELEASE .

