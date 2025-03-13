# Starting from public image mathworks/matlab & btces/ep
# with default versions defined below (can be overwritten using build-args)
ARG EP_RELEASE=24.2p0
ARG MATLAB_RELEASE=R2023b

FROM btces/ep:${EP_RELEASE} AS ep
FROM mathworks/matlab:${MATLAB_RELEASE} AS matlab

# ----------------------------------------------------------------------------------------
# MATLAB-specific configurations
# ----------------------------------------------------------------------------------------
# Install required matlab products & set up license
ARG MATLAB_RELEASE
ENV MLM_LICENSE_FILE=27000@matlab.license.server
ARG MATLAB_PRODUCTS="Embedded_Coder AUTOSAR_Blockset MATLAB_Coder Simulink Simulink_Coder Simulink_Coverage Stateflow"
USER root
RUN apt update && apt-get install -y wget
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && chmod +x mpm \
    && ./mpm install \
    --release=${MATLAB_RELEASE}  \
    --destination=/opt/matlab  \
    --products ${MATLAB_PRODUCTS} \
    && rm -f mpm /tmp/mathworks_root.log \
    && ln -f -s /opt/matlab/bin/matlab /usr/local/bin/matlab


# ----------------------------------------------------------------------------------------
# BTC-specific configurations
# ----------------------------------------------------------------------------------------
ENV LICENSE_LOCATION=27000@btc.license.server
# Copy files from public image btces/ep
COPY --chown=1000 --from=ep /opt /opt
COPY --chown=1000 --from=ep /root/.BTC /root/.BTC
# (Optional) to be able to migrate old *.epp profiles:
# COPY --chown=1000 --from=ep-migrator /opt/migrator /opt/migrator

# and some files from the build context
COPY --chown=1000 addMLIntegration.bash /tmp/
RUN sudo chmod +x /tmp/addMLIntegration.bash && sudo /tmp/addMLIntegration.bash && sudo rm /tmp/addMLIntegration.bash

# install python module btc_embedded
RUN pip3 install --no-cache-dir btc_embedded
ENV PYTHONUNBUFFERED=1

# ----------------------------------------------------------------------------------------
# Optimizing the image
# ----------------------------------------------------------------------------------------
USER matlab

# Initialize BTC EmbeddedPlatform REST API for faster startup
RUN python3 -c "from btc_embedded import EPRestApi;ep=EPRestApi(skip_matlab_start=True);exit()"  && rm ${LOG_DIR}/current.log

# Override default MATLAB entrypoint
ENTRYPOINT [ ]
CMD [ ]
