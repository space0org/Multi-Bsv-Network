# ネットワークへの接続

このセクションでは、JpyNetworkとLariNetworkに接続する方法について説明します。

## JpyNetworkへの接続

### 設定ファイルの作成

JpyNetworkに接続するには、以下の設定ファイルを作成します。

```bash
mkdir -p ~/bsv-networks/jpynetwork
cat > ~/bsv-networks/jpynetwork/bitcoin.conf << CONFEOF
# JpyNetwork設定
testnet=0
regtest=0

# ネットワーク設定
listen=1
server=1
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
rpcuser=jpyuser
rpcpassword=jpypassword

# P2P接続設定
addnode=3.107.165.86:8333
addnode=3.27.37.63:8333

# マイニング設定（オプション）
gen=0
CONFEOF
```

### Dockerを使用した接続

Dockerを使用してJpyNetworkに接続する場合は、以下のコマンドを実行します。

```bash
docker run -d --name jpynetwork \
  -v ~/bsv-networks/jpynetwork:/root/.bitcoin \
  -p 8333:8333 -p 8332:8332 \
  bitcoinsv/bitcoin-sv:1.0.8.beta \
  bitcoind -conf=/root/.bitcoin/bitcoin.conf
```

### 接続状態の確認

JpyNetworkへの接続状態を確認するには、以下のコマンドを実行します。

```bash
docker exec jpynetwork bitcoin-cli getconnectioncount
docker exec jpynetwork bitcoin-cli getpeerinfo
```

## LariNetworkへの接続

### 設定ファイルの作成

LariNetworkに接続するには、以下の設定ファイルを作成します。

```bash
mkdir -p ~/bsv-networks/larinetwork
cat > ~/bsv-networks/larinetwork/bitcoin.conf << CONFEOF
# LariNetwork設定
testnet=0
regtest=0

# ネットワーク設定
listen=1
server=1
port=9333
rpcport=9332
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
rpcuser=lariuser
rpcpassword=laripassword

# P2P接続設定
addnode=3.27.37.63:9333

# マイニング設定（オプション）
gen=0
CONFEOF
```

### Dockerを使用した接続

Dockerを使用してLariNetworkに接続する場合は、以下のコマンドを実行します。

```bash
docker run -d --name larinetwork \
  -v ~/bsv-networks/larinetwork:/root/.bitcoin \
  -p 9333:9333 -p 9332:9332 \
  bitcoinsv/bitcoin-sv:1.0.8.beta \
  bitcoind -conf=/root/.bitcoin/bitcoin.conf
```

### 接続状態の確認

LariNetworkへの接続状態を確認するには、以下のコマンドを実行します。

```bash
docker exec larinetwork bitcoin-cli -rpcport=9332 getconnectioncount
docker exec larinetwork bitcoin-cli -rpcport=9332 getpeerinfo
```

## トラブルシューティング

接続に問題がある場合は、以下を確認してください。

1. ファイアウォールが必要なポートを開放しているか
2. 設定ファイルが正しいか
3. ノードのログを確認する

```bash
# JpyNetworkのログを確認
docker logs jpynetwork

# LariNetworkのログを確認
docker logs larinetwork
```

次のセクションでは、ウォレットの設定方法について説明します。
