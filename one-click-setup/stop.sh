#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "===== Stopping BSV Networks ====="

# Stop mining processes
echo "Stopping mining processes..."
pkill -f "docker exec jpynetwork-node bitcoin-cli" || true
pkill -f "docker exec larinetwork-node bitcoin-cli" || true

# Stop Docker containers
echo "Stopping Docker containers..."
docker stop jpynetwork-node larinetwork-node token-bridge 2>/dev/null || true
docker rm jpynetwork-node larinetwork-node token-bridge 2>/dev/null || true

echo "All services stopped successfully!"
