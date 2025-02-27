# インストール手順

このセクションでは、BSVネットワーク（JpyNetworkとLariNetwork）のインストール方法について説明します。

## リポジトリのクローン

まず、GitHubリポジトリをクローンします：

```bash
git clone https://github.com/space0org/Multi-Bsv-Network.git
cd Multi-Bsv-Network/one-click-setup
```

## ディレクトリ構造

クローンしたリポジトリには以下のディレクトリ構造があります：

```
Multi-Bsv-Network/
├── one-click-setup/
│   ├── jpynetwork/
│   │   └── bitcoin.conf
│   ├── larinetwork/
│   │   └── bitcoin.conf
│   ├── token-bridge/
│   │   ├── app.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   ├── setup.sh
│   ├── start.sh
│   ├── stop.sh
│   ├── status.sh
│   └── create_desktop_shortcut.sh
└── README.md
```

## セットアップスクリプトの実行

リポジトリをクローンした後、セットアップスクリプトを実行して必要なディレクトリとファイルを作成します：

```bash
chmod +x setup.sh
./setup.sh
```

このスクリプトは以下の処理を行います：

1. 必要なディレクトリの作成
2. bitcoin.confファイルの設定
3. トークンブリッジの設定

## Dockerイメージのプルとビルド

セットアップスクリプトは、必要なDockerイメージをプルし、トークンブリッジのDockerイメージをビルドします：

```bash
# Bitcoin SVイメージのプル
docker pull bitcoinsv/bitcoin-sv:1.0.8.beta

# トークンブリッジのビルド
docker build -t token-bridge ./token-bridge
```

## インストールの確認

インストールが正常に完了したことを確認するには、以下のコマンドを実行します：

```bash
# Dockerイメージの確認
docker images | grep bitcoinsv/bitcoin-sv
docker images | grep token-bridge

# ディレクトリとファイルの確認
ls -la jpynetwork/
ls -la larinetwork/
ls -la token-bridge/
```

以下のようなDockerイメージが表示されれば、インストールは成功です：

```
REPOSITORY              TAG         IMAGE ID       CREATED         SIZE
bitcoinsv/bitcoin-sv    1.0.8.beta  abcdef123456   X hours ago     XXX MB
token-bridge            latest      123456abcdef   X minutes ago   XXX MB
```

## トラブルシューティング

インストール中に問題が発生した場合は、以下を確認してください：

1. Dockerが正常に動作していることを確認します：
   ```bash
   docker --version
   docker info
   ```

2. ディスク容量が十分にあることを確認します：
   ```bash
   df -h
   ```

3. ネットワーク接続を確認します：
   ```bash
   ping github.com
   ping docker.io
   ```

## 次のステップ

インストールが完了したら、[初期設定](configuration.md)に進んでください。
