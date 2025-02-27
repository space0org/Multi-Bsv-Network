# ネットワークの起動

このセクションでは、JpyNetworkとLariNetworkの両方のBSVネットワークを起動する方法について説明します。

## start.shスクリプトの使用

ネットワークを起動するには、`one-click-setup`ディレクトリ内の`start.sh`スクリプトを実行します：

```bash
cd ~/Multi-Bsv-Network/one-click-setup
./start.sh
```

このスクリプトは以下の処理を自動的に行います：

1. 既存のコンテナを停止・削除
2. Dockerネットワークの作成
3. JpyNetworkノードの起動
4. LariNetworkノードの起動
5. トークンブリッジの起動
6. ネットワーク間のP2P接続の確立
7. 初期ブロックの生成（各ネットワークで101ブロック）
8. 継続的なマイニングの開始

## 起動プロセスの詳細

### 1. 既存のコンテナのクリーンアップ

スクリプトはまず、同じ名前の既存のコンテナを停止・削除します：

```bash
docker stop jpynetwork-node larinetwork-node token-bridge 2>/dev/null || true
docker rm jpynetwork-node larinetwork-node token-bridge 2>/dev/null || true
```

### 2. Dockerネットワークの作成

次に、コンテナ間の通信のためのDockerネットワークを作成します：

```bash
docker network create bsv-network 2>/dev/null || true
```

### 3. JpyNetworkノードの起動

JpyNetworkノードをDockerコンテナとして起動します：

```bash
docker run -d --name jpynetwork-node \
    --network bsv-network \
    -v "$(pwd)/jpynetwork/data:/home/bitcoin/.bitcoin/data" \
    -v "$(pwd)/jpynetwork/bitcoin.conf:/home/bitcoin/.bitcoin/bitcoin.conf" \
    -p 18332:18332 -p 18333:18333 -p 18444:18444 \
    bitcoinsv/bitcoin-sv:1.0.8.beta \
    bitcoind -excessiveblocksize=0 -maxstackmemoryusageconsensus=0
```

### 4. LariNetworkノードの起動

同様に、LariNetworkノードをDockerコンテナとして起動します：

```bash
docker run -d --name larinetwork-node \
    --network bsv-network \
    -v "$(pwd)/larinetwork/data:/home/bitcoin/.bitcoin/data" \
    -v "$(pwd)/larinetwork/bitcoin.conf:/home/bitcoin/.bitcoin/bitcoin.conf" \
    -p 19332:18332 -p 19333:18333 -p 19444:18444 \
    bitcoinsv/bitcoin-sv:1.0.8.beta \
    bitcoind -excessiveblocksize=0 -maxstackmemoryusageconsensus=0
```

### 5. トークンブリッジの起動

トークンブリッジAPIをDockerコンテナとして起動します：

```bash
docker build -t token-bridge ./token-bridge
docker run -d --name token-bridge \
    --network bsv-network \
    -p 5001:5001 \
    token-bridge
```

### 6. P2P接続の確立

両方のネットワーク間のP2P接続を確立します：

```bash
# コンテナIPの取得
JPY_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jpynetwork-node)
LARI_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' larinetwork-node)

# JpyNetworkをLariNetworkに接続
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${LARI_IP}:19444" add

# LariNetworkをJpyNetworkに接続
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${JPY_IP}:18444" add
```

### 7. 初期ブロックの生成

各ネットワークで初期ブロックを生成します：

```bash
# JpyNetworkの初期ブロック生成
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 101

# LariNetworkの初期ブロック生成
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 101
```

### 8. マイニングの開始

両方のネットワークで継続的なマイニングを開始します：

```bash
# JpyNetworkのマイニング開始
nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > jpynetwork_mining.log 2>&1 &

# LariNetworkのマイニング開始
nohup bash -c 'while true; do docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > larinetwork_mining.log 2>&1 &
```

## 起動の確認

ネットワークが正常に起動したことを確認するには、以下のコマンドを実行します：

```bash
# コンテナの状態を確認
docker ps | grep jpynetwork-node
docker ps | grep larinetwork-node
docker ps | grep token-bridge

# ブロック高を確認
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount

# P2P接続を確認
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo | grep addr
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo | grep addr

# トークンブリッジAPIを確認
curl http://localhost:5001/bridge/info
```

## トラブルシューティング

起動中に問題が発生した場合は、以下を確認してください：

1. Dockerサービスが実行中であることを確認します：
   ```bash
   sudo systemctl status docker
   ```

2. ポートが利用可能であることを確認します：
   ```bash
   netstat -tuln | grep 18332
   netstat -tuln | grep 19332
   netstat -tuln | grep 5001
   ```

3. ログを確認します：
   ```bash
   docker logs jpynetwork-node
   docker logs larinetwork-node
   docker logs token-bridge
   ```

## 次のステップ

ネットワークが正常に起動したら、[ステータスの確認](checking-status.md)に進んでください。
