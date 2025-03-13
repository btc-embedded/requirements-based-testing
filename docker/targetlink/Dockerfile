ARG MATLAB_RELEASE=R2024b

FROM matlab:${MATLAB_RELEASE}

ARG DSPACE_EULA_VERSION=2024b \
    DSPACE_TARGETLINK_VERSION=24.1.0

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DSPACE_EULA_VERSION=${DSPACE_EULA_VERSION} \
    DSPACE_TARGETLINK_VERSION=${DSPACE_TARGETLINK_VERSION} \
    LICENSE_SERVER=dspace-1964.prom.local

USER root

RUN \
    cd /tmp && \
    apt update && \
    apt install -y wget && \
    . /etc/os-release && \
    wget https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb  && \
    echo "deb [trusted=yes] http://localhost/ ./" > /etc/apt/sources.list.d/targetlink.list && \
    apt update && \
    echo dspace-eula-${DSPACE_EULA_VERSION} dspace/all boolean true | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install dspace-eula-${DSPACE_EULA_VERSION} dspace-targetlink-${DSPACE_TARGETLINK_VERSION} -y && \
    rm /etc/apt/sources.list.d/targetlink.list && \
    rm -rf /var/lib/apt/lists/*

ADD --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

# COPY dspace /home/matlab/dspace
# ADD --chmod=755 startup.m /home/matlab/Documents/MATLAB/startup.m

# Set user and work directory
USER matlab
WORKDIR /home/matlab
CMD ["matlab"]
