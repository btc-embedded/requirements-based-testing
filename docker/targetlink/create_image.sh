#!/bin/bash

# URL of the file to download
MATLAB_RELEASE=$(grep '^MATLAB_RELEASE=' ../versions.properties | cut -d'=' -f2-)
TARGETLINK_URL=$(grep '^TARGETLINK_URL=' ../versions.properties | cut -d'=' -f2-)
TL_RELEASE=$(echo "$TARGETLINK_URL" | grep -oE 'targetlink-[0-9]+\.[0-9]+\.[0-9]+' | sed 's/targetlink-//')
DSPACE_RELEASE="20${TL_RELEASE:0:2}b"

# Download targetlink for ubuntu
wget "$TARGETLINK_URL" -O dspace-targetlink-24.1.0-2245141_jammy_amd64.tgz

# Extract the files
tar -xzf dspace-targetlink-24.1.0-2245141_jammy_amd64.tgz
cp dockerfile/entrypoint.sh .
mkdir -p data
tar -xf packages.tar -C data

# run nginx container to serve deb-repo with targetlink files
docker run --rm -it -d --name nginx -p 80:80 -v ${PWD}/data:/usr/share/nginx/html:ro nginx

# Build the docker image
docker build \
    --no-cache \
    --network=host \
    --build-arg MATLAB_RELEASE=$MATLAB_RELEASE \
    --build-arg DSPACE_TARGETLINK_VERSION=$TL_RELEASE \
    --build-arg DSPACE_EULA_VERSION=$DSPACE_RELEASE \
    -t targetlink:$TL_RELEASE \
    .

# Stop the nginx container
docker stop nginx
