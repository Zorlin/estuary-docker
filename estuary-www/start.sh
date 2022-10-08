#!/bin/bash
if [[ -z "${ESTUARY_TOKEN}" ]]; then
  echo "Loading Estuary token from token file"
  token_file=/usr/estuary/private/token
  while [ ! -f $token_file ]
  do
    echo token file $token_file not found, sleeping 15s then retrying
    sleep 15
  done
  ESTUARY_TOKEN=$(cat $token_file)
else
  echo "An Estuary token was passed as an env var, proceeding"
fi

echo "Estuary hostname is ${ESTUARY_HOSTNAME}"

cd /usr/src/estuary-www
npm run dev-docker --estuary-host=${ESTUARY_HOSTNAME}
