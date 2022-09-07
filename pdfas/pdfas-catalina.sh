#!/bin/sh
set -e
# customize hostname
config=/app/pdf-as-web/pdf-as-web.properties
sed "s/HOSTNAME/$HOSTNAME/g" ${config}.tmpl > ${config}

# Disable expired let's encrypt certificates and download the new one
sed -i -e 's|mozilla/DST_Root_CA_X3.crt|#mozilla/DST_Root_CA_X3.crt|g' /etc/ca-certificates.conf
sed -i -e 's|mozilla/ISRG_Root_X1.crt|#mozilla/ISRG_Root_X1.crt|g' /etc/ca-certificates.conf
wget --no-check-certificate https://letsencrypt.org/certs/isrgrootx1.pem -O /usr/local/share/ca-certificates/isrgrootx1.crt

# update-ca-certificates also updates the java keystore
/usr/sbin/update-ca-certificates --fresh

exec /usr/local/tomcat/bin/catalina.sh "$@"
