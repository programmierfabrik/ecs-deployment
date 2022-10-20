export CATALINA_OPTS="$CATALINA_OPTS \
    -Xss1024K \
    -Xms128m \
    -Xmx1024m \
    -Dlogback.configurationFile=$CATALINA_HOME/conf/pdf-as/cfg/logback.xml \
    -Dpdf-as-web.conf=$CATALINA_HOME/conf/pdf-as/pdf-as-web.properties \
    $EXTRA_OPTS \
"
