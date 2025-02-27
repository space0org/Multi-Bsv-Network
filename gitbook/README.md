# BSVネットワークドキュメント

## 概要

このドキュメントでは、JpyNetworkとLariNetworkの2つの独立したBitcoin SVネットワークのセットアップ、使用方法、API、トラブルシューティングなどについて説明します。

## JpyNetworkとLariNetworkの特徴

### JpyNetwork
- 独自のブロックチェーンを持つBitcoin SVネットワーク
- 通貨単位: Jpy（1 Jpy = 1 satoshi）
- 10秒ごとにブロックを生成
- 現在のノード: Node4（3.107.165.86）、Node5（3.27.37.63）、Node6（3.26.38.112）

### LariNetwork
- 独自のブロックチェーンを持つBitcoin SVネットワーク
- 通貨単位: Lari（1 Lari = 1 satoshi）
- 10秒ごとにブロックを生成
- 現在のノード: Node5（3.27.37.63）

### トークンブリッジ
- JpyNetworkとLariNetwork間のトークン交換を可能にする
- 交換レート: 1 Lari = 55 Jpy
- RESTful APIを通じてアクセス可能

## ネットワークに参加するメリット

1. **独自のブロックチェーンエコシステム**: 既存のBitcoin SVメインネットとは独立した環境で実験や開発が可能
2. **高速なブロック生成**: 10秒ごとのブロック生成により、トランザクションの確認が迅速
3. **クロスネットワークトークン交換**: 2つのネットワーク間でのトークン交換が可能
4. **低コスト**: トランザクション手数料が非常に低い
5. **開発者フレンドリー**: APIを通じて簡単に統合可能

## クイックスタート

素早く始めるには、[クイックスタートガイド](guide/quick-start/README.md)を参照してください。

## 詳細情報

- [セットアップガイド](guide/setup/README.md)
- [使用ガイド](guide/usage/README.md)
- [外部接続ガイド](guide/external-connection/README.md)
- [API ドキュメント](guide/api/README.md)
- [トラブルシューティング](guide/troubleshooting/README.md)
- [追加セクション](guide/additional/README.md)
