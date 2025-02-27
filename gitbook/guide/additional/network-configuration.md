# ネットワーク設定の詳細

このセクションでは、BSVネットワーク（JpyNetworkとLariNetwork）の詳細な設定について説明します。

## bitcoin.confの設定

### JpyNetworkのbitcoin.conf

JpyNetworkノードの設定ファイル（`~/Multi-Bsv-Network/one-click-setup/jpynetwork/bitcoin.conf`）には、以下の設定が含まれています：

```ini
# ネットワーク設定
regtest=1
dnsseed=0
upnp=0

# RPC設定
server=1
rpcuser=jpyuser
rpcpassword=jpypassword
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
rpcport=18332

# P2P設定
port=18444
bind=0.0.0.0

# コンセンサスパラメータ
excessiveblocksize=0
maxstackmemoryusageconsensus=0

# マイニング設定
gen=0

# ログ設定
debug=0
logtimestamps=1
logips=1
```

### LariNetworkのbitcoin.conf

LariNetworkノードの設定ファイル（`~/Multi-Bsv-Network/one-click-setup/larinetwork/bitcoin.conf`）には、以下の設定が含まれています：

```ini
# ネットワーク設定
regtest=1
dnsseed=0
upnp=0

# RPC設定
server=1
rpcuser=lariuser
rpcpassword=laripassword
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
rpcport=19332

# P2P設定
port=19444
bind=0.0.0.0

# コンセンサスパラメータ
excessiveblocksize=0
maxstackmemoryusageconsensus=0

# マイニング設定
gen=0

# ログ設定
debug=0
logtimestamps=1
logips=1
```

## 設定パラメータの説明

### ネットワーク設定

- **regtest=1**: レグテストモードを有効にします。これにより、独自のプライベートブロックチェーンを作成できます。
- **dnsseed=0**: DNSシードを無効にします。プライベートネットワークでは、外部のノードを検出する必要がないため、この設定を無効にします。
- **upnp=0**: UPnP（Universal Plug and Play）を無効にします。これにより、ルーターのポート転送が自動的に設定されなくなります。

### RPC設定

- **server=1**: JSON-RPC APIサーバーを有効にします。
- **rpcuser**: RPC接続のユーザー名を設定します。
- **rpcpassword**: RPC接続のパスワードを設定します。
- **rpcallowip=0.0.0.0/0**: すべてのIPアドレスからのRPC接続を許可します。
- **rpcbind=0.0.0.0**: すべてのネットワークインターフェースでRPCサーバーをリッスンします。
- **rpcport**: RPCサーバーのポート番号を設定します。

### P2P設定

- **port**: P2P接続のポート番号を設定します。
- **bind=0.0.0.0**: すべてのネットワークインターフェースでP2P接続をリッスンします。

### コンセンサスパラメータ

- **excessiveblocksize=0**: ブロックサイズの制限を無効にします。
- **maxstackmemoryusageconsensus=0**: スクリプト実行時のスタックメモリ使用量の制限を無効にします。

### マイニング設定

- **gen=0**: 起動時に自動的にマイニングを開始しないように設定します。マイニングは、別のプロセスで制御されます。

### ログ設定

- **debug=0**: デバッグログを無効にします。
- **logtimestamps=1**: ログにタイムスタンプを含めます。
- **logips=1**: ログにIPアドレスを含めます。

## Dockerコンテナの設定

### JpyNetworkノードのDockerコンテナ

JpyNetworkノードは、以下のDockerコマンドで起動されます：

```bash
docker run -d \
  --name jpynetwork-node \
  --network bsv-network \
  -p 18332:18332 \
  -p 18444:18444 \
  -v ~/Multi-Bsv-Network/one-click-setup/jpynetwork/bitcoin.conf:/home/bitcoin/.bitcoin/bitcoin.conf \
  -v ~/Multi-Bsv-Network/one-click-setup/jpynetwork/data:/home/bitcoin/.bitcoin/regtest \
  bitcoinsv/bitcoin-sv:1.0.8.beta
```

### LariNetworkノードのDockerコンテナ

