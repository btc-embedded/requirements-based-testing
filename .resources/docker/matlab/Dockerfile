ARG MATLAB_RELEASE=R2024b

FROM mathworks/matlab:${MATLAB_RELEASE} AS matlab

# Install required matlab products & set up license
ARG MATLAB_RELEASE
#ENV MLM_LICENSE_FILE=27000@matlab.license.server
ARG ML_LIC_PATH=matlab.lic
ENV MLM_LICENSE_FILE=${ML_LIC_PATH}
ARG MATLAB_PRODUCTS="AUTOSAR_Blockset MATLAB_Coder Simulink Simulink_Coder Simulink_Coverage Stateflow"
USER root
RUN apt update && apt-get install -y wget
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && chmod +x mpm \
    && ./mpm install \
    --release=${MATLAB_RELEASE}  \
    --destination=/opt/matlab  \
    --products ${MATLAB_PRODUCTS} \
    && rm -f mpm /tmp/mathworks_root.log \
    && ln -f -s /opt/matlab/bin/matlab /usr/local/bin/matlab

USER matlab
COPY matlab.lic ${ML_LIC_PATH}
