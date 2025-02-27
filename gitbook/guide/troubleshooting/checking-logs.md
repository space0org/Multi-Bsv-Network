# ログの確認

このセクションでは、BSVネットワーク（JpyNetworkとLariNetwork）のトラブルシューティングに役立つログファイルの確認方法について説明します。

## Dockerコンテナのログ

BSVネットワークは、主に3つのDockerコンテナで構成されています：
- `jpynetwork-node` - JpyNetworkのBSVノード
- `larinetwork-node` - LariNetworkのBSVノード
- `token-bridge` - JpyNetworkとLariNetwork間のトークン交換を処理するAPIサーバー

各コンテナのログは、以下のコマンドで確認できます：

```bash
# JpyNetworkノードのログを確認
docker logs jpynetwork-node

# LariNetworkノードのログを確認
docker logs larinetwork-node

# トークンブリッジAPIのログを確認
docker logs token-bridge
```

特定の時間範囲のログを確認したい場合は、以下のオプションを使用できます：

```bash
# 最新の100行のログを確認
docker logs --tail 100 jpynetwork-node

# 過去1時間のログを確認
docker logs --since 1h jpynetwork-node

# リアルタイムでログを監視（Ctrl+Cで終了）
docker logs -f jpynetwork-node
```

## BSVノードのログ

BSVノード内のログファイルは、以下のコマンドで確認できます：

```bash
# JpyNetworkノードのdebug.logを確認
docker exec jpynetwork-node cat /home/bitcoin/.bitcoin/debug.log

# LariNetworkノードのdebug.logを確認
docker exec larinetwork-node cat /home/bitcoin/.bitcoin/debug.log
```

ログファイルが大きい場合は、以下のコマンドで最新の部分だけを確認できます：

```bash
# 最新の100行のログを確認
docker exec jpynetwork-node tail -n 100 /home/bitcoin/.bitcoin/debug.log

# リアルタイムでログを監視（Ctrl+Cで終了）
docker exec jpynetwork-node tail -f /home/bitcoin/.bitcoin/debug.log
```

## マイニングログ

マイニングプロセスのログは、以下のファイルに保存されています：

```bash
# JpyNetworkのマイニングログを確認
cat ~/Multi-Bsv-Network/one-click-setup/jpynetwork_mining.log

# LariNetworkのマイニングログを確認
cat ~/Multi-Bsv-Network/one-click-setup/larinetwork_mining.log
```

## ログの解析

### 一般的なエラーメッセージとその意味

BSVノードのログには、以下のような一般的なエラーメッセージが含まれることがあります：

#### 「Error: Unable to bind to xxx.xxx.xxx.xxx:xxxxx on this computer」

このエラーは、ノードが指定されたIPアドレスとポートにバインドできないことを示しています。主な原因は以下の通りです：
- 指定されたポートが既に使用されている
- 指定されたIPアドレスがこのコンピュータに存在しない
- 十分な権限がない

#### 「Error: Error opening block database」

このエラーは、ブロックデータベースを開くことができないことを示しています。主な原因は以下の通りです：
- データディレクトリが存在しない
- データディレクトリへのアクセス権がない
- データベースが破損している

#### 「Warning: Reducing -maxconnections from xxx to xxx, because of system limitations」

このメッセージは、システムの制限により、最大接続数が減少されたことを示しています。これは警告であり、エラーではありません。

#### 「Error: Failed to listen on any port」

このエラーは、ノードがどのポートでもリッスンできないことを示しています。主な原因は以下の通りです：
- すべての指定されたポートが既に使用されている
- ファイアウォールがすべてのポートをブロックしている
- 十分な権限がない

### トークンブリッジAPIのログ解析

トークンブリッジAPIのログには、以下のような情報が含まれます：

#### リクエスト情報

```
INFO:     127.0.0.1:52468 - "GET /bridge/info HTTP/1.1" 200 OK
```

このログは、クライアントからのリクエストとそのレスポンスコードを示しています。「200 OK」は、リクエストが成功したことを示しています。

#### エラー情報

```
ERROR:    Exception in ASGI application: Invalid private key
```

このログは、アプリケーション内で例外が発生したことを示しています。この場合、無効な秘密鍵が使用されたことが原因です。

## ログレベルの変更

より詳細なログを取得するために、ログレベルを変更することができます。

### BSVノードのログレベル

BSVノードのログレベルは、`bitcoin.conf`ファイルで設定できます：

```bash
# JpyNetworkのbitcoin.confを編集
cat > ~/Multi-Bsv-Network/one-click-setup/jpynetwork/bitcoin.conf << 'EOF'
# 既存の設定...

# ログレベルを設定（debug, info, warning, error）
debug=1
EOF

# LariNetworkのbitcoin.confを編集
cat > ~/Multi-Bsv-Network/one-click-setup/larinetwork/bitcoin.conf << 'EOF'
# 既存の設定...

# ログレベルを設定（debug, info, warning, error）
debug=1
EOF
```

設定を変更した後、ノードを再起動する必要があります：

```bash
cd ~/Multi-Bsv-Network/one-click-setup
./stop.sh
./start.sh
```

### トークンブリッジAPIのログレベル

トークンブリッジAPIのログレベルは、環境変数で設定できます：

```bash
# トークンブリッジコンテナを停止
docker stop token-bridge

# 新しいログレベルでトークンブリッジコンテナを起動
docker run -d --name token-bridge --network bsv-network -p 5001:5001 -e LOG_LEVEL=DEBUG token-bridge
```

## ログの保存

重要なログを保存するには、以下のコマンドを使用できます：

```bash
# JpyNetworkノードのログを保存
docker logs jpynetwork-node > jpynetwork_node_logs_$(date +%Y%m%d_%H%M%S).log

# LariNetworkノードのログを保存
docker logs larinetwork-node > larinetwork_node_logs_$(date +%Y%m%d_%H%M%S).log

# トークンブリッジAPIのログを保存
docker logs token-bridge > token_bridge_logs_$(date +%Y%m%d_%H%M%S).log
```

## ログローテーション

ログファイルが大きくなりすぎないように、ログローテーションを設定することをお勧めします。Dockerのログローテーションは、以下のように設定できます：

```bash
# /etc/docker/daemon.jsonファイルを作成または編集
sudo cat > /etc/docker/daemon.json << 'EOF'
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Dockerサービスを再起動
sudo systemctl restart docker

# コンテナを再起動
cd ~/Multi-Bsv-Network/one-click-setup
./stop.sh
./start.sh
```

この設定により、各コンテナのログファイルは最大10MBに制限され、最大3つのログファイルが保持されます。

## 次のステップ

ログの確認方法を理解したら、[アーキテクチャ概要](../additional/architecture.md)セクションに進んで、BSVネットワークのアーキテクチャについて詳しく学ぶことができます。
