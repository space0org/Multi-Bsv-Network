#!/bin/bash
while true; do
  docker exec node1 bitcoin-cli generate 1
  echo "$(date): Generated 1 block on JpyNetwork"
  sleep 10
done
