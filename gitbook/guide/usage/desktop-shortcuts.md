# デスクトップショートカット

このセクションでは、BSVネットワーク（JpyNetworkとLariNetwork）を管理するためのデスクトップショートカットの作成と使用方法について説明します。

## create_desktop_shortcut.shスクリプトの使用

デスクトップショートカットを作成するには、`one-click-setup`ディレクトリ内の`create_desktop_shortcut.sh`スクリプトを実行します：

```bash
cd ~/Multi-Bsv-Network/one-click-setup
./create_desktop_shortcut.sh
```

このスクリプトは以下のショートカットをデスクトップに作成します：

1. **Start BSV Networks**: ネットワークを起動するためのショートカット
2. **BSV Networks Status**: ネットワークの状態を確認するためのショートカット
3. **Stop BSV Networks**: ネットワークを停止するためのショートカット

## ショートカット作成プロセスの詳細

スクリプトは以下の処理を行います：

1. デスクトップディレクトリの作成（存在しない場合）
2. 各スクリプト用のデスクトップエントリファイルの作成
3. ショートカットの実行権限の設定

### デスクトップエントリファイルの例

以下は、作成されるデスクトップエントリファイルの例です：

#### Start BSV Networks.desktop

```ini
[Desktop Entry]
Type=Application
Name=Start BSV Networks
Comment=Start JpyNetwork and LariNetwork
Exec=bash -c "cd /path/to/Multi-Bsv-Network/one-click-setup && ./start.sh; read -p 'Press Enter to close...'"
Icon=utilities-terminal
Terminal=true
Categories=Development;
```

#### BSV Networks Status.desktop

```ini
[Desktop Entry]
Type=Application
Name=BSV Networks Status
Comment=Check status of JpyNetwork and LariNetwork
Exec=bash -c "cd /path/to/Multi-Bsv-Network/one-click-setup && ./status.sh; read -p 'Press Enter to close...'"
Icon=utilities-terminal
Terminal=true
Categories=Development;
```

#### Stop BSV Networks.desktop

```ini
[Desktop Entry]
Type=Application
Name=Stop BSV Networks
Comment=Stop JpyNetwork and LariNetwork
Exec=bash -c "cd /path/to/Multi-Bsv-Network/one-click-setup && ./stop.sh; read -p 'Press Enter to close...'"
Icon=utilities-terminal
Terminal=true
Categories=Development;
```

## ショートカットの使用方法

作成されたショートカットは、デスクトップ上にアイコンとして表示されます。以下の方法で使用できます：

1. **Start BSV Networks**:
   - ダブルクリックすると、JpyNetworkとLariNetworkの両方のノードとトークンブリッジが起動します。
   - ターミナルウィンドウが開き、起動プロセスの進行状況が表示されます。
   - 完了後、「Press Enter to close...」と表示されるので、Enterキーを押してウィンドウを閉じます。

2. **BSV Networks Status**:
   - ダブルクリックすると、現在のネットワークの状態が表示されます。
   - ブロック高、P2P接続、トークンブリッジの状態などの情報が表示されます。
   - 確認後、Enterキーを押してウィンドウを閉じます。

3. **Stop BSV Networks**:
   - ダブルクリックすると、実行中のすべてのサービスが停止します。
   - マイニングプロセスとDockerコンテナが停止・削除されます。
   - 完了後、Enterキーを押してウィンドウを閉じます。

## 異なるデスクトップ環境での使用

このスクリプトは、以下のデスクトップ環境で動作します：

- GNOME
- KDE
- XFCE
- MATE
- Cinnamon

ただし、デスクトップ環境によっては、ショートカットの表示や動作が若干異なる場合があります。

## 手動でのショートカット作成

`create_desktop_shortcut.sh`スクリプトを使用せずに、手動でショートカットを作成することもできます：

1. テキストエディタで新しいファイルを作成します：
   ```bash
   nano ~/Desktop/Start_BSV_Networks.desktop
   ```

2. 以下の内容を入力します（パスは実際の環境に合わせて調整してください）：
   ```ini
   [Desktop Entry]
   Type=Application
   Name=Start BSV Networks
   Comment=Start JpyNetwork and LariNetwork
   Exec=bash -c "cd /path/to/Multi-Bsv-Network/one-click-setup && ./start.sh; read -p 'Press Enter to close...'"
   Icon=utilities-terminal
   Terminal=true
   Categories=Development;
   ```

3. ファイルを保存し、実行権限を設定します：
   ```bash
   chmod +x ~/Desktop/Start_BSV_Networks.desktop
   ```

4. 同様の手順で、他のショートカットも作成します。

## トラブルシューティング

ショートカットが動作しない場合は、以下を確認してください：

1. ショートカットファイルに実行権限があることを確認します：
   ```bash
   ls -la ~/Desktop/*.desktop
   ```

2. パスが正しいことを確認します。ショートカットファイルを開いて、`Exec`行のパスが正しいことを確認します：
   ```bash
   cat ~/Desktop/Start_BSV_Networks.desktop
   ```

3. デスクトップ環境がデスクトップエントリファイルをサポートしていることを確認します。サポートされていない場合は、代わりにシェルスクリプトを作成することを検討してください。

## 次のステップ

デスクトップショートカットを作成したら、[トークンブリッジAPI](../api/README.md)の使用方法について学ぶことをお勧めします。
