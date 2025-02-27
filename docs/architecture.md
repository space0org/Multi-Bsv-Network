# システムアーキテクチャ

このドキュメントでは、JpyNetworkとLariNetwork、およびトークンブリッジのシステムアーキテクチャについて説明します。

## 全体構成

```
+----------------+                  +----------------+
|                |                  |                |
|   JpyNetwork   |<---------------->|   LariNetwork  |
|                |    Token Bridge  |                |
+----------------+                  +----------------+
      ^                                    ^
      |                                    |
      v                                    v
+----------------+                  +----------------+
|                |                  |                |
|  Node4, Node5, |                  |     Node5      |
|     Node6      |                  |                |
+----------------+                  +----------------+
```

## JpyNetwork

JpyNetworkは、複数のBitcoin SVノードで構成されるネットワークです。

- **ノード**: Node4 (3.107.165.86), Node5 (3.27.37.63), Node6 (3.26.38.112)
- **コンテナ**: node1 (bitcoinsv/bitcoin-sv:1.0.8.beta)
- **ポート**: 18332-18333, 18444
- **ネットワークタイプ**: regtest

## LariNetwork

LariNetworkは、Node5上で動作するBitcoin SVノードのネットワークです。

- **ノード**: Node5 (3.27.37.63)
- **コンテナ**: lari-node (bitcoinsv/bitcoin-sv:1.0.8.beta)
- **ポート**: 19332-19333, 19444
- **ネットワークタイプ**: regtest

## トークンブリッジ

トークンブリッジは、JpyNetworkとLariNetworkの間でトークンを交換するためのサービスです。

- **実装**: Python Flask API
- **コンテナ**: token-bridge
- **ポート**: 5001
- **交換レート**: 1 Lari (1 satoshi) = 55 Jpy (55 satoshi)

### APIエンドポイント

1. **GET /bridge/info**
   - ブリッジの情報（アドレス、残高、交換レート）を取得

2. **POST /bridge/swap/jpy-to-lari**
   - JPYトークンをLariトークンに交換

3. **POST /bridge/swap/lari-to-jpy**
   - Lariトークンを JPYトークンに交換

## 通信フロー

1. ユーザーがトークンブリッジAPIにリクエストを送信
2. トークンブリッジがJpyNetworkとLariNetworkのノードと通信
3. トークンブリッジが両方のネットワークでトランザクションを作成・送信
4. トークンブリッジがトランザクション結果をユーザーに返す
