FROM tomcat:9.0-jre11

ARG VERSION="4.2.0"
ARG BASE_URL="https://apps.egiz.gv.at/releases/pdf-as/release/${VERSION}"

# Install
RUN apt-get update -y && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

# Download pdf-as + its configuration & change the log level in configuration
RUN curl -s -o ${CATALINA_HOME}/webapps/pdf-as-web.war              ${BASE_URL}/pdf-as-web-${VERSION}.war && \
    curl -s -o /tmp/defaultConfig.zip                               ${BASE_URL}/cfg/defaultConfig.zip && \
    unzip -q /tmp/defaultConfig.zip -d                              ${CATALINA_HOME}/conf/pdf-as && rm /tmp/defaultConfig.zip

COPY pdf-as-web.properties ${CATALINA_HOME}/conf/pdf-as/pdf-as-web.properties
COPY setenv.sh ${CATALINA_HOME}/bin/
