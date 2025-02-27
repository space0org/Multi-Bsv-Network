# LariNetwork

LariNetworkは、Node5上で動作するBitcoin SVノードのネットワークです。

## 構成

- **ノード**: Node5 (3.27.37.63)
- **コンテナ**: lari-node (bitcoinsv/bitcoin-sv:1.0.8.beta)
- **ポート**: 19332-19333, 19444

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
docker exec lari-node bitcoin-cli -rpcuser=lariuser -rpcpassword=laripassword getnetworkinfo
```

## 注意事項

LariNetworkは、JpyNetworkとは別のネットワークとして動作し、トークンブリッジを通じて相互に通信します。
