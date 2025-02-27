#!/bin/bash
set -e

echo "Deploying token bridge..."

# Build and start the token bridge
docker-compose build
docker-compose up -d

echo "Token bridge deployed successfully!"
echo "API available at: http://localhost:5001"
