#/bin/bash
# TODO: Move this to a proper variable/secret
ESTUARY_SHUTTLE_DATA=/usr/src/estuary/data/

token_file=/usr/estuary/private/token
while [ ! -f $token_file ]
do
  echo token file $token_file not found, sleeping 15s then retrying
  sleep 15
done
ESTUARY_TOKEN=$(cat $token_file)

FILE=/usr/src/estuary/data/estuary-shuttle.db
SHUTTLE_TOKEN_HANDLE_FILE=/usr/src/estuary/data/shuttle_token_handle
SHUTTLE_TOKEN_TOKEN_FILE=/usr/src/estuary/data/shuttle_token_actual
if test -f "$FILE"; then
    echo "$FILE exists."
else
    echo "$FILE does not exist."
fi

sleep 10

echo "Checking for an existing shuttle token"
if test -f "$SHUTTLE_TOKEN_TOKEN_FILE"; then
    echo "$SHUTTLE_TOKEN_TOKEN_FILE exists."
else
    # No shuttle keys found, generate them
    genKey=$(curl -H "Authorization: Bearer $ESTUARY_TOKEN" -X POST $ESTUARY_API/admin/shuttle/init)
    echo "$(echo $genKey | jq -r '.handle')" > /usr/src/estuary/data/shuttle_token_handle
    echo "$(echo $genKey | jq -r '.token')" > /usr/src/estuary/data/shuttle_token_actual
fi

ESTUARY_SHUTTLE_HANDLE="$(cat $SHUTTLE_TOKEN_HANDLE_FILE)"
ESTUARY_SHUTTLE_TOKEN="$(cat $SHUTTLE_TOKEN_TOKEN_FILE)"

echo "Hostname: $ESTUARY_HOSTNAME"
echo "API: $ESTUARY_API"
echo "Shuttle Data Directory: $ESTUARY_SHUTTLE_DATA"
echo "Shuttle Token: $ESTUARY_SHUTTLE_TOKEN"
echo "Shuttle Handle: $ESTUARY_SHUTTLE_HANDLE"
echo "Estuary Token: $ESTUARY_TOKEN"

# Strip protocol from Estuary API URL
ESTUARY_API="$(echo $ESTUARY_API | grep -oP '(http|https)://\K\S+')"

/usr/src/estuary-shuttle/estuary-shuttle --database="sqlite=$ESTUARY_SHUTTLE_DATA/estuary-shuttle.db" --datadir=$ESTUARY_SHUTTLE_DATA --estuary-api=$ESTUARY_API --auth-token=$ESTUARY_SHUTTLE_TOKEN --handle=$ESTUARY_SHUTTLE_HANDLE
# tail -f /dev/null
