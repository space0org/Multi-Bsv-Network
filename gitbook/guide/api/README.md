# トークンブリッジAPI

このセクションでは、JpyNetworkとLariNetworkの間でトークンを交換するためのトークンブリッジAPIについて説明します。

## 概要

トークンブリッジAPIは、2つの独立したBSVネットワーク（JpyNetworkとLariNetwork）間でトークンを交換するためのサービスです。このAPIを使用することで、以下のことが可能になります：

- 新しいウォレット（公開鍵と秘密鍵のペア）の作成
- ウォレットの残高確認
- JpyNetworkからLariNetworkへのトークン送金
- LariNetworkからJpyNetworkへのトークン送金

トークンブリッジは、1 Lari = 55 Jpyの固定交換レートを使用します。

## アーキテクチャ

トークンブリッジAPIは、Flaskフレームワークを使用して実装されており、Dockerコンテナとして実行されます。APIは以下のコンポーネントで構成されています：

1. **APIサーバー**: Flaskアプリケーションとして実装され、RESTful APIエンドポイントを提供します。
2. **ネットワークコネクタ**: JpyNetworkとLariNetworkのノードと通信するためのコンポーネント。
3. **ウォレットマネージャ**: 公開鍵と秘密鍵のペアを管理し、トランザクションに署名するためのコンポーネント。
4. **トランザクションブロードキャスター**: 署名されたトランザクションをネットワークにブロードキャストするためのコンポーネント。

## 技術仕様

- **API形式**: RESTful API（JSON）
- **認証**: 現在のバージョンでは認証は実装されていません。
- **ベースURL**: `http://localhost:5001`
- **交換レート**: 1 Lari = 55 Jpy（固定）
- **ネットワーク接続**:
  - JpyNetwork: `jpynetwork-node:18332`（RPC）
  - LariNetwork: `larinetwork-node:18332`（RPC）

## 利用可能なエンドポイント

トークンブリッジAPIは、以下のエンドポイントを提供します：

1. **ブリッジ情報の取得**:
   - エンドポイント: `/bridge/info`
   - メソッド: `GET`
   - 説明: ブリッジの状態、交換レート、接続されているネットワークの情報を取得します。

2. **ウォレットの作成**:
   - エンドポイント: `/wallet/create`
   - メソッド: `POST`
   - 説明: 新しいウォレット（公開鍵と秘密鍵のペア）を作成します。

3. **残高の確認**:
   - エンドポイント: `/wallet/balance`
   - メソッド: `GET`
   - パラメータ: `address`（ウォレットアドレス）, `network`（"jpy"または"lari"）
   - 説明: 指定されたネットワーク上のウォレットの残高を確認します。

4. **トークンの交換**:
   - エンドポイント: `/bridge/swap`
   - メソッド: `POST`
   - パラメータ: `from_network`（"jpy"または"lari"）, `to_network`（"jpy"または"lari"）, `from_address`, `to_address`, `amount`, `private_key`
   - 説明: あるネットワークから別のネットワークにトークンを交換します。

## 使用例

以下は、トークンブリッジAPIの基本的な使用例です：

1. **ブリッジ情報の取得**:
   ```bash
   curl http://localhost:5001/bridge/info
   ```

2. **新しいウォレットの作成**:
   ```bash
   curl -X POST http://localhost:5001/wallet/create
   ```

3. **残高の確認**:
   ```bash
   curl "http://localhost:5001/wallet/balance?address=YOUR_ADDRESS&network=jpy"
   ```

4. **トークンの交換**:
   ```bash
   curl -X POST http://localhost:5001/bridge/swap \
     -H "Content-Type: application/json" \
     -d '{
       "from_network": "jpy",
       "to_network": "lari",
       "from_address": "YOUR_JPY_ADDRESS",
       "to_address": "YOUR_LARI_ADDRESS",
       "amount": 550,
       "private_key": "YOUR_PRIVATE_KEY"
     }'
   ```

## 詳細情報

詳細な情報については、以下のセクションを参照してください：

- [APIエンドポイント](endpoints.md) - 各エンドポイントの詳細な仕様
- [API使用例](examples.md) - 実際のユースケースに基づいた使用例

## トラブルシューティング

APIの使用中に問題が発生した場合は、[トラブルシューティング](../troubleshooting/README.md)セクションを参照してください。
