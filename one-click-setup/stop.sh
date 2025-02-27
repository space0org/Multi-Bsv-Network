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
docker-compose down

echo "All services stopped successfully!"
