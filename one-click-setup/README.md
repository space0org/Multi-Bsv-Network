# BSV Network One-Click Setup

This directory contains scripts for setting up and managing two independent Bitcoin SV networks (JpyNetwork and LariNetwork) with a token bridge between them.

## Requirements

- Docker
- Bash

## Usage

### Setup

Run the setup script to prepare the environment:

```bash
./setup.sh
```

### Start Networks

Start both networks and the token bridge with:

```bash
./start.sh
```

This will:
1. Start JpyNetwork node
2. Start LariNetwork node
3. Start the token bridge
4. Establish P2P connections between networks
5. Generate initial blocks
6. Start mining on both networks

### Check Status

Check the status of the networks and token bridge:

```bash
./status.sh
```

### Stop Networks

Stop all services:

```bash
./stop.sh
```

## Token Bridge API

The token bridge provides the following endpoints:

- `GET /bridge/info`: Get information about the bridge
- `POST /bridge/swap/jpy-to-lari`: Swap JPY to Lari
- `POST /bridge/swap/lari-to-jpy`: Swap Lari to JPY
- `GET /bridge/transactions`: Get transaction history

### Exchange Rate

1 Lari = 55 Jpy

### Example API Calls

```bash
# Get bridge info
curl http://localhost:5001/bridge/info

# Swap JPY to Lari
curl -X POST -H "Content-Type: application/json" -d '{"amount": 550, "destination_address": "example_address"}' http://localhost:5001/bridge/swap/jpy-to-lari

# Swap Lari to JPY
curl -X POST -H "Content-Type: application/json" -d '{"amount": 10, "destination_address": "example_address"}' http://localhost:5001/bridge/swap/lari-to-jpy

# Get transaction history
curl http://localhost:5001/bridge/transactions
```
