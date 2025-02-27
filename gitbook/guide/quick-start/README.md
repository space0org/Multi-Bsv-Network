# クイックスタートガイド

このガイドでは、JpyNetworkとLariNetworkに素早く接続し、使用を開始する方法を説明します。

## 前提条件

- Dockerがインストールされていること
- インターネット接続があること
- 最小システム要件: 2GB RAM, 2 CPUコア, 20GB ディスク容量

## ワンクリックセットアップ

1. 以下のコマンドを実行して、リポジトリをクローンします：

```bash
git clone https://github.com/space0org/Multi-Bsv-Network.git
cd Multi-Bsv-Network/one-click-setup
```

2. セットアップスクリプトを実行します：

```bash
./setup.sh
```

3. ネットワークを起動します：

```bash
./start-networks.sh
```

これだけで、JpyNetworkとLariNetworkの両方のノードが起動し、自動的にネットワークに接続されます。

## ネットワークの確認

ネットワークが正常に起動したことを確認するには：

```bash
./check-status.sh
```

## ウォレットの作成

新しいウォレットを作成するには：

```bash
./create-wallet.sh
```

## トランザクションの送信

トランザクションを送信するには：

```bash
./send-transaction.sh <送信先アドレス> <金額>
```

## トークンブリッジの使用

JpyNetworkとLariNetwork間でトークンを交換するには：

```bash
./swap-tokens.sh <送信元ネットワーク> <送信先ネットワーク> <金額>
```

例：
```bash
./swap-tokens.sh jpy lari 100
```

これにより、100 Jpy（100 satoshi）が1.82 Lari（1.82 satoshi）に交換されます（交換レート: 1 Lari = 55 Jpy）。

## 詳細情報

より詳細な情報については、以下のセクションを参照してください：

- [セットアップガイド](../setup/README.md)
- [使用ガイド](../usage/README.md)
- [API ドキュメント](../api/README.md)
- [トラブルシューティング](../troubleshooting/README.md)
