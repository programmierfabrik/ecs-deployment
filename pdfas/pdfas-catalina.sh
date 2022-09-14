#!/bin/sh
set -e
# customize hostname
config=/app/pdf-as-web/pdf-as-web.properties
sed "s/HOSTNAME_PDFAS/$HOSTNAME_PDFAS/g" ${config}.tmpl > ${config}

exec /usr/local/tomcat/bin/catalina.sh "$@"
