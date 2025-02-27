#!/usr/bin/env python3
import os
import json
import time
import requests
import logging
from flask import Flask, request, jsonify

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger('token-bridge')

app = Flask(__name__)

# Configuration
JPY_RPC_USER = "bitcoin"
JPY_RPC_PASSWORD = "bitcoin"
JPY_RPC_HOST = "127.0.0.1"
JPY_RPC_PORT = "18332"

LARI_RPC_USER = "lariuser"
LARI_RPC_PASSWORD = "laripassword"
LARI_RPC_HOST = "127.0.0.1"
LARI_RPC_PORT = "19332"

# Exchange rate: 1 Lari = 55 Jpy
EXCHANGE_RATE = 55

# Bridge wallet addresses
jpy_bridge_address = None
jpy_bridge_private_key = None
lari_bridge_address = None
lari_bridge_private_key = None

def make_rpc_request(network, method, params=None):
    """Make an RPC request to the specified network."""
    if network == "jpy":
        url = f"http://{JPY_RPC_HOST}:{JPY_RPC_PORT}"
        auth = (JPY_RPC_USER, JPY_RPC_PASSWORD)
    elif network == "lari":
        url = f"http://{LARI_RPC_HOST}:{LARI_RPC_PORT}"
        auth = (LARI_RPC_USER, LARI_RPC_PASSWORD)
    else:
        raise ValueError(f"Unknown network: {network}")
    
    payload = {
        "jsonrpc": "1.0",
        "id": "token-bridge",
        "method": method,
        "params": params or []
    }
    
    try:
        response = requests.post(url, json=payload, auth=auth)
        response.raise_for_status()
        return response.json()["result"]
    except Exception as e:
        logger.error(f"RPC request failed: {e}")
        return None

def initialize_bridge_wallets():
    """Initialize bridge wallets for both networks."""
    global jpy_bridge_address, jpy_bridge_private_key, lari_bridge_address, lari_bridge_private_key
    
    # Create JPY bridge wallet
    jpy_result = make_rpc_request("jpy", "getnewaddress", ["bridge"])
    if jpy_result:
        jpy_bridge_address = jpy_result
        jpy_private_key = make_rpc_request("jpy", "dumpprivkey", [jpy_bridge_address])
        if jpy_private_key:
            jpy_bridge_private_key = jpy_private_key
            logger.info(f"JPY bridge wallet created: {jpy_bridge_address}")
        else:
            logger.error("Failed to get JPY bridge private key")
            return False
    else:
        logger.error("Failed to create JPY bridge address")
        return False
    
    # Create Lari bridge wallet
    lari_result = make_rpc_request("lari", "getnewaddress", ["bridge"])
    if lari_result:
        lari_bridge_address = lari_result
        lari_private_key = make_rpc_request("lari", "dumpprivkey", [lari_bridge_address])
        if lari_private_key:
            lari_bridge_private_key = lari_private_key
            logger.info(f"Lari bridge wallet created: {lari_bridge_address}")
        else:
            logger.error("Failed to get Lari bridge private key")
            return False
    else:
        logger.error("Failed to create Lari bridge address")
        return False
    
    return True

def get_balance(network, address):
    """Get the balance of an address on the specified network."""
    result = make_rpc_request(network, "getreceivedbyaddress", [address])
    if result is not None:
        return result
    return 0

def send_transaction(network, from_address, to_address, amount, private_key):
    """Send a transaction on the specified network."""
    # Import the private key
    import_result = make_rpc_request(network, "importprivkey", [private_key, "temp", False])
    
    # Create raw transaction
    inputs = []
    unspent = make_rpc_request(network, "listunspent", [0, 9999999, [from_address]])
    if not unspent:
        logger.error(f"No unspent outputs for {from_address} on {network} network")
        return None
    
    total_in = 0
    for utxo in unspent:
        if total_in < amount:
            inputs.append({"txid": utxo["txid"], "vout": utxo["vout"]})
            total_in += utxo["amount"]
        else:
            break
    
    if total_in < amount:
        logger.error(f"Insufficient funds: {total_in} < {amount}")
        return None
    
    # Calculate change
    change = total_in - amount
    outputs = {to_address: amount}
    if change > 0.00001:  # Minimum dust threshold
        outputs[from_address] = change
    
    # Create and sign raw transaction
    raw_tx = make_rpc_request(network, "createrawtransaction", [inputs, outputs])
    if not raw_tx:
        logger.error("Failed to create raw transaction")
        return None
    
    signed_tx = make_rpc_request(network, "signrawtransaction", [raw_tx])
    if not signed_tx or not signed_tx.get("complete", False):
        logger.error("Failed to sign transaction")
        return None
    
    # Send raw transaction
    tx_id = make_rpc_request(network, "sendrawtransaction", [signed_tx["hex"]])
    if not tx_id:
        logger.error("Failed to send transaction")
        return None
    
    logger.info(f"Transaction sent on {network} network: {tx_id}")
    return tx_id

