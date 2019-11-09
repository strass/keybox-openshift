FROM openjdk:14-slim

ENV KEYBOX_VERSION=3.08.01 \
    KEYBOX_FILENAME=3.08_01 \
    DOCKERIZE_VERSION=0.6.1

RUN apt-get update && apt-get -y install wget
RUN wget --quiet https://github.com/bastillion-io/Bastillion/releases/download/v${KEYBOX_VERSION}/bastillion-jetty-v${KEYBOX_FILENAME}.tar.gz && \
    wget --quiet https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz && \
    tar xzf bastillion-jetty-v${KEYBOX_FILENAME}.tar.gz -C /opt && \
    tar xzf dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz -C /usr/local/bin && \
    mv /opt/bastillion-jetty /opt/bastillion && \
    rm bastillion-jetty-v${KEYBOX_FILENAME}.tar.gz dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz && \
    apt-get remove --purge -y wget && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && \
    # create db directory for later permission update
    mkdir /opt/bastillion/jetty/bastillion/WEB-INF/classes/keydb && \
    # remove default config - will be written by dockerize on startup
    rm /opt/bastillion/jetty/bastillion/WEB-INF/classes/KeyBoxConfig.properties && \
    # correct permission for running as non-root (f.e. on OpenShift)
    chgrp -R 0 /opt/bastillion && \
    chmod -R g=u /opt/bastillion

# persistent data of KeyBox is stored here
VOLUME /opt/bastillion/jetty/bastillion/WEB-INF/classes/keydb

# this is the home of KeyBox
WORKDIR /opt/bastillion

# dont run as root
USER 1001

# KeyBox listens on 8443 - HTTPS
EXPOSE 8443

# KeyBox configuration template for dockerize
ADD KeyBoxConfig.properties.tpl /opt

# Configure Jetty
ADD jetty-start.ini /opt/bastillion/jetty/start.ini

# Custom Jetty start script
ADD startKeyBox.sh /opt/bastillion/startKeyBox.sh

ENTRYPOINT ["/usr/local/bin/dockerize"]
CMD ["-template", \
     "/opt/KeyBoxConfig.properties.tpl:/opt/bastillion/jetty/bastillion/WEB-INF/classes/KeyBoxConfig.properties", \
     "/opt/bastillion/startKeyBox.sh"]
