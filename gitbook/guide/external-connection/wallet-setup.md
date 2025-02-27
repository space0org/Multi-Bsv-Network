# ウォレットの設定

このセクションでは、JpyNetworkとLariNetworkで使用するウォレットの設定方法について説明します。

## ウォレットの作成

### コマンドラインでのウォレット作成

Bitcoin SVノードに接続したら、以下のコマンドを使用してウォレットを作成できます。

#### JpyNetworkでのウォレット作成

```bash
# JpyNetworkでウォレットを作成
docker exec jpynetwork bitcoin-cli createwallet "mywallet"

# 新しいアドレスを生成
docker exec jpynetwork bitcoin-cli getnewaddress
```

#### LariNetworkでのウォレット作成

```bash
# LariNetworkでウォレットを作成
docker exec larinetwork bitcoin-cli -rpcport=9332 createwallet "mywallet"

# 新しいアドレスを生成
docker exec larinetwork bitcoin-cli -rpcport=9332 getnewaddress
```

### APIを使用したウォレット作成

トークンブリッジAPIを使用して、両方のネットワークでウォレットを作成することもできます。

```bash
# ウォレット作成APIエンドポイント
curl -X POST http://3.27.37.63:8000/api/wallet/create
```

レスポンス例：

```json
{
  "jpy_address": "1AbCdEfGhIjKlMnOpQrStUvWxYz1234567",
  "lari_address": "1AbCdEfGhIjKlMnOpQrStUvWxYz7654321",
  "private_key": "KyQzHmLrB8C9vGdJpTkFnRsXy1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7"
}
```

**重要**: 秘密鍵は安全に保管してください。秘密鍵を紛失すると、ウォレット内の資金にアクセスできなくなります。

## ウォレットの残高確認

### コマンドラインでの残高確認

#### JpyNetworkでの残高確認

```bash
# JpyNetworkでの残高確認
docker exec jpynetwork bitcoin-cli getbalance
```

#### LariNetworkでの残高確認

```bash
# LariNetworkでの残高確認
docker exec larinetwork bitcoin-cli -rpcport=9332 getbalance
```

### APIを使用した残高確認

トークンブリッジAPIを使用して、両方のネットワークでの残高を確認することもできます。

```bash
# 残高確認APIエンドポイント
curl -X GET http://3.27.37.63:8000/api/wallet/balance?jpy_address=1AbCdEfGhIjKlMnOpQrStUvWxYz1234567&lari_address=1AbCdEfGhIjKlMnOpQrStUvWxYz7654321
```

レスポンス例：

```json
{
  "jpy_balance": 1000,
  "lari_balance": 18.18,
  "jpy_balance_usd": 10.0,
  "lari_balance_usd": 10.0
}
```

## ウォレットのバックアップ

ウォレットをバックアップするには、秘密鍵を安全な場所に保存してください。以下のコマンドを使用して、ウォレットの秘密鍵をダンプできます。

```bash
# JpyNetworkでの秘密鍵のダンプ
docker exec jpynetwork bitcoin-cli dumpprivkey "your_address"

# LariNetworkでの秘密鍵のダンプ
docker exec larinetwork bitcoin-cli -rpcport=9332 dumpprivkey "your_address"
```

次のセクションでは、トランザクションの送信方法について説明します。