@app.route('/bridge/info', methods=['GET'])
def bridge_info():
    """Get information about the token bridge."""
    return jsonify({
        "jpy_bridge_address": jpy_bridge_address,
        "lari_bridge_address": lari_bridge_address,
        "exchange_rate": f"1 Lari = {EXCHANGE_RATE} Jpy",
        "jpy_balance": get_balance("jpy", jpy_bridge_address),
        "lari_balance": get_balance("lari", lari_bridge_address)
    })

@app.route('/bridge/swap/jpy-to-lari', methods=['POST'])
def swap_jpy_to_lari():
    """Swap JPY tokens to Lari tokens."""
    data = request.json
    if not data or not all(k in data for k in ["from_address", "private_key", "amount"]):
        return jsonify({"error": "Missing required fields"}), 400
    
    from_address = data["from_address"]
    private_key = data["private_key"]
    jpy_amount = float(data["amount"])
    
    # Calculate Lari amount based on exchange rate
    lari_amount = jpy_amount / EXCHANGE_RATE
    
    # Send JPY to bridge address
    jpy_tx = send_transaction("jpy", from_address, jpy_bridge_address, jpy_amount, private_key)
    if not jpy_tx:
        return jsonify({"error": "Failed to send JPY to bridge"}), 500
    
    # Send Lari from bridge to user
    lari_tx = send_transaction("lari", lari_bridge_address, from_address, lari_amount, lari_bridge_private_key)
    if not lari_tx:
        return jsonify({"error": "Failed to send Lari from bridge"}), 500
    
    return jsonify({
        "status": "success",
        "jpy_transaction": jpy_tx,
        "lari_transaction": lari_tx,
        "jpy_amount": jpy_amount,
        "lari_amount": lari_amount,
        "exchange_rate": f"1 Lari = {EXCHANGE_RATE} Jpy"
    })

@app.route('/bridge/swap/lari-to-jpy', methods=['POST'])
def swap_lari_to_jpy():
    """Swap Lari tokens to JPY tokens."""
    data = request.json
    if not data or not all(k in data for k in ["from_address", "private_key", "amount"]):
        return jsonify({"error": "Missing required fields"}), 400
    
    from_address = data["from_address"]
    private_key = data["private_key"]
    lari_amount = float(data["amount"])
    
    # Calculate JPY amount based on exchange rate
    jpy_amount = lari_amount * EXCHANGE_RATE
    
    # Send Lari to bridge address
    lari_tx = send_transaction("lari", from_address, lari_bridge_address, lari_amount, private_key)
    if not lari_tx:
        return jsonify({"error": "Failed to send Lari to bridge"}), 500
    
    # Send JPY from bridge to user
    jpy_tx = send_transaction("jpy", jpy_bridge_address, from_address, jpy_amount, jpy_bridge_private_key)
    if not jpy_tx:
        return jsonify({"error": "Failed to send JPY from bridge"}), 500
    
    return jsonify({
        "status": "success",
        "lari_transaction": lari_tx,
        "jpy_transaction": jpy_tx,
        "lari_amount": lari_amount,
        "jpy_amount": jpy_amount,
        "exchange_rate": f"1 Lari = {EXCHANGE_RATE} Jpy"
    })

if __name__ == '__main__':
    logger.info("Initializing token bridge...")
    if initialize_bridge_wallets():
        logger.info(f"Token bridge initialized with exchange rate: 1 Lari = {EXCHANGE_RATE} Jpy")
        logger.info(f"JPY bridge address: {jpy_bridge_address}")
        logger.info(f"Lari bridge address: {lari_bridge_address}")
        app.run(host='0.0.0.0', port=5001)
    else:
        logger.error("Failed to initialize token bridge")
