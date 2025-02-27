# トークンブリッジの使用

このセクションでは、JpyNetworkとLariNetworkの間でトークンを交換するためのトークンブリッジの使用方法について説明します。

## トークンブリッジの概要

トークンブリッジは、JpyNetworkとLariNetworkの間でトークンを交換するためのサービスです。交換レートは以下の通りです：

- 1 Lari (1 satoshi) = 55 Jpy (55 satoshi)

つまり、1 Lariを送信すると、55 Jpyを受け取ることができます。逆に、55 Jpyを送信すると、1 Lariを受け取ることができます。

## トークンブリッジの使用方法

### APIを使用したトークン交換

トークンブリッジAPIを使用して、JpyNetworkとLariNetworkの間でトークンを交換できます。

#### JpyからLariへの交換

```bash
# JpyからLariへの交換APIエンドポイント
curl -X POST http://3.27.37.63:8000/api/bridge/swap \
  -H "Content-Type: application/json" \
  -d '{
    "from_network": "jpy",
    "to_network": "lari",
    "from_address": "Jpy送信元アドレス",
    "to_address": "Lari宛先アドレス",
    "amount": 55,
    "private_key": "Jpy送信元アドレスの秘密鍵"
  }'
```

レスポンス例：

```json
{
  "from_txid": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
  "to_txid": "z6y5x4w3v2u1t0s9r8q7p6o5n4m3l2k1j0i9h8g7f6e5d4c3b2a1",
  "from_amount": 55,
  "to_amount": 1,
  "status": "success"
}
```

#### LariからJpyへの交換

```bash
# LariからJpyへの交換APIエンドポイント
curl -X POST http://3.27.37.63:8000/api/bridge/swap \
  -H "Content-Type: application/json" \
  -d '{
    "from_network": "lari",
    "to_network": "jpy",
    "from_address": "Lari送信元アドレス",
    "to_address": "Jpy宛先アドレス",
    "amount": 1,
    "private_key": "Lari送信元アドレスの秘密鍵"
  }'
```

レスポンス例：

```json
{
  "from_txid": "z6y5x4w3v2u1t0s9r8q7p6o5n4m3l2k1j0i9h8g7f6e5d4c3b2a1",
  "to_txid": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
  "from_amount": 1,
  "to_amount": 55,
  "status": "success"
}
```

## トークン交換の確認

トークン交換の状態を確認するには、以下のAPIエンドポイントを使用します。

```bash
# トークン交換の確認APIエンドポイント
curl -X GET http://3.27.37.63:8000/api/bridge/status?txid=トランザクションID
```

レスポンス例：

```json
{
  "from_txid": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
  "to_txid": "z6y5x4w3v2u1t0s9r8q7p6o5n4m3l2k1j0i9h8g7f6e5d4c3b2a1",
  "from_confirmations": 3,
  "to_confirmations": 2,
  "status": "completed"
}
```

## トークンブリッジの手数料

トークンブリッジサービスは現在、手数料なしで提供されています。ただし、将来的には小額の手数料が導入される可能性があります。

## トークンブリッジの制限

- 最小交換額：1 Lari（または55 Jpy）
- 最大交換額：現在制限なし

## トークンブリッジのセキュリティ

トークンブリッジは、以下のセキュリティ対策を実装しています：

1. すべてのAPIリクエストはHTTPS経由で送信されます
2. 秘密鍵はサーバーに保存されません
3. トランザクションは両方のネットワークで確認されます
4. すべてのトランザクションはログに記録されます

トークンブリッジの使用に関する質問や問題がある場合は、管理者にお問い合わせください。
