# JpyNetwork

JpyNetworkは、Bitcoin SVノードのネットワークです。

## 構成

- **ノード**: Node4 (3.107.165.86), Node5 (3.27.37.63), Node6 (3.26.38.112)
- **コンテナ**: node1 (bitcoinsv/bitcoin-sv:1.0.8.beta)
- **ポート**: 18332-18333, 18444

## セットアップ

1. 設定ファイルを確認
```bash
cat config/bitcoin.conf
```

2. Dockerコンテナを起動
```bash
docker-compose up -d
```

3. ノードの状態を確認
```bash
docker exec node1 bitcoin-cli getnetworkinfo
```

## 接続情報

JpyNetworkは合計6台のノードが接続されています。
