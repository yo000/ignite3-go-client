#!/bin/sh
#
# Stop test cluster, and delete data
#

cd docker
echo "Stopping cluster"
docker compose down
echo "Deleting data"
rm -rf work
rm -rf sql
rm -f sql.zip
