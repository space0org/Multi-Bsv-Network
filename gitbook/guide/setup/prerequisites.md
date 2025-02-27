# 前提条件

BSVネットワークをセットアップするには、以下のソフトウェアと環境が必要です。

## 必要なソフトウェア

- **Docker**: バージョン20.10.0以上
- **Docker Compose**: バージョン1.29.0以上
- **Git**: バージョン2.25.0以上
- **Bash**: バージョン5.0以上

## システム要件

- **CPU**: 2コア以上
- **メモリ**: 4GB以上
- **ストレージ**: 20GB以上の空き容量
- **ネットワーク**: インターネット接続

## 対応OS

- **Linux**: Ubuntu 20.04 LTS以上
- **macOS**: 10.15 (Catalina)以上
- **Windows**: Windows 10以上（WSL2を使用）

## Dockerのインストール

### Ubuntu

```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo usermod -aG docker $USER
newgrp docker
```

### macOS

1. [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)をダウンロードしてインストールします。
2. インストール後、Docker Desktopを起動します。

### Windows (WSL2)

1. [WSL2をインストール](https://docs.microsoft.com/ja-jp/windows/wsl/install)します。
2. [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)をダウンロードしてインストールします。
3. Docker Desktopの設定で「Use the WSL 2 based engine」を有効にします。

## インストールの確認

以下のコマンドを実行して、必要なソフトウェアが正しくインストールされていることを確認します：

```bash
docker --version
docker-compose --version
git --version
bash --version
```

すべてのコマンドが正常に実行され、バージョン情報が表示されれば、セットアップの準備が整っています。

## 次のステップ

前提条件を満たしたら、[インストール手順](installation.md)に進んでください。
