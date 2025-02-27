# ワンクリックBSVネットワークセットアップ

このツールは、JpyNetworkとLariNetworkの両方のBitcoin SVネットワークを自動的に起動し、トークンブリッジを設定し、マイニングを開始するためのワンクリックソリューションです。

## 必要条件

- Docker
- Docker Compose

## 使用方法

### 初回セットアップと起動

```bash
./start.sh
```

このコマンドは以下を実行します：
1. 必要なディレクトリとファイルを作成
2. Docker Composeを使用してコンテナを起動
3. 両方のネットワークで初期ブロックを生成
4. バックグラウンドでマイニングプロセスを開始

### ネットワークの停止

```bash
./stop.sh
```

このコマンドは、マイニングプロセスを停止し、すべてのDockerコンテナを停止します。

### ステータスの確認

```bash
./status.sh
```

このコマンドは、ネットワークのステータス、ブロック高、トークンブリッジの状態を表示します。

## ネットワーク情報

### JpyNetwork
- コンテナ名: jpynetwork-node
- RPC ポート: 18332
- ネットワークポート: 18333
- ブロック同期ポート: 18444
- RPC認証情報: jpyuser / jpypassword

### LariNetwork
- コンテナ名: larinetwork-node
- RPC ポート: 19332
- ネットワークポート: 19333
- ブロック同期ポート: 19444
- RPC認証情報: lariuser / laripassword

### トークンブリッジ
- コンテナ名: token-bridge
- APIポート: 5001
- 交換レート: 1 Lari = 55 Jpy
- エンドポイント:
  - GET /bridge/info - ブリッジ情報の取得
  - POST /bridge/swap/jpy-to-lari - JPYからLariへの交換
  - POST /bridge/swap/lari-to-jpy - LariからJPYへの交換
  - GET /bridge/transactions - 全トランザクション履歴の取得

## 注意事項
- 両ネットワークは独立しており、互いに同期していません
- マイニングは30秒ごとに新しいブロックを生成します
