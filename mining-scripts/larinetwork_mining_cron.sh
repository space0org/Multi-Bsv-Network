#!/bin/bash
# LariNetwork continuous mining script
# Exchange rate: 1 Lari = 55 Jpy

while true; do
  docker exec lari-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1
  echo "$(date): Generated 1 block on LariNetwork"
  sleep 10
done
