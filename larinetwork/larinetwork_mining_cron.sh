#!/bin/bash
while true; do
  docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword generate 1
  echo "$(date): Generated 1 block on LariNetwork"
  sleep 10
done
