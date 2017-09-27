FROM openjdk:8-slim

ENV KEYBOX_VERSION=2.90.01 \
    KEYBOX_FILENAME=2.90_01

RUN apt-get update && apt-get -y install wget && \
    wget https://github.com/skavanagh/KeyBox/releases/download/v${KEYBOX_VERSION}/keybox-jetty-v${KEYBOX_FILENAME}.tar.gz && \
    tar xzf keybox-jetty-v${KEYBOX_FILENAME}.tar.gz && \
    rm keybox-jetty-v${KEYBOX_FILENAME}.tar.gz && \
    apt-get remove --purge -y wget && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && \
    chgrp -R 0 /KeyBox-jetty && chmod -R g=u /KeyBox-jetty

WORKDIR /KeyBox-jetty
USER 1001
CMD ["/KeyBox-jetty/startKeyBox.sh"]
