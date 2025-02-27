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

# Stop and remove any existing containers with the same names
echo "Cleaning up any existing containers..."
docker stop jpynetwork-node larinetwork-node token-bridge 2>/dev/null || true
docker rm jpynetwork-node larinetwork-node token-bridge 2>/dev/null || true

# Create a custom bridge network if it doesn't exist
echo "Creating Docker network..."
docker network create bsv-network 2>/dev/null || true

# Create data directories if they don't exist
mkdir -p "$(pwd)/jpynetwork/data"
mkdir -p "$(pwd)/larinetwork/data"

# Start JpyNetwork node
echo "Starting JpyNetwork node..."
docker run -d --name jpynetwork-node \
    --network bsv-network \
    -v "$(pwd)/jpynetwork/data:/home/bitcoin/.bitcoin/data" \
    -v "$(pwd)/jpynetwork/bitcoin.conf:/home/bitcoin/.bitcoin/bitcoin.conf" \
    -p 18332:18332 -p 18333:18333 -p 18444:18444 \
    bitcoinsv/bitcoin-sv:1.0.8.beta \
    bitcoind -excessiveblocksize=0 -maxstackmemoryusageconsensus=0

# Start LariNetwork node
echo "Starting LariNetwork node..."
docker run -d --name larinetwork-node \
    --network bsv-network \
    -v "$(pwd)/larinetwork/data:/home/bitcoin/.bitcoin/data" \
    -v "$(pwd)/larinetwork/bitcoin.conf:/home/bitcoin/.bitcoin/bitcoin.conf" \
    -p 19332:18332 -p 19333:18333 -p 19444:18444 \
    bitcoinsv/bitcoin-sv:1.0.8.beta \
    bitcoind -excessiveblocksize=0 -maxstackmemoryusageconsensus=0

# Check if containers are running
echo "Checking if containers are running..."
docker ps | grep jpynetwork-node || { echo "JpyNetwork node failed to start"; exit 1; }
docker ps | grep larinetwork-node || { echo "LariNetwork node failed to start"; exit 1; }

# Build and start token bridge
echo "Building and starting token bridge..."
docker build -t token-bridge ./token-bridge
docker run -d --name token-bridge \
    --network bsv-network \
    -p 5001:5001 \
    token-bridge

# Wait for nodes to start
echo "Waiting for nodes to start..."
sleep 10

# Check if containers are still running
echo "Checking if containers are still running..."
docker ps | grep jpynetwork-node || { echo "JpyNetwork node failed to start"; exit 1; }
docker ps | grep larinetwork-node || { echo "LariNetwork node failed to start"; exit 1; }
docker ps | grep token-bridge || { echo "Token bridge failed to start"; exit 1; }

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
