# トランザクションの送信

このセクションでは、JpyNetworkとLariNetworkでトランザクションを送信する方法について説明します。

## JpyNetworkでのトランザクション送信

### コマンドラインでのトランザクション送信

JpyNetworkでトランザクションを送信するには、以下のコマンドを使用します。

```bash
# JpyNetworkでトランザクションを送信
docker exec jpynetwork bitcoin-cli sendtoaddress "宛先アドレス" 金額
```

例：

```bash
# 100 satoshi（0.00000100 BSV）を送信
docker exec jpynetwork bitcoin-cli sendtoaddress "1AbCdEfGhIjKlMnOpQrStUvWxYz1234567" 0.00000100
```

### APIを使用したトランザクション送信

トークンブリッジAPIを使用して、JpyNetworkでトランザクションを送信することもできます。

```bash
# トランザクション送信APIエンドポイント
curl -X POST http://3.27.37.63:8000/api/transaction/send \
  -H "Content-Type: application/json" \
  -d '{
    "network": "jpy",
    "from_address": "送信元アドレス",
    "to_address": "宛先アドレス",
    "amount": 100,
    "private_key": "秘密鍵"
  }'
```

レスポンス例：

```json
{
  "txid": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
  "status": "success"
}
```

## LariNetworkでのトランザクション送信

### コマンドラインでのトランザクション送信

LariNetworkでトランザクションを送信するには、以下のコマンドを使用します。

```bash
# LariNetworkでトランザクションを送信
docker exec larinetwork bitcoin-cli -rpcport=9332 sendtoaddress "宛先アドレス" 金額
```

例：

```bash
# 100 satoshi（0.00000100 BSV）を送信
docker exec larinetwork bitcoin-cli -rpcport=9332 sendtoaddress "1AbCdEfGhIjKlMnOpQrStUvWxYz7654321" 0.00000100
```

### APIを使用したトランザクション送信

トークンブリッジAPIを使用して、LariNetworkでトランザクションを送信することもできます。

```bash
# トランザクション送信APIエンドポイント
curl -X POST http://3.27.37.63:8000/api/transaction/send \
  -H "Content-Type: application/json" \
  -d '{
    "network": "lari",
    "from_address": "送信元アドレス",
    "to_address": "宛先アドレス",
    "amount": 100,
    "private_key": "秘密鍵"
  }'
```

レスポンス例：

```json
{
  "txid": "z6y5x4w3v2u1t0s9r8q7p6o5n4m3l2k1j0i9h8g7f6e5d4c3b2a1",
  "status": "success"
}
```

## トランザクションの確認

### コマンドラインでのトランザクション確認

トランザクションの確認状態を確認するには、以下のコマンドを使用します。

#### JpyNetworkでのトランザクション確認

```bash
# JpyNetworkでトランザクションを確認
docker exec jpynetwork bitcoin-cli gettransaction "トランザクションID"
```

#### LariNetworkでのトランザクション確認

```bash
# LariNetworkでトランザクションを確認
docker exec larinetwork bitcoin-cli -rpcport=9332 gettransaction "トランザクションID"
```

### APIを使用したトランザクション確認

トークンブリッジAPIを使用して、トランザクションの確認状態を確認することもできます。

```bash
# トランザクション確認APIエンドポイント
curl -X GET http://3.27.37.63:8000/api/transaction/status?network=jpy&txid=トランザクションID
```

レスポンス例：

```json
{
  "txid": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
  "confirmations": 3,
  "status": "confirmed"
}
```

## トランザクション手数料

BSVネットワークでは、トランザクション手数料は非常に低く設定されています。デフォルトでは、1 satoshi/バイトの手数料が適用されます。

次のセクションでは、トークンブリッジの使用方法について説明します。
