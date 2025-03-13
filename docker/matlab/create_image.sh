#!/bin/bash
MATLAB_RELEASE=$(grep '^MATLAB_RELEASE=' ../versions.properties | cut -d'=' -f2-)

# Build the docker image
docker build \
    --no-cache \
    --build-arg MATLAB_RELEASE=$MATLAB_RELEASE \
    -t matlab:$MATLAB_RELEASE \
    .
