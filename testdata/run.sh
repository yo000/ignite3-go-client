#!/bin/sh
#
# Initialize an Ignite 3 instance with data to run tests
#

DATAURL="https://ignite.apache.org/docs/ignite3/latest/quick-start/sql-files/sql.zip"


docker -v >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "docker is needed to run test"
  exit 1
fi
unzip -v >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "unzip is needed to run test"
  exit 1
fi

curl -L ${DATAURL} -o docker/sql.zip

cd docker && unzip sql.zip || echo "Error running \"unzip sql.zip\""

docker compose up -d

echo "************************************"
echo "* ignite 3 node cluster is running *"
echo "************************************"
echo "You need to initialize it, and load data, using the following commands :"
echo "--------------------------------------------------------------------------"
echo 'cd docker'
echo 'docker run --rm -it --network=host -v "$PWD/certs/ca:/cli-certs/ca:ro" -v "$PWD/sql:/sql-data:ro" -e LANG=C.UTF-8 -e LC_ALL=C.UTF-8 apacheignite/ignite:3.1.0 cli'
echo 'cli config set ignite.rest.trust-store.path=/cli-certs/ca/truststore.p12'
echo 'cli config set ignite.rest.trust-store.password=changeit'
echo 'cli config set ignite.jdbc.trust-store.path=/cli-certs/ca/truststore.p12'
echo 'cli config set ignite.jdbc.trust-store.password=changeit'
echo 'cli config set ignite.jdbc-url="jdbc:ignite:thin://localhost:10800?sslEnabled=true&trustStorePath=/cli-certs/ca/truststore.p12&trustStoreType=PKCS12&trustStorePassword=changeit"'
echo 'connect https://localhost:10400'
echo 'cluster init --name=ignite3-test'
echo "--------------------------------------------------------------------------"
echo ""
echo "Once the cluster is initialized, create schema and add data with :"
echo "--------------------------------------------------------------------------"
echo 'sql --file=/sql-data/schema.sql'
echo 'sql --file=/sql-data/current_catalog.sql'
echo 'sql --file=/sql-data/media_and_genre.sql'
echo 'sql --file=/sql-data/tracks.sql'
echo 'sql --file=/sql-data/ee_and_cust.sql'
echo 'sql --file=/sql-data/invoices.sql'
echo "--------------------------------------------------------------------------"



