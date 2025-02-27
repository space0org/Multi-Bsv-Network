#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "===== BSV Networks Status ====="

# Check if containers are running
echo "Docker containers status:"
docker ps | grep -E 'jpynetwork-node|larinetwork-node|token-bridge' || echo "No BSV network containers running"

# If containers are running, get block heights
if docker ps | grep -q jpynetwork-node; then
    echo "JpyNetwork block height:"
    docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
fi

if docker ps | grep -q larinetwork-node; then
    echo "LariNetwork block height:"
    docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
fi

# Check token bridge status
if docker ps | grep -q token-bridge; then
    echo "Token Bridge status:"
    curl -s http://localhost:5001/bridge/info
fi

# Check mining processes
echo "Mining processes:"
ps aux | grep -E "docker exec (jpynetwork|larinetwork)-node bitcoin-cli" | grep -v grep || echo "No mining processes running"

echo "===== Status Check Complete ====="
