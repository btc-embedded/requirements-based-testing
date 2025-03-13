# Starting from public image mathworks/matlab & btces/ep
# with default versions defined below (can be overwritten using build-args)
ARG BTC_RELEASE=25.1p0
ARG TL_RELEASE=24.1p1

#FROM btces/ep:${BTC_RELEASE} AS ep
FROM harbor.btc-es.local/ep/ep-25.1p0:sprint2 as ep
FROM targetlink:${TL_RELEASE} AS targetlink

ENV LICENSE_LOCATION=27000@btc.license.server
# Copy files from public image btces/ep
COPY --chown=1000 --from=ep /opt /opt
COPY --chown=1000 --from=ep /root/.BTC /root/.BTC
# (Optional) to be able to migrate old *.epp profiles:
# COPY --chown=1000 --from=ep-migrator /opt/migrator /opt/migrator

# integrate BTC with MATLAB
RUN sudo chmod +x /opt/ep/addMLIntegration.bash && sudo /opt/ep/addMLIntegration.bash

# install python module btc_embedded
RUN pip3 install --no-cache-dir btc_embedded
ENV PYTHONUNBUFFERED=1

USER matlab

# Initialize BTC EmbeddedPlatform REST API for faster startup
RUN python3 -c "from btc_embedded import EPRestApi;ep=EPRestApi(skip_matlab_start=True);exit()"  && rm ${LOG_DIR}/current.log

# Override default MATLAB entrypoint
ENTRYPOINT [ ]
CMD [ ]
