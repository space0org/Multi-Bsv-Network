#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "===== BSV Networks Status ====="

# Check if containers are running
echo "Checking container status..."
docker ps | grep jpynetwork-node || echo "JpyNetwork node is not running"
docker ps | grep larinetwork-node || echo "LariNetwork node is not running"
docker ps | grep token-bridge || echo "Token bridge is not running"

# If containers are running, get network status
if docker ps | grep -q jpynetwork-node; then
    echo -e "\n===== JpyNetwork Status ====="
    echo "Block height:"
    docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
    echo "P2P connections:"
    docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo | grep addr
fi

if docker ps | grep -q larinetwork-node; then
    echo -e "\n===== LariNetwork Status ====="
    echo "Block height:"
    docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
    echo "P2P connections:"
    docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo | grep addr
fi

if docker ps | grep -q token-bridge; then
    echo -e "\n===== Token Bridge Status ====="
    echo "Bridge API is available at: http://localhost:5001"
    echo "Bridge info:"
    curl -s http://localhost:5001/bridge/info | python -m json.tool
fi

echo -e "\n===== Mining Status ====="
ps aux | grep "docker exec" | grep "generate" | grep -v grep || echo "No mining processes running"

echo -e "\n===== End of Status Report ====="
