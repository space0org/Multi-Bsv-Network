# 初期設定

このセクションでは、BSVネットワーク（JpyNetworkとLariNetwork）の初期設定方法について説明します。

## bitcoin.confの設定

JpyNetworkとLariNetworkの両方に対して、bitcoin.confファイルが自動的に設定されます。これらの設定ファイルには、各ネットワークの動作を制御するパラメータが含まれています。

### JpyNetwork bitcoin.conf

JpyNetworkのbitcoin.confファイルには以下の設定が含まれています：

```ini
# JpyNetwork Bitcoin Configuration
server=1
listen=1
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
rpcworkqueue=1000
maxmempool=2000
dbcache=1000
maxorphantx=10
maxmempool=2000
maxconnections=50
maxuploadtarget=5000

# P2P Network Settings
port=18444
rpcport=18332
testnet=0
regtest=1

# Mining Settings
gen=1
genproclimit=1
```

### LariNetwork bitcoin.conf

LariNetworkのbitcoin.confファイルには以下の設定が含まれています：

```ini
# LariNetwork Bitcoin Configuration
server=1
listen=1
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
rpcworkqueue=1000
maxmempool=2000
dbcache=1000
maxorphantx=10
maxmempool=2000
maxconnections=50
maxuploadtarget=5000

# P2P Network Settings
port=19444
rpcport=18332
testnet=0
regtest=1

# Mining Settings
gen=1
genproclimit=1
```

## 重要なパラメータの説明

### 共通パラメータ

- `server=1`: RPCサーバーを有効にします
- `listen=1`: P2P接続を受け入れます
- `txindex=1`: すべてのトランザクションのインデックスを作成します
- `addressindex=1`: アドレスインデックスを有効にします
- `timestampindex=1`: タイムスタンプインデックスを有効にします
- `spentindex=1`: 使用済みアウトプットのインデックスを有効にします
- `testnet=0`: テストネットを無効にします
- `regtest=1`: 独自のプライベートネットワークを作成します

### ネットワーク固有のパラメータ

- JpyNetwork:
  - `port=18444`: P2P接続用のポート
  - `rpcport=18332`: RPC接続用のポート
  - `rpcuser=jpyuser`: RPC認証用のユーザー名
  - `rpcpassword=jpypassword`: RPC認証用のパスワード

- LariNetwork:
  - `port=19444`: P2P接続用のポート
  - `rpcport=18332`: RPC接続用のポート（コンテナ内部）
  - `rpcuser=lariuser`: RPC認証用のユーザー名
  - `rpcpassword=laripassword`: RPC認証用のパスワード

## トークンブリッジの設定

トークンブリッジは、JpyNetworkとLariNetworkの間でトークンを交換するためのAPIを提供します。トークンブリッジの設定は、`token-bridge/app.py`ファイルで行われます。

主な設定パラメータ：

- 交換レート: 1 Lari = 55 Jpy
- JpyNetwork接続情報:
  - ホスト: jpynetwork-node
  - ポート: 18332
  - ユーザー名: jpyuser
  - パスワード: jpypassword
- LariNetwork接続情報:
  - ホスト: larinetwork-node
  - ポート: 18332
  - ユーザー名: lariuser
  - パスワード: laripassword

## ポート転送

各サービスは以下のポートを使用します：

- JpyNetwork:
  - RPC: 18332 (外部からアクセス可能)
  - P2P: 18444 (外部からアクセス可能)
- LariNetwork:
  - RPC: 19332 (外部からアクセス可能、内部では18332)
  - P2P: 19444 (外部からアクセス可能、内部では18444)
- トークンブリッジ:
  - API: 5001 (外部からアクセス可能)

## 設定の確認

設定が正しく適用されていることを確認するには、以下のコマンドを実行します：

```bash
# JpyNetworkの設定を確認
cat jpynetwork/bitcoin.conf

# LariNetworkの設定を確認
cat larinetwork/bitcoin.conf

# トークンブリッジの設定を確認
cat token-bridge/app.py
```

## 次のステップ

設定が完了したら、[ネットワークの起動](../usage/starting-networks.md)に進んでください。
