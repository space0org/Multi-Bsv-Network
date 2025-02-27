# セットアップガイド

このドキュメントでは、JpyNetworkとLariNetwork、およびトークンブリッジのセットアップ方法について説明します。

## 前提条件

- AWS EC2インスタンス（t2.micro以上）
- Docker と Docker Compose
- Python 3.9以上

## JpyNetworkのセットアップ

1. JpyNetworkの設定ファイルを確認します。
```bash
cd ~/Multi-Bsv-Network/jpynetwork
cat config/bitcoin.conf
```

2. Docker Composeを使用してノードを起動します。
```bash
docker-compose up -d
```

3. ノードの状態を確認します。
```bash
docker exec node1 bitcoin-cli getnetworkinfo
```

## LariNetworkのセットアップ

1. LariNetworkの設定ファイルを確認します。
```bash
cd ~/Multi-Bsv-Network/larinetwork
cat config/bitcoin.conf
```

2. Docker Composeを使用してノードを起動します。
```bash
docker-compose up -d
```

3. ノードの状態を確認します。
```bash
docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword getnetworkinfo
```

## トークンブリッジのセットアップ

1. トークンブリッジのディレクトリに移動します。
```bash
cd ~/Multi-Bsv-Network/token-bridge
```

2. 依存関係をインストールします。
```bash
pip install -r requirements.txt
```

3. Docker Composeを使用してトークンブリッジを起動します。
```bash
./deploy.sh
```

4. トークンブリッジの状態を確認します。
```bash
curl http://localhost:5001/bridge/info
```

## ネットワーク構成

### JpyNetwork
- **ノード**: Node4 (3.107.165.86), Node5 (3.27.37.63), Node6 (3.26.38.112)
- **コンテナ**: node1 (bitcoinsv/bitcoin-sv:1.0.8.beta)
- **ポート**: 18332-18333, 18444

### LariNetwork
- **ノード**: Node5 (3.27.37.63)
- **コンテナ**: lari-node (bitcoinsv/bitcoin-sv:1.0.8.beta)
- **ポート**: 19332-19333, 19444

### トークンブリッジ
- **コンテナ**: token-bridge
- **ポート**: 5001
- **交換レート**: 1 Lari (1 satoshi) = 55 Jpy (55 satoshi)

## マイニングのセットアップ

1. JpyNetworkのマイニングスクリプトを実行します。
```bash
cd ~/Multi-Bsv-Network/jpynetwork
./start_mining.sh
```

2. LariNetworkのマイニングスクリプトを実行します。
```bash
cd ~/Multi-Bsv-Network/larinetwork
./start_mining.sh
```

3. 詳細なマイニング手順については、マイニングガイド（docs/mining.md）を参照してください。
