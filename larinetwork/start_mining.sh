#!/bin/bash

# Start mining on LariNetwork
echo "Starting mining on LariNetwork..."
docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword generate 1

# Set up continuous mining (every 10 seconds)
echo "Setting up continuous mining (every 10 seconds)..."
cat > larinetwork_mining_cron.sh << 'INNEREOF'
#!/bin/bash
while true; do
  docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword generate 1
  echo "$(date): Generated 1 block on LariNetwork"
  sleep 10
done
INNEREOF

chmod +x larinetwork_mining_cron.sh
echo "To start continuous mining, run: nohup ./larinetwork_mining_cron.sh > mining_lari.log 2>&1 &"
echo "Mining script created: larinetwork_mining_cron.sh"
