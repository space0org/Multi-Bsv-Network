# Mining Scripts for BSV Networks

This directory contains mining scripts for the JpyNetwork and LariNetwork Bitcoin SV networks.

## JpyNetwork Mining

To start continuous mining on JpyNetwork:

```bash
nohup ./jpynetwork_mining_cron.sh > jpynetwork_mining.log 2>&1 &
```

## LariNetwork Mining

To start continuous mining on LariNetwork:

```bash
nohup ./larinetwork_mining_cron.sh > larinetwork_mining.log 2>&1 &
```

## Exchange Rate

The token bridge between these networks uses an exchange rate of:

**1 Lari = 55 Jpy**

This means:
- 55 satoshis on JpyNetwork = 1 satoshi on LariNetwork
- To convert JPY to Lari: divide by 55
- To convert Lari to JPY: multiply by 55
