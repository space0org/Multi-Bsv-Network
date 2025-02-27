# 一般的な問題

このセクションでは、BSVネットワーク（JpyNetworkとLariNetwork）の使用中によく発生する問題とその解決方法について説明します。

## ネットワークの起動に関する問題

### 問題: Dockerコンテナが起動しない

**症状**: `start.sh`スクリプトを実行しても、Dockerコンテナが起動しない、または起動後すぐに停止する。

**考えられる原因**:
- Dockerサービスが実行されていない
- ポートが既に使用されている
- 設定ファイルに問題がある
- ディスク容量が不足している

**解決方法**:

1. Dockerサービスが実行中であることを確認します：
   ```bash
   sudo systemctl status docker
   ```
   実行されていない場合は、以下のコマンドで起動します：
   ```bash
   sudo systemctl start docker
   ```

2. 使用するポートが利用可能であることを確認します：
   ```bash
   netstat -tuln | grep 18332
   netstat -tuln | grep 19332
   netstat -tuln | grep 5001
   ```
   ポートが既に使用されている場合は、使用中のプロセスを停止するか、設定ファイルで別のポートを指定します。

3. 設定ファイルを確認します：
   ```bash
   cat ~/Multi-Bsv-Network/one-click-setup/jpynetwork/bitcoin.conf
   cat ~/Multi-Bsv-Network/one-click-setup/larinetwork/bitcoin.conf
   ```
   設定ファイルに問題がある場合は、正しい設定に修正します。

4. ディスク容量を確認します：
   ```bash
   df -h
   ```
   ディスク容量が不足している場合は、不要なファイルを削除するか、ディスク容量を増やします。

### 問題: P2P接続が確立されない

**症状**: ノードが起動しても、P2P接続が確立されない。`status.sh`スクリプトを実行すると、P2P接続が表示されない。

**考えられる原因**:
- ネットワーク設定に問題がある
- ファイアウォールがP2P接続をブロックしている
- ノードのIPアドレスが変更された

**解決方法**:

1. 手動でP2P接続を確立します：
   ```bash
   # コンテナIPの取得
   JPY_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jpynetwork-node)
   LARI_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' larinetwork-node)

   # JpyNetworkをLariNetworkに接続
   docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${LARI_IP}:19444" add

   # LariNetworkをJpyNetworkに接続
   docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${JPY_IP}:18444" add
   ```

2. ファイアウォール設定を確認します：
   ```bash
   sudo ufw status
   ```
   必要なポートが許可されていない場合は、以下のコマンドで許可します：
   ```bash
   sudo ufw allow 18444/tcp
   sudo ufw allow 19444/tcp
   ```

3. ノードを再起動します：
   ```bash
   cd ~/Multi-Bsv-Network/one-click-setup
   ./stop.sh
   ./start.sh
   ```

## トークンブリッジに関する問題

### 問題: トークンブリッジAPIにアクセスできない

**症状**: `curl http://localhost:5001/bridge/info`を実行すると、接続エラーが発生する。

**考えられる原因**:
- トークンブリッジコンテナが起動していない
- APIサーバーがクラッシュしている
- ポート5001が別のプロセスで使用されている

**解決方法**:

1. トークンブリッジコンテナの状態を確認します：
   ```bash
   docker ps | grep token-bridge
   ```
   コンテナが実行されていない場合は、以下のコマンドで起動します：
   ```bash
   docker start token-bridge
   ```
   または、コンテナを再作成します：
   ```bash
   cd ~/Multi-Bsv-Network/one-click-setup
   docker build -t token-bridge ./token-bridge
   docker run -d --name token-bridge --network bsv-network -p 5001:5001 token-bridge
   ```

2. トークンブリッジのログを確認します：
   ```bash
   docker logs token-bridge
   ```
   エラーメッセージを確認し、問題を特定します。

3. ポート5001が利用可能であることを確認します：
   ```bash
   netstat -tuln | grep 5001
   ```
   ポートが既に使用されている場合は、使用中のプロセスを停止するか、トークンブリッジの設定で別のポートを指定します。

### 問題: トークン交換が失敗する

**症状**: トークン交換リクエストを送信すると、エラーが返される。

**考えられる原因**:
- ウォレットに十分な残高がない
- 秘密鍵が正しくない
- ネットワーク接続に問題がある
- トランザクションの手数料が高すぎる

**解決方法**:

1. ウォレットの残高を確認します：
   ```bash
   curl "http://localhost:5001/wallet/balance?address=YOUR_ADDRESS&network=jpy"
   curl "http://localhost:5001/wallet/balance?address=YOUR_ADDRESS&network=lari"
   ```
   残高が不足している場合は、マイニング報酬を生成するか、別のウォレットから資金を送金します。

2. 秘密鍵が正しいことを確認します。秘密鍵はウォレット作成時に生成されたものを使用してください。

