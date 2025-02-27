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

# Establish P2P connections between networks
echo "Establishing P2P connections..."

# Get container IPs
JPY_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jpynetwork-node)
LARI_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' larinetwork-node)

# Connect JpyNetwork to LariNetwork
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${LARI_IP}:19444" add

# Connect LariNetwork to JpyNetwork
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${JPY_IP}:18444" add

echo "P2P connections established."

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

# Check P2P connections
echo "JpyNetwork connections:"
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo | grep addr
echo "LariNetwork connections:"
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo | grep addr

echo "Token Bridge API is available at: http://localhost:5001"
echo "===== Setup Complete ====="
echo "Use './stop.sh' to stop all services"
