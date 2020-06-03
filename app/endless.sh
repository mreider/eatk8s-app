#!/bin/bash
if [[ -z "${SHOPPER_HOST}" ]]; then
  SHOPPER_HOST="localhost"
else
  SHOPPER_HOST="${SHOPPER_HOST}"
fi

if [[ -z "${SHOPPER_PORT}" ]]; then
  SHOPPER_PORT="8080"
else
  SHOPPER_PORT="${SHOPPER_PORT}"
fi

while true; 
do 
    sleep 3; 
    curl http://$SHOPPER_HOST:$SHOPPER_PORT/shop
done


