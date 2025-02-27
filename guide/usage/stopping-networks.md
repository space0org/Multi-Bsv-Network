# ネットワークの停止

このセクションでは、JpyNetworkとLariNetworkの両方のBSVネットワークを安全に停止する方法について説明します。

## stop.shスクリプトの使用

ネットワークを停止するには、`one-click-setup`ディレクトリ内の`stop.sh`スクリプトを実行します：

```bash
cd ~/Multi-Bsv-Network/one-click-setup
./stop.sh
```

このスクリプトは以下の処理を自動的に行います：

1. マイニングプロセスの停止
2. Dockerコンテナの停止と削除

## 停止プロセスの詳細

### 1. マイニングプロセスの停止

スクリプトはまず、バックグラウンドで実行されているマイニングプロセスを停止します：

```bash
pkill -f "docker exec jpynetwork-node bitcoin-cli" || true
pkill -f "docker exec larinetwork-node bitcoin-cli" || true
```

これにより、新しいブロックの生成が停止します。

### 2. Dockerコンテナの停止と削除

次に、実行中のDockerコンテナを停止し、削除します：

```bash
docker stop jpynetwork-node larinetwork-node token-bridge 2>/dev/null || true
docker rm jpynetwork-node larinetwork-node token-bridge 2>/dev/null || true
```

これにより、以下のコンテナが停止・削除されます：

- `jpynetwork-node`: JpyNetworkノードのコンテナ
- `larinetwork-node`: LariNetworkノードのコンテナ
- `token-bridge`: トークンブリッジAPIのコンテナ

## 停止の確認

ネットワークが正常に停止したことを確認するには、以下のコマンドを実行します：

```bash
# コンテナが存在しないことを確認
docker ps | grep jpynetwork-node
docker ps | grep larinetwork-node
docker ps | grep token-bridge

# マイニングプロセスが実行されていないことを確認
ps aux | grep "docker exec" | grep "generate" | grep -v grep
```

これらのコマンドは何も出力しないはずです。出力がある場合は、コンテナやプロセスがまだ実行中です。

## 手動での停止

`stop.sh`スクリプトを使用せずに、手動でネットワークを停止することもできます：

### マイニングプロセスの停止

```bash
# マイニングプロセスのPIDを確認
ps aux | grep "docker exec" | grep "generate" | grep -v grep

# プロセスを停止（PIDは実際の値に置き換えてください）
kill <PID>
```

### コンテナの停止と削除

```bash
# コンテナの停止
docker stop jpynetwork-node larinetwork-node token-bridge

# コンテナの削除
docker rm jpynetwork-node larinetwork-node token-bridge
```

## データの保持

ネットワークを停止しても、ブロックチェーンデータは保持されます。データは以下のディレクトリに保存されています：

- JpyNetworkのデータ: `jpynetwork/data/`
- LariNetworkのデータ: `larinetwork/data/`

これらのディレクトリを削除すると、ブロックチェーンデータが失われ、次回起動時にブロック0から再開します。

## トラブルシューティング

停止中に問題が発生した場合は、以下を試してください：

1. コンテナが停止しない場合は、強制的に停止します：
   ```bash
   docker kill jpynetwork-node larinetwork-node token-bridge
   ```

2. マイニングプロセスが停止しない場合は、強制的に停止します：
   ```bash
   pkill -9 -f "docker exec jpynetwork-node bitcoin-cli"
   pkill -9 -f "docker exec larinetwork-node bitcoin-cli"
   ```

3. Dockerサービスに問題がある場合は、Dockerサービスを再起動します：
   ```bash
   sudo systemctl restart docker
   ```

## 次のステップ

ネットワークを停止した後、再度起動する場合は[ネットワークの起動](starting-networks.md)を参照してください。また、[デスクトップショートカット](desktop-shortcuts.md)を使用すると、より簡単にネットワークを管理できます。
