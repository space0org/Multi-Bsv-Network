# APIエンドポイント

このセクションでは、トークンブリッジAPIの各エンドポイントについて詳細に説明します。

## 1. ブリッジ情報の取得

### エンドポイント

```
GET /bridge/info
```

### 説明

このエンドポイントは、トークンブリッジの現在の状態、交換レート、接続されているネットワークの情報を返します。

### リクエストパラメータ

なし

### レスポンス

**成功レスポンス (200 OK)**

```json
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
```

| フィールド | 説明 |
|------------|------|
| `exchange_rate` | JpyNetworkとLariNetwork間の交換レート |
| `networks` | 接続されているネットワークの情報 |
| `networks.jpy_network` | JpyNetworkの接続情報 |
| `networks.lari_network` | LariNetworkの接続情報 |
| `status` | ブリッジの現在の状態（"operational"、"maintenance"など） |

### 使用例

```bash
curl http://localhost:5001/bridge/info
```

## 2. ウォレットの作成

### エンドポイント

```
POST /wallet/create
```

### 説明

このエンドポイントは、新しいウォレット（公開鍵と秘密鍵のペア）を作成します。作成されたウォレットは両方のネットワーク（JpyNetworkとLariNetwork）で使用できます。

### リクエストパラメータ

なし

### レスポンス

**成功レスポンス (200 OK)**

```json
{
    "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
    "private_key": "cVQFkEwsxX9xMgVJCGkJwdV8yUe9jQx8vTfpZ4BgTL5xvbLUNEPi",
    "public_key": "03a7c1a17c647f5eebf4dba90901c2cf1c4a50e3a9bf6c7f8e6f21f0c2148f262"
}
```

| フィールド | 説明 |
|------------|------|
| `address` | 作成されたウォレットのアドレス |
| `private_key` | ウォレットの秘密鍵（安全に保管してください） |
| `public_key` | ウォレットの公開鍵 |

### 使用例

```bash
curl -X POST http://localhost:5001/wallet/create
```

## 3. 残高の確認

### エンドポイント

```
GET /wallet/balance
```

### 説明

このエンドポイントは、指定されたネットワーク上のウォレットの残高を返します。

### リクエストパラメータ

| パラメータ | 必須 | 説明 |
|------------|------|------|
| `address` | はい | 残高を確認するウォレットのアドレス |
| `network` | はい | 残高を確認するネットワーク（"jpy"または"lari"） |

### レスポンス

**成功レスポンス (200 OK)**

```json
{
    "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
    "balance": 5000,
    "network": "jpy"
}
```

| フィールド | 説明 |
|------------|------|
| `address` | 残高を確認したウォレットのアドレス |
| `balance` | ウォレットの残高（satoshi単位） |
| `network` | 残高を確認したネットワーク |

**エラーレスポンス (400 Bad Request)**

```json
{
    "error": "Invalid address or network parameter"
}
```

**エラーレスポンス (500 Internal Server Error)**

```json
{
    "error": "Failed to connect to network node"
}
```

### 使用例

```bash
curl "http://localhost:5001/wallet/balance?address=mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ&network=jpy"
```

## 4. トークンの交換

### エンドポイント

```
POST /bridge/swap
```

### 説明

このエンドポイントは、あるネットワークから別のネットワークにトークンを交換します。交換レートは1 Lari = 55 Jpyです。

### リクエストパラメータ

**リクエストボディ (JSON)**

```json
{
    "from_network": "jpy",
    "to_network": "lari",
    "from_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
    "to_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
    "amount": 550,
    "private_key": "cVQFkEwsxX9xMgVJCGkJwdV8yUe9jQx8vTfpZ4BgTL5xvbLUNEPi"
}
```

| パラメータ | 必須 | 説明 |
|------------|------|------|
| `from_network` | はい | 送金元のネットワーク（"jpy"または"lari"） |
| `to_network` | はい | 送金先のネットワーク（"jpy"または"lari"） |
| `from_address` | はい | 送金元のウォレットアドレス |
| `to_address` | はい | 送金先のウォレットアドレス |
| `amount` | はい | 送金する金額（satoshi単位） |
| `private_key` | はい | 送金元ウォレットの秘密鍵 |

