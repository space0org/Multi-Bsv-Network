# マイニングガイド

このドキュメントでは、JpyNetworkとLariNetworkでのマイニングの設定と開始方法について説明します。

## JpyNetworkでのマイニング

### 手動でブロックを生成

```bash
cd ~/Multi-Bsv-Network/jpynetwork
docker exec node1 bitcoin-cli generate 1
```

### 自動マイニングの開始

1. マイニングスクリプトを実行します。
```bash
cd ~/Multi-Bsv-Network/jpynetwork
./start_mining.sh
```

2. 継続的なマイニングを開始します。
```bash
nohup ./jpynetwork_mining_cron.sh > mining_jpy.log 2>&1 &
```

3. マイニングログを確認します。
```bash
tail -f mining_jpy.log
```

4. マイニングプロセスを停止するには：
```bash
ps aux | grep jpynetwork_mining_cron.sh
kill <プロセスID>
```

## LariNetworkでのマイニング

### 手動でブロックを生成

```bash
cd ~/Multi-Bsv-Network/larinetwork
docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword generate 1
```

### 自動マイニングの開始

1. マイニングスクリプトを実行します。
```bash
cd ~/Multi-Bsv-Network/larinetwork
./start_mining.sh
```

2. 継続的なマイニングを開始します。
```bash
nohup ./larinetwork_mining_cron.sh > mining_lari.log 2>&1 &
```

3. マイニングログを確認します。
```bash
tail -f mining_lari.log
```

4. マイニングプロセスを停止するには：
```bash
ps aux | grep larinetwork_mining_cron.sh
kill <プロセスID>
```

## マイニング状態の確認

### JpyNetworkのブロック高を確認

```bash
docker exec node1 bitcoin-cli getblockcount
```

### LariNetworkのブロック高を確認

```bash
docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword getblockcount
```

## 注意事項

- マイニングはCPUリソースを消費します。長時間の実行はシステムに負荷をかける可能性があります。
- マイニングスクリプトは10秒ごとに1ブロックを生成するように設定されています。必要に応じて間隔を調整してください。
- マイニングを停止する場合は、必ずプロセスを適切に終了してください。
