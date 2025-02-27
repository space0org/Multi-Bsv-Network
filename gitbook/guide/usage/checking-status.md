# ステータスの確認

このセクションでは、JpyNetworkとLariNetworkの両方のBSVネットワークの状態を確認する方法について説明します。

## status.shスクリプトの使用

ネットワークの状態を確認するには、`one-click-setup`ディレクトリ内の`status.sh`スクリプトを実行します：

```bash
cd ~/Multi-Bsv-Network/one-click-setup
./status.sh
```

このスクリプトは以下の情報を表示します：

1. コンテナの実行状態
2. JpyNetworkの状態（ブロック高、P2P接続）
3. LariNetworkの状態（ブロック高、P2P接続）
4. トークンブリッジの状態
5. マイニングプロセスの状態

## ステータス出力の例

```
===== BSV Networks Status =====
Checking container status...
f3d746bc12fa   bitcoinsv/bitcoin-sv:1.0.8.beta   "/entrypoint.sh bitc…"   About a minute ago   Up About a minute   8332-8333/tcp, 0.0.0.0:18332-18333->18332-18333/tcp, [::]:18332-18333->18332-18333/tcp, 9332-9333/tcp, 0.0.0.0:18444->18444/tcp, [::]:18444->18444/tcp                            jpynetwork-node
837380d70040   bitcoinsv/bitcoin-sv:1.0.8.beta   "/entrypoint.sh bitc…"   About a minute ago   Up About a minute   8332-8333/tcp, 9332-9333/tcp, 0.0.0.0:19332->18332/tcp, [::]:19332->18332/tcp, 0.0.0.0:19333->18333/tcp, [::]:19333->18333/tcp, 0.0.0.0:19444->18444/tcp, [::]:19444->18444/tcp   larinetwork-node
806121d1f755   token-bridge                      "python app.py"          About a minute ago   Up About a minute   0.0.0.0:5001->5001/tcp, [::]:5001->5001/tcp                                                                                                                                       token-bridge

===== JpyNetwork Status =====
Block height:
104
P2P connections:
    "addr": "172.21.0.3:19444",
      "getaddr": 24,
    "addr": "172.21.0.3:34660",
      "getaddr": 24,

===== LariNetwork Status =====
Block height:
104
P2P connections:
    "addr": "172.21.0.2:44904",
      "getaddr": 24,
    "addr": "172.21.0.2:18444",
      "getaddr": 24,

===== Token Bridge Status =====
Bridge API is available at: http://localhost:5001
Bridge info:
{
    "exchange_rate": "1 Lari = 55 Jpy",
    "networks": {
        "jpy_network": {
            "host": "jpynetwork-node",
            "name": "JpyNetwork",
            "port": 18332
        },
        "lari_network": {
            "host": "larinetwork-node",
            "name": "LariNetwork",
            "port": 18332
        }
    },
    "status": "operational"
}

===== Mining Status =====
ubuntu    662006  0.0  0.0   4364  3000 pts/0    SN   09:00   0:00 bash -c while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done
ubuntu    662007  0.0  0.0   4364  2972 pts/0    SN   09:00   0:00 bash -c while true; do docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done

===== End of Status Report =====
```

## ステータス情報の解釈

### コンテナの状態

コンテナの状態セクションでは、各コンテナが実行中かどうかを確認できます。すべてのコンテナが`Up`状態であることを確認してください：

- `jpynetwork-node`: JpyNetworkノードのコンテナ
- `larinetwork-node`: LariNetworkノードのコンテナ
- `token-bridge`: トークンブリッジAPIのコンテナ

### ブロック高

ブロック高セクションでは、各ネットワークの現在のブロック数を確認できます。ネットワークが正常に動作している場合、ブロック高は時間とともに増加します。

- 初期セットアップ直後は、両方のネットワークのブロック高は101になります。
- マイニングが進行すると、ブロック高は増加します。

### P2P接続

P2P接続セクションでは、各ネットワークが他のノードとどのように接続されているかを確認できます。正常な状態では、JpyNetworkとLariNetworkは互いに接続されています。

### トークンブリッジの状態

トークンブリッジの状態セクションでは、トークンブリッジAPIの状態と設定を確認できます：

- `exchange_rate`: 交換レート（1 Lari = 55 Jpy）
- `networks`: 接続されているネットワークの情報
- `status`: ブリッジの状態（"operational"であれば正常）

### マイニングの状態

マイニングの状態セクションでは、マイニングプロセスが実行中かどうかを確認できます。各ネットワークに対して1つのマイニングプロセスが実行されているはずです。

## 手動でのステータス確認

`status.sh`スクリプトを使用せずに、手動でネットワークの状態を確認することもできます：

### コンテナの状態を確認

```bash
docker ps | grep jpynetwork-node
docker ps | grep larinetwork-node
docker ps | grep token-bridge
```

### ブロック高を確認

```bash
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getblockcount
```

### P2P接続を確認

```bash
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getpeerinfo
```

### トークンブリッジの状態を確認

```bash
curl http://localhost:5001/bridge/info
```

### マイニングプロセスを確認

```bash
ps aux | grep "docker exec" | grep "generate" | grep -v grep
```

## トラブルシューティング

ステータス確認中に問題が発生した場合は、以下を確認してください：

1. コンテナが実行中でない場合は、`start.sh`スクリプトを再実行してください。

2. P2P接続がない場合は、以下のコマンドを実行してP2P接続を手動で確立してください：
   ```bash
   # コンテナIPの取得
   JPY_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jpynetwork-node)
   LARI_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' larinetwork-node)

   # JpyNetworkをLariNetworkに接続
   docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${LARI_IP}:19444" add

   # LariNetworkをJpyNetworkに接続
   docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf addnode "${JPY_IP}:18444" add
   ```

3. マイニングプロセスが実行されていない場合は、以下のコマンドを実行してマイニングを再開してください：
   ```bash
   # JpyNetworkのマイニング開始
   nohup bash -c 'while true; do docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > jpynetwork_mining.log 2>&1 &

   # LariNetworkのマイニング開始
   nohup bash -c 'while true; do docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generate 1; sleep 30; done' > larinetwork_mining.log 2>&1 &
   ```

## 次のステップ

ネットワークの状態を確認したら、[ネットワークの停止](stopping-networks.md)に進んでください。
