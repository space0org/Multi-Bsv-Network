# 使用ガイド

このドキュメントでは、JpyNetworkとLariNetworkの使用方法、およびトークンブリッジを通じたトークン交換の方法について説明します。

## JpyNetworkの使用

### ウォレットの作成
```bash
docker exec node1 bitcoin-cli getnewaddress
```

### 残高の確認
```bash
docker exec node1 bitcoin-cli getbalance
```

### トランザクションの送信
```bash
docker exec node1 bitcoin-cli sendtoaddress <送信先アドレス> <金額>
```

## LariNetworkの使用

### ウォレットの作成
```bash
docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword getnewaddress
```

### 残高の確認
```bash
docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword getbalance
```

### トランザクションの送信
```bash
docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword sendtoaddress <送信先アドレス> <金額>
```

## トークンブリッジの使用

### ブリッジ情報の取得
```bash
curl http://localhost:5001/bridge/info
```

### JPYからLariへの交換
```bash
curl -X POST http://localhost:5001/bridge/swap/jpy-to-lari \
  -H "Content-Type: application/json" \
  -d '{
    "from_address": "<JPYアドレス>",
    "private_key": "<秘密鍵>",
    "amount": 550
  }'
```

### LariからJPYへの交換
```bash
curl -X POST http://localhost:5001/bridge/swap/lari-to-jpy \
  -H "Content-Type: application/json" \
  -d '{
    "from_address": "<Lariアドレス>",
    "private_key": "<秘密鍵>",
    "amount": 10
  }'
```

## 交換レート

トークンブリッジは、以下の交換レートでトークンを交換します：

- 1 Lari (1 satoshi) = 55 Jpy (55 satoshi)

### 交換例

1. **JPY → Lari**:
   - 550 JPYを送金
   - 10 Lariを受け取り (550 ÷ 55 = 10)

2. **Lari → JPY**:
   - 5 Lariを送金
   - 275 JPYを受け取り (5 × 55 = 275)

## 注意事項

- トランザクションが確認されるまでに時間がかかる場合があります。
- 十分な残高があることを確認してください。
- 秘密鍵は安全に保管し、公開しないでください。