### レスポンス

**成功レスポンス (200 OK)**

```json
{
    "from_network": "jpy",
    "to_network": "lari",
    "from_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
    "to_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
    "from_amount": 550,
    "to_amount": 10,
    "from_txid": "7f98dcf887b9ef92a80c59616beb46d6e9af98d4a95469c5c5ae937565eac1df",
    "to_txid": "3a7e5b8c9d0f1e2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6",
    "status": "success"
}
```

| フィールド | 説明 |
|------------|------|
| `from_network` | 送金元のネットワーク |
| `to_network` | 送金先のネットワーク |
| `from_address` | 送金元のウォレットアドレス |
| `to_address` | 送金先のウォレットアドレス |
| `from_amount` | 送金元ネットワークでの送金額 |
| `to_amount` | 送金先ネットワークでの受取額（交換レート適用後） |
| `from_txid` | 送金元ネットワークでのトランザクションID |
| `to_txid` | 送金先ネットワークでのトランザクションID |
| `status` | トランザクションの状態 |

**エラーレスポンス (400 Bad Request)**

```json
{
    "error": "Invalid parameters or insufficient funds"
}
```

**エラーレスポンス (500 Internal Server Error)**

```json
{
    "error": "Failed to broadcast transaction"
}
```

### 使用例

```bash
curl -X POST http://localhost:5001/bridge/swap \
  -H "Content-Type: application/json" \
  -d '{
    "from_network": "jpy",
    "to_network": "lari",
    "from_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
    "to_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
    "amount": 550,
    "private_key": "cVQFkEwsxX9xMgVJCGkJwdV8yUe9jQx8vTfpZ4BgTL5xvbLUNEPi"
  }'
```

## 5. トランザクション履歴の取得

### エンドポイント

```
GET /wallet/transactions
```

### 説明

このエンドポイントは、指定されたネットワーク上のウォレットのトランザクション履歴を返します。

### リクエストパラメータ

| パラメータ | 必須 | 説明 |
|------------|------|------|
| `address` | はい | トランザクション履歴を取得するウォレットのアドレス |
| `network` | はい | トランザクション履歴を取得するネットワーク（"jpy"または"lari"） |
| `limit` | いいえ | 取得するトランザクションの最大数（デフォルト: 10） |

### レスポンス

**成功レスポンス (200 OK)**

```json
{
    "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
    "network": "jpy",
    "transactions": [
        {
            "txid": "7f98dcf887b9ef92a80c59616beb46d6e9af98d4a95469c5c5ae937565eac1df",
            "amount": -550,
            "confirmations": 3,
            "time": 1645678901
        },
        {
            "txid": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2",
            "amount": 5000,
            "confirmations": 10,
            "time": 1645678800
        }
    ]
}
```

| フィールド | 説明 |
|------------|------|
| `address` | トランザクション履歴を取得したウォレットのアドレス |
| `network` | トランザクション履歴を取得したネットワーク |
| `transactions` | トランザクションのリスト |
| `transactions[].txid` | トランザクションID |
| `transactions[].amount` | トランザクション金額（正: 受取、負: 送金） |
| `transactions[].confirmations` | トランザクションの確認数 |
| `transactions[].time` | トランザクションのタイムスタンプ（UNIX時間） |

**エラーレスポンス (400 Bad Request)**

```json
{
    "error": "Invalid address or network parameter"
}
```

**エラーレスポンス (500 Internal Server Error)**

```json
{
    "error": "Failed to connect to network node"
}
```

### 使用例

```bash
curl "http://localhost:5001/wallet/transactions?address=mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ&network=jpy&limit=5"
```

## エラーコードと説明

| HTTPステータスコード | 説明 |
|---------------------|------|
| 200 | リクエストが成功しました |
| 400 | リクエストパラメータが無効または不足しています |
| 401 | 認証が必要です（将来の実装のために予約） |
| 403 | アクセスが拒否されました（将来の実装のために予約） |
| 404 | リクエストされたリソースが見つかりません |
| 500 | サーバー内部エラーが発生しました |

## 次のステップ

APIエンドポイントの詳細を理解したら、[API使用例](examples.md)に進んで、実際のユースケースに基づいた使用例を確認してください。
