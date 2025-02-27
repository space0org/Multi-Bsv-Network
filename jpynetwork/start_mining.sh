#!/bin/bash

# Start mining on JpyNetwork
echo "Starting mining on JpyNetwork..."
docker exec node1 bitcoin-cli generate 1

# Set up continuous mining (every 10 seconds)
echo "Setting up continuous mining (every 10 seconds)..."
cat > jpynetwork_mining_cron.sh << 'INNEREOF'
#!/bin/bash
while true; do
  docker exec node1 bitcoin-cli generate 1
  echo "$(date): Generated 1 block on JpyNetwork"
  sleep 10
done
INNEREOF

chmod +x jpynetwork_mining_cron.sh
echo "To start continuous mining, run: nohup ./jpynetwork_mining_cron.sh > mining_jpy.log 2>&1 &"
echo "Mining script created: jpynetwork_mining_cron.sh"