LariNetworkノードは、以下のDockerコマンドで起動されます：

```bash
docker run -d \
  --name larinetwork-node \
  --network bsv-network \
  -p 19332:19332 \
  -p 19444:19444 \
  -v ~/Multi-Bsv-Network/one-click-setup/larinetwork/bitcoin.conf:/home/bitcoin/.bitcoin/bitcoin.conf \
  -v ~/Multi-Bsv-Network/one-click-setup/larinetwork/data:/home/bitcoin/.bitcoin/regtest \
  bitcoinsv/bitcoin-sv:1.0.8.beta
```

### トークンブリッジAPIのDockerコンテナ

トークンブリッジAPIは、以下のDockerコマンドで起動されます：

```bash
docker run -d \
  --name token-bridge \
  --network bsv-network \
  -p 5001:5001 \
  -e JPY_RPC_HOST=jpynetwork-node \
  -e JPY_RPC_PORT=18332 \
  -e JPY_RPC_USER=jpyuser \
  -e JPY_RPC_PASSWORD=jpypassword \
  -e LARI_RPC_HOST=larinetwork-node \
  -e LARI_RPC_PORT=19332 \
  -e LARI_RPC_USER=lariuser \
  -e LARI_RPC_PASSWORD=laripassword \
  -e EXCHANGE_RATE=55 \
  token-bridge
```

## Dockerネットワークの設定

BSVネットワークシステムは、以下のDockerネットワークを使用します：

```bash
docker network create bsv-network
```

このネットワークにより、各コンテナは互いにホスト名で通信できます。例えば、トークンブリッジAPIは、`jpynetwork-node`と`larinetwork-node`というホスト名でBSVノードにアクセスできます。

## P2P接続の設定

JpyNetworkとLariNetworkのノードは、P2P接続を通じて相互に通信します。この接続は、以下のコマンドで設定されます：

```bash
# コンテナIPの取得
JPY_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jpynetwork-node)
LARI_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' larinetwork-node)

# JpyNetworkをLariNetworkに接続
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${LARI_IP}:19444" add

# LariNetworkをJpyNetworkに接続
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${JPY_IP}:18444" add
```

## ポート転送の設定

AWS EC2インスタンスでBSVネットワークを実行する場合、以下のポートをセキュリティグループで許可する必要があります：

- 22（SSH）
- 18332（JpyNetwork RPC）
- 18444（JpyNetwork P2P）
- 19332（LariNetwork RPC）
- 19444（LariNetwork P2P）
- 5001（トークンブリッジAPI）

## 設定ファイルの管理

設定ファイルは、`~/Multi-Bsv-Network/one-click-setup`ディレクトリに保存されています。このディレクトリには、以下のファイルが含まれています：

- `jpynetwork/bitcoin.conf`: JpyNetworkノードの設定ファイル
- `larinetwork/bitcoin.conf`: LariNetworkノードの設定ファイル
- `token-bridge/Dockerfile`: トークンブリッジAPIのDockerfile
- `token-bridge/app.py`: トークンブリッジAPIのソースコード
- `start.sh`: ネットワークを起動するスクリプト
- `stop.sh`: ネットワークを停止するスクリプト
- `status.sh`: ネットワークの状態を確認するスクリプト

## 設定の変更方法

設定を変更するには、以下の手順に従います：

1. ネットワークを停止します：
   ```bash
   cd ~/Multi-Bsv-Network/one-click-setup
   ./stop.sh
   ```

2. 設定ファイルを編集します：
   ```bash
   nano ~/Multi-Bsv-Network/one-click-setup/jpynetwork/bitcoin.conf
   nano ~/Multi-Bsv-Network/one-click-setup/larinetwork/bitcoin.conf
   ```

3. ネットワークを再起動します：
   ```bash
   cd ~/Multi-Bsv-Network/one-click-setup
   ./start.sh
   ```

## 次のステップ

ネットワーク設定の詳細を理解したら、[マイニング設定](mining-configuration.md)セクションに進んで、BSVネットワークのマイニング設定について詳しく学ぶことができます。
