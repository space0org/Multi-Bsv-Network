# 接続の前提条件

BSVネットワーク（JpyNetworkとLariNetwork）に接続するには、以下の前提条件が必要です。

## ソフトウェア要件

* **Bitcoin SV ノードソフトウェア**: Bitcoin SV バージョン1.0.8.beta以上
* **Docker**: バージョン20.10.0以上（推奨）
* **Docker Compose**: バージョン2.0.0以上（推奨）

## ハードウェア要件

* **CPU**: 2コア以上
* **メモリ**: 4GB以上
* **ストレージ**: 20GB以上の空き容量
* **ネットワーク**: 安定したインターネット接続

## ネットワーク要件

* **ポート**: 以下のポートが開放されていることを確認してください
  * JpyNetwork: 8333（P2P）、8332（RPC）
  * LariNetwork: 9333（P2P）、9332（RPC）

## 準備手順

1. Bitcoin SVノードソフトウェアをインストールする
   ```bash
   # Dockerを使用する場合（推奨）
   docker pull bitcoinsv/bitcoin-sv:1.0.8.beta
   
   # または、バイナリからインストールする場合
   wget https://download.bitcoinsv.io/bitcoinsv/1.0.8.beta/bitcoin-sv-1.0.8.beta-x86_64-linux-gnu.tar.gz
   tar -xzf bitcoin-sv-1.0.8.beta-x86_64-linux-gnu.tar.gz
   cd bitcoin-sv-1.0.8.beta/bin
   sudo cp * /usr/local/bin/
   ```

2. 必要なディレクトリを作成する
   ```bash
   mkdir -p ~/bsv-networks/jpynetwork
   mkdir -p ~/bsv-networks/larinetwork
   ```

3. ファイアウォールの設定（必要な場合）
   ```bash
   # UFWを使用する場合
   sudo ufw allow 8333/tcp
   sudo ufw allow 8332/tcp
   sudo ufw allow 9333/tcp
   sudo ufw allow 9332/tcp
   ```

これらの前提条件を満たしたら、次のセクションの「ネットワークへの接続」に進んでください。
