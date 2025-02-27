# マイニング設定

このセクションでは、BSVネットワーク（JpyNetworkとLariNetwork）のマイニング設定について説明します。

## マイニングの概要

BSVネットワークでは、マイニングプロセスによって新しいブロックが生成され、トランザクションが確認されます。JpyNetworkとLariNetworkは、独立したネットワークとして動作し、それぞれ独自のマイニングプロセスを持っています。

マイニングは、以下の目的で行われます：

1. **新しいブロックの生成**: ブロックチェーンに新しいブロックを追加します。
2. **トランザクションの確認**: ブロックに含まれるトランザクションを確認し、有効にします。
3. **報酬の生成**: マイニング報酬として新しいコインを生成します。
## マイニングスクリプト

BSVネットワークのマイニングは、以下のスクリプトによって自動化されています：

### JpyNetworkのマイニングスクリプト

```bash
#!/bin/bash

# JpyNetworkのマイニングを開始
nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > jpynetwork_mining.log 2>&1 &

echo "JpyNetworkのマイニングを開始しました。ログは jpynetwork_mining.log に保存されます。"
```

このスクリプトは、30秒ごとに1つのブロックを生成します。マイニングプロセスはバックグラウンドで実行され、ログは`jpynetwork_mining.log`ファイルに保存されます。

### LariNetworkのマイニングスクリプト

```bash
#!/bin/bash

# LariNetworkのマイニングを開始
nohup bash -c 'while true; do docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > larinetwork_mining.log 2>&1 &

echo "LariNetworkのマイニングを開始しました。ログは larinetwork_mining.log に保存されます。"
```

このスクリプトも、30秒ごとに1つのブロックを生成します。マイニングプロセスはバックグラウンドで実行され、ログは`larinetwork_mining.log`ファイルに保存されます。
## マイニングの開始と停止

### マイニングの開始

マイニングは、`start.sh`スクリプトの一部として自動的に開始されます。手動でマイニングを開始するには、以下のコマンドを実行します：

```bash
cd ~/Multi-Bsv-Network/one-click-setup

# JpyNetworkのマイニングを開始
nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > jpynetwork_mining.log 2>&1 &

# LariNetworkのマイニングを開始
nohup bash -c 'while true; do docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > larinetwork_mining.log 2>&1 &
```

### マイニングの停止

マイニングを停止するには、マイニングプロセスを終了する必要があります。以下のコマンドを実行します：

```bash
# JpyNetworkのマイニングプロセスを検索して終了
ps aux | grep "docker exec jpynetwork-node bitcoin-cli" | grep -v grep | awk '{print $2}' | xargs kill

# LariNetworkのマイニングプロセスを検索して終了
ps aux | grep "docker exec larinetwork-node bitcoin-cli" | grep -v grep | awk '{print $2}' | xargs kill
```
## マイニングパラメータの調整

マイニングパラメータを調整することで、ブロック生成の頻度やマイニングの動作を変更できます。

### ブロック生成間隔の調整

デフォルトでは、30秒ごとに1つのブロックが生成されます。この間隔を変更するには、マイニングスクリプトの`sleep`パラメータを調整します：

```bash
# 10秒ごとにブロックを生成する例
nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 10; done' > jpynetwork_mining.log 2>&1 &
```

### 一度に生成するブロック数の調整

デフォルトでは、1回のコマンド実行で1つのブロックが生成されます。一度に複数のブロックを生成するには、`generate`コマンドのパラメータを調整します：

```bash
# 一度に5つのブロックを生成する例
nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 5; sleep 30; done' > jpynetwork_mining.log 2>&1 &
```
## 特定のアドレスへのマイニング報酬の送信

マイニング報酬を特定のアドレスに送信するには、`generatetoaddress`コマンドを使用します：

```bash
# 特定のアドレスに対してマイニングを行う例
nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generatetoaddress 1 "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ"; sleep 30; done' > jpynetwork_mining.log 2>&1 &
```

## マイニングの監視

マイニングプロセスを監視するには、以下の方法があります：

### マイニングログの確認

マイニングログを確認するには、以下のコマンドを実行します：

```bash
# JpyNetworkのマイニングログを確認
tail -f ~/Multi-Bsv-Network/one-click-setup/jpynetwork_mining.log

# LariNetworkのマイニングログを確認
tail -f ~/Multi-Bsv-Network/one-click-setup/larinetwork_mining.log
```

### ブロック高の確認

ブロック高を確認するには、以下のコマンドを実行します：

```bash
# JpyNetworkのブロック高を確認
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount

# LariNetworkのブロック高を確認
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
```
### マイニングプロセスの確認

マイニングプロセスが実行中であることを確認するには、以下のコマンドを実行します：

```bash
# マイニングプロセスを確認
ps aux | grep "docker exec" | grep "generate" | grep -v grep
```

## マイニングのベストプラクティス

### 適切なブロック生成間隔の設定

ブロック生成間隔は、ネットワークの負荷とシステムリソースに応じて調整する必要があります。一般的に、以下のガイドラインが推奨されます：

- **開発環境**: 10〜30秒ごとに1ブロック
- **テスト環境**: 30〜60秒ごとに1ブロック
- **本番環境**: 60〜300秒ごとに1ブロック

ブロック生成間隔が短すぎると、システムリソースの消費が増加し、ノードの安定性に影響を与える可能性があります。逆に、間隔が長すぎると、トランザクションの確認に時間がかかるようになります。

### マイニングログの管理

マイニングログは、時間とともに大きくなる可能性があります。ログファイルを管理するために、以下の方法が推奨されます：

```bash
# ログファイルのローテーション設定
cat > ~/Multi-Bsv-Network/one-click-setup/rotate_mining_logs.sh << 'EOF'
#!/bin/bash

# 現在の日時を取得
DATE=$(date +%Y%m%d_%H%M%S)

# ログファイルのバックアップを作成
mv ~/Multi-Bsv-Network/one-click-setup/jpynetwork_mining.log ~/Multi-Bsv-Network/one-click-setup/jpynetwork_mining_${DATE}.log
mv ~/Multi-Bsv-Network/one-click-setup/larinetwork_mining.log ~/Multi-Bsv-Network/one-click-setup/larinetwork_mining_${DATE}.log

# マイニングプロセスを再起動
ps aux | grep "docker exec jpynetwork-node bitcoin-cli" | grep -v grep | awk '{print $2}' | xargs kill
ps aux | grep "docker exec larinetwork-node bitcoin-cli" | grep -v grep | awk '{print $2}' | xargs kill

# マイニングを再開
nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > ~/Multi-Bsv-Network/one-click-setup/jpynetwork_mining.log 2>&1 &
nohup bash -c 'while true; do docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > ~/Multi-Bsv-Network/one-click-setup/larinetwork_mining.log 2>&1 &

echo "ログファイルをローテーションし、マイニングプロセスを再起動しました。"
EOF

chmod +x ~/Multi-Bsv-Network/one-click-setup/rotate_mining_logs.sh
```

このスクリプトを定期的に実行するために、cronジョブを設定することができます：

```bash
# cronジョブを設定（毎日午前0時にログをローテーション）
(crontab -l 2>/dev/null; echo "0 0 * * * ~/Multi-Bsv-Network/one-click-setup/rotate_mining_logs.sh") | crontab -
```

## 次のステップ

マイニング設定を理解したら、[トークンブリッジの実装](token-bridge-implementation.md)セクションに進んで、JpyNetworkとLariNetwork間のトークン交換の仕組みについて詳しく学ぶことができます。
