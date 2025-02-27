#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "===== Starting BSV Networks ====="

# Check if setup has been run
if [ ! -f "jpynetwork/bitcoin.conf" ] || [ ! -f "larinetwork/bitcoin.conf" ]; then
    echo "Running setup first..."
    ./setup.sh
fi

# Start the networks and bridge
echo "Starting Docker containers..."
docker-compose up -d

# Wait for nodes to start
echo "Waiting for nodes to start..."
sleep 10

# Generate initial blocks for both networks
echo "Generating initial blocks for JpyNetwork..."
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 101
echo "Generating initial blocks for LariNetwork..."
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 101

# Start mining in the background
echo "Starting continuous mining for both networks..."
nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > jpynetwork_mining.log 2>&1 &
echo "JpyNetwork mining started (PID: $!)"

nohup bash -c 'while true; do docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > larinetwork_mining.log 2>&1 &
echo "LariNetwork mining started (PID: $!)"

# Display network status
echo "===== Network Status ====="
echo "JpyNetwork block height:"
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
echo "LariNetwork block height:"
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount

echo "Token Bridge API is available at: http://localhost:5001"
echo "===== Setup Complete ====="
echo "Use './stop.sh' to stop all services"
