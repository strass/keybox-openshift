#!/bin/bash

function savejceks {
  # copy JCEKS to persistent folder
  echo "[startKeyBox.sh INFO] copy JCEKS file to a save place"
  cp /opt/keybox/jetty/keybox/WEB-INF/classes/keybox.jceks \
     /opt/keybox/jetty/keybox/WEB-INF/classes/keydb/keybox.jceks
}

trap savejceks EXIT

# restore keybox.jceks from persistent storage
if [ -f /opt/keybox/jetty/keybox/WEB-INF/classes/keydb/keybox.jceks ]; then
  echo "[startKeyBox.sh INFO] restoring JCEKS file from persistent storage"
  cp /opt/keybox/jetty/keybox/WEB-INF/classes/keydb/keybox.jceks \
     /opt/keybox/jetty/keybox/WEB-INF/classes/keybox.jceks
fi

# change to jetty dir and start jetty
cd jetty
java -Xms1024m -Xmx1024m -jar start.jar