3. ネットワーク接続を確認します：
   ```bash
   docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo
   docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo
   ```
   P2P接続が確立されていない場合は、前述の方法でP2P接続を確立します。

4. トランザクションの手数料を確認します。デフォルトの手数料設定が高すぎる場合は、トークンブリッジの設定を調整します。

## マイニングに関する問題

### 問題: マイニングプロセスが実行されていない

**症状**: `status.sh`スクリプトを実行すると、マイニングプロセスが表示されない。ブロック高が増加しない。

**考えられる原因**:
- マイニングプロセスが停止している
- マイニングプロセスがクラッシュした
- システムリソースが不足している

**解決方法**:

1. マイニングプロセスの状態を確認します：
   ```bash
   ps aux | grep "docker exec" | grep "generate" | grep -v grep
   ```
   プロセスが実行されていない場合は、以下のコマンドでマイニングを再開します：
   ```bash
   # JpyNetworkのマイニング開始
   nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > jpynetwork_mining.log 2>&1 &

   # LariNetworkのマイニング開始
   nohup bash -c 'while true; do docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > larinetwork_mining.log 2>&1 &
   ```

2. マイニングログを確認します：
   ```bash
   cat jpynetwork_mining.log
   cat larinetwork_mining.log
   ```
   エラーメッセージを確認し、問題を特定します。

3. システムリソースを確認します：
   ```bash
   top
   ```
   システムリソースが不足している場合は、不要なプロセスを停止するか、インスタンスのサイズを大きくします。

### 問題: ブロック生成が遅い

**症状**: ブロックが生成されるまでに時間がかかる。ブロック高の増加が遅い。

**考えられる原因**:
- マイニングの間隔が長すぎる
- システムリソースが不足している
- ネットワークの負荷が高い

**解決方法**:

1. マイニングの間隔を短くします。`start.sh`スクリプト内のマイニングコマンドの`sleep`時間を調整します：
   ```bash
   # 例: 30秒から10秒に変更
   nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 10; done' > jpynetwork_mining.log 2>&1 &
   ```

2. システムリソースを確認します：
   ```bash
   top
   ```
   システムリソースが不足している場合は、不要なプロセスを停止するか、インスタンスのサイズを大きくします。

3. ネットワークの負荷を確認します：
   ```bash
   docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getmempoolinfo
   docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getmempoolinfo
   ```
   メモリプールに多数のトランザクションがある場合は、ネットワークの負荷が高い可能性があります。

## その他の問題

### 問題: データディレクトリが破損している

**症状**: ノードの起動時にエラーが発生する。ログに「データベースの破損」や「ブロックチェーンの不整合」などのエラーメッセージが表示される。

**考えられる原因**:
- 不正なシャットダウン
- ディスクエラー
- ソフトウェアのバグ

**解決方法**:

1. ノードを停止します：
   ```bash
   cd ~/Multi-Bsv-Network/one-click-setup
   ./stop.sh
   ```

2. データディレクトリをバックアップします：
   ```bash
   cp -r ~/Multi-Bsv-Network/one-click-setup/jpynetwork/data ~/jpynetwork_data_backup
   cp -r ~/Multi-Bsv-Network/one-click-setup/larinetwork/data ~/larinetwork_data_backup
   ```

3. データディレクトリを削除します：
   ```bash
   rm -rf ~/Multi-Bsv-Network/one-click-setup/jpynetwork/data
   rm -rf ~/Multi-Bsv-Network/one-click-setup/larinetwork/data
   ```

4. ノードを再起動します：
   ```bash
   cd ~/Multi-Bsv-Network/one-click-setup
   ./start.sh
   ```
   これにより、ブロック0から新しいブロックチェーンが作成されます。

### 問題: デスクトップショートカットが機能しない

**症状**: デスクトップショートカットをクリックしても、何も起こらない。

**考えられる原因**:
- ショートカットファイルに実行権限がない
- パスが正しくない
- デスクトップ環境がデスクトップエントリファイルをサポートしていない

**解決方法**:

1. ショートカットファイルに実行権限があることを確認します：
   ```bash
   chmod +x ~/Desktop/*.desktop
   ```

2. ショートカットファイルのパスが正しいことを確認します：
   ```bash
   cat ~/Desktop/Start_BSV_Networks.desktop
   ```
   パスが正しくない場合は、正しいパスに修正します。

3. デスクトップ環境がデスクトップエントリファイルをサポートしていない場合は、代わりにシェルスクリプトを作成します：
   ```bash
   cat > ~/Desktop/start_bsv_networks.sh << 'EOF'
   #!/bin/bash
   cd ~/Multi-Bsv-Network/one-click-setup
   ./start.sh
   EOF
   chmod +x ~/Desktop/start_bsv_networks.sh
   ```

## 次のステップ

問題の診断に役立つログファイルの確認方法については、[ログの確認](checking-logs.md)セクションを参照してください。
