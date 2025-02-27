#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "===== BSV Network Setup ====="

# Create necessary directories
mkdir -p jpynetwork/data
mkdir -p larinetwork/data
mkdir -p token-bridge

# Create bitcoin.conf for JpyNetwork
cat > jpynetwork/bitcoin.conf << 'EOC'
# JpyNetwork Configuration
regtest=1
server=1
rpcuser=jpyuser
rpcpassword=jpypassword
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://0.0.0.0:28332
zmqpubhashblock=tcp://0.0.0.0:28332
rpcworkqueue=100
rpcthreads=4
rest=1
# P2P Configuration
listen=1
bind=0.0.0.0:18444
EOC

# Create bitcoin.conf for LariNetwork
cat > larinetwork/bitcoin.conf << 'EOC'
# LariNetwork Configuration
regtest=1
server=1
rpcuser=lariuser
rpcpassword=laripassword
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://0.0.0.0:28332
zmqpubhashblock=tcp://0.0.0.0:28332
rpcworkqueue=100
rpcthreads=4
rest=1
# P2P Configuration
listen=1
bind=0.0.0.0:19444
EOC

# Create token bridge files
cat > token-bridge/app.py << 'EOC'
from flask import Flask, jsonify, request
import time

app = Flask(__name__)

# Network configurations
networks = {
    "jpy_network": {
        "name": "JpyNetwork",
        "host": "jpynetwork-node",
        "port": 18332
    },
    "lari_network": {
        "name": "LariNetwork",
        "host": "larinetwork-node",
        "port": 18332
    }
}

# Exchange rate: 1 Lari = 55 Jpy
EXCHANGE_RATE = 55

# Transaction log
transactions = []

@app.route('/bridge/info', methods=['GET'])
def get_bridge_info():
    return jsonify({
        "status": "operational",
        "networks": networks,
        "exchange_rate": f"1 Lari = {EXCHANGE_RATE} Jpy"
    })

@app.route('/bridge/swap/jpy-to-lari', methods=['POST'])
def swap_jpy_to_lari():
    data = request.json
    if not data or 'amount' not in data or 'destination_address' not in data:
        return jsonify({"status": "error", "message": "Missing required fields"}), 400
    
    jpy_amount = data['amount']
    destination_address = data['destination_address']
    
    # Convert JPY to Lari (divide by exchange rate)
    lari_amount = jpy_amount / EXCHANGE_RATE
    
    # Create transaction record
    transaction = {
        "transaction_id": f"lari_tx_{int(time.time())}",
        "timestamp": int(time.time()),
        "from_network": "JpyNetwork",
        "to_network": "LariNetwork",
        "jpy_amount": jpy_amount,
        "lari_amount": lari_amount,
        "destination_address": destination_address,
        "exchange_rate": f"1 Lari = {EXCHANGE_RATE} Jpy"
    }
    
    transactions.append(transaction)
    
    return jsonify({
        "status": "success",
        "transaction": transaction
    })

@app.route('/bridge/swap/lari-to-jpy', methods=['POST'])
def swap_lari_to_jpy():
    data = request.json
    if not data or 'amount' not in data or 'destination_address' not in data:
        return jsonify({"status": "error", "message": "Missing required fields"}), 400
    
    lari_amount = data['amount']
    destination_address = data['destination_address']
    
    # Convert Lari to JPY (multiply by exchange rate)
    jpy_amount = lari_amount * EXCHANGE_RATE
    
    # Create transaction record
    transaction = {
        "transaction_id": f"jpy_tx_{int(time.time())}",
        "timestamp": int(time.time()),
        "from_network": "LariNetwork",
        "to_network": "JpyNetwork",
        "lari_amount": lari_amount,
        "jpy_amount": jpy_amount,
        "destination_address": destination_address,
        "exchange_rate": f"1 Lari = {EXCHANGE_RATE} Jpy"
    }
    
    transactions.append(transaction)
    
    return jsonify({
        "status": "success",
        "transaction": transaction
    })

@app.route('/bridge/transactions', methods=['GET'])
def get_transactions():
    return jsonify({
        "transactions": transactions
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
EOC

cat > token-bridge/Dockerfile << 'EOC'
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5001

CMD ["python", "app.py"]
EOC

cat > token-bridge/requirements.txt << 'EOC'
flask==2.0.1
werkzeug==2.0.1
EOC

echo "Setting up JpyNetwork and LariNetwork..."
echo "Setup completed successfully!"
