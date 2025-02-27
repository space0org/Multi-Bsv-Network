# Token Bridge

このトークンブリッジは、JpyNetworkとLariNetworkの間でトークンを交換するためのサービスです。

## 交換レート

1 Lari = 55 Jpy

## 構成

- **コンテナ**: token-bridge
- **ポート**: 5001

## APIエンドポイント

1. **GET /bridge/info**
   - ブリッジの情報（アドレス、残高、交換レート）を取得

2. **POST /bridge/swap/jpy-to-lari**
   - JPYトークンをLariトークンに交換
   - 例: 550 JPY → 10 Lari

3. **POST /bridge/swap/lari-to-jpy**
   - Lariトークンを JPYトークンに交換
   - 例: 5 Lari → 275 JPY

## セットアップ

1. 依存関係をインストール
```bash
pip install -r requirements.txt
```

2. Dockerコンテナを起動
```bash
./deploy.sh
```

3. APIの動作確認
```bash
curl http://localhost:5001/bridge/info
```
