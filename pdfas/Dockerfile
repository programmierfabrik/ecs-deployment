FROM tomcat:9.0-jre11

ARG VERSION="4.2.0"
ARG BASE_URL="https://apps.egiz.gv.at/releases/pdf-as/release/${VERSION}"

# Install
RUN apt-get update -y && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir ${CATALINA_HOME}/conf/pdf-as

# Download pdf-as + its configuration & change the log level in configuration
RUN curl -s -o ${CATALINA_HOME}/webapps/pdf-as-web.war              ${BASE_URL}/pdf-as-web-${VERSION}.war && \
    curl -s -o /tmp/defaultConfig.zip                               ${BASE_URL}/cfg/defaultConfig.zip && \
    unzip -q /tmp/defaultConfig.zip -d                              ${CATALINA_HOME}/conf/pdf-as && rm /tmp/defaultConfig.zip

# tell connector that our uplink is a https proxy and reconnects should go to https
# RUN sed ${CATALINA_HOME}/conf/server.xml -r -i -e 's/(<Connector port="8080" protocol="HTTP\/1.1").*$/\1 secure="true" scheme="https" proxyPort="443"/'

COPY pdf-as-web.properties ${CATALINA_HOME}/conf/pdf-as/pdf-as-web.properties
COPY setenv.sh ${CATALINA_HOME}/bin/

# Disable expired let's encrypt certificates and download the new one
# update-ca-certificates also updates the java keystore
# RUN sed -i -e 's|mozilla/DST_Root_CA_X3.crt|#mozilla/DST_Root_CA_X3.crt|g' /etc/ca-certificates.conf && \
#     sed -i -e 's|mozilla/ISRG_Root_X1.crt|#mozilla/ISRG_Root_X1.crt|g' /etc/ca-certificates.conf && \
#     wget --no-check-certificate https://letsencrypt.org/certs/isrgrootx1.pem -O /usr/local/share/ca-certificates/isrgrootx1.crt && \
#     /usr/sbin/update-ca-certificates --fresh
