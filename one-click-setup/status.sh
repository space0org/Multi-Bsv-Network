#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "===== BSV Networks Status ====="

# Check if containers are running
echo "Docker containers status:"
docker ps | grep -E 'jpynetwork-node|larinetwork-node|token-bridge' || echo "No BSV network containers running"

# If containers are running, get detailed status
if docker ps | grep -q jpynetwork-node; then
    echo -e "\nJpyNetwork Status:"
    echo "Block height:"
    docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
    echo "P2P connections:"
    docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo | grep addr
    echo "Network info:"
    docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getnetworkinfo | grep connections
fi

if docker ps | grep -q larinetwork-node; then
    echo -e "\nLariNetwork Status:"
    echo "Block height:"
    docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
    echo "P2P connections:"
    docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo | grep addr
    echo "Network info:"
    docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getnetworkinfo | grep connections
fi

# Check token bridge status
if docker ps | grep -q token-bridge; then
    echo -e "\nToken Bridge Status:"
    curl -s http://localhost:5001/bridge/info
fi

# Check mining processes
echo -e "\nMining Processes:"
ps aux | grep -E "docker exec (jpynetwork|larinetwork)-node bitcoin-cli.*generate" | grep -v grep || echo "No mining processes running"

echo -e "\n===== Status Check Complete ====="
