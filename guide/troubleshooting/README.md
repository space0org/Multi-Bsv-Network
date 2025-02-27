# トラブルシューティング

このセクションでは、BSVネットワーク（JpyNetworkとLariNetwork）の使用中に発生する可能性のある一般的な問題と、その解決方法について説明します。

## 内容

- [一般的な問題](common-issues.md) - よくある問題とその解決方法
- [ログの確認](checking-logs.md) - 問題診断のためのログファイルの確認方法

## トラブルシューティングの基本的なアプローチ

BSVネットワークで問題が発生した場合は、以下の基本的なアプローチに従って問題を診断・解決することをお勧めします：

1. **問題の特定**: 発生している問題を明確に特定します。エラーメッセージ、症状、発生時の状況などを記録します。

2. **ステータスの確認**: `status.sh`スクリプトを実行して、ネットワークの現在の状態を確認します。
   ```bash
   cd ~/Multi-Bsv-Network/one-click-setup
   ./status.sh
   ```

3. **ログの確認**: Dockerコンテナのログを確認して、エラーメッセージや警告を探します。
   ```bash
   docker logs jpynetwork-node
   docker logs larinetwork-node
   docker logs token-bridge
   ```

4. **再起動**: 問題が解決しない場合は、ネットワークを再起動してみます。
   ```bash
   cd ~/Multi-Bsv-Network/one-click-setup
   ./stop.sh
   ./start.sh
   ```

5. **設定の確認**: 設定ファイルが正しく構成されていることを確認します。
   ```bash
   cat ~/Multi-Bsv-Network/one-click-setup/jpynetwork/bitcoin.conf
   cat ~/Multi-Bsv-Network/one-click-setup/larinetwork/bitcoin.conf
   ```

## 一般的なエラーメッセージとその意味

以下は、よく見られるエラーメッセージとその意味です：

### 「Error: Unable to start server」

このエラーは、ノードの起動時に発生することがあります。主な原因は以下の通りです：

- ポートが既に使用されている
- 設定ファイルに問題がある
- 十分な権限がない

### 「Error: Connection refused」

このエラーは、APIやノードに接続しようとしたときに発生することがあります。主な原因は以下の通りです：

- サービスが実行されていない
- 指定されたホストやポートが間違っている
- ファイアウォールがアクセスをブロックしている

### 「Error: Insufficient funds」

このエラーは、トークン交換時に発生することがあります。主な原因は以下の通りです：

- ウォレットに十分な残高がない
- トランザクション手数料を含めた金額が残高を超えている

## 問題解決のためのリソース

問題が解決しない場合は、以下のリソースを参照してください：

- [Bitcoin SVのドキュメント](https://bitcoinsv.io/documentation/)
- [Dockerのトラブルシューティングガイド](https://docs.docker.com/engine/troubleshooting/)
- [GitHubリポジトリのIssueページ](https://github.com/space0org/Multi-Bsv-Network/issues)

## 次のステップ

特定の問題の詳細な解決方法については、[一般的な問題](common-issues.md)セクションを参照してください。また、問題の診断に役立つログファイルの確認方法については、[ログの確認](checking-logs.md)セクションを参照してください。
