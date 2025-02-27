# Multi-BSV-Network

このリポジトリは、複数のBitcoin SVネットワーク（JpyNetworkとLariNetwork）とそれらの間のトークンブリッジのバックアップです。

## GitHub Pagesの有効化手順

1. リポジトリの「Settings」タブをクリック
2. 左側のメニューから「Pages」を選択
3. 「Source」セクションで「Deploy from a branch」を選択
4. 「Branch」ドロップダウンから「gh-pages」を選択し、「/(root)」を選択
5. 「Save」ボタンをクリック

有効化後、ドキュメントは以下のURLでアクセス可能になります：
https://space0org.github.io/Multi-Bsv-Network/

## 構成

- **JpyNetwork**: メインのBSVネットワーク
- **LariNetwork**: セカンダリBSVネットワーク
- **Token Bridge**: 両ネットワーク間のトークン交換ブリッジ（交換レート: 1 Lari = 55 Jpy）

## ディレクトリ構造

- `jpynetwork/`: JpyNetworkの設定ファイル
- `larinetwork/`: LariNetworkの設定ファイル
- `token-bridge/`: トークンブリッジの実装
- `docs/`: ドキュメント
- `gitbook/`: GitBookドキュメント

詳細な情報は各ディレクトリ内のREADMEファイルを参照してください。
