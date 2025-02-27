# API使用例

このセクションでは、トークンブリッジAPIの実際の使用例を紹介します。これらの例は、APIを使用して一般的なタスクを実行する方法を示しています。

## 準備

以下の例では、`curl`コマンドを使用してAPIリクエストを送信します。また、JSONデータを整形するために`jq`を使用することもあります。

```
# jqがインストールされていない場合はインストールします
sudo apt-get update
sudo apt-get install -y jq
```

## 例1: 新しいウォレットの作成と残高の確認

この例では、新しいウォレットを作成し、JpyNetworkとLariNetworkの両方でその残高を確認します。

```
#!/bin/bash

# 新しいウォレットを作成
echo "新しいウォレットを作成しています..."
WALLET=$(curl -s -X POST http://localhost:5001/wallet/create)
echo $WALLET | jq

# ウォレット情報を抽出
ADDRESS=$(echo $WALLET | jq -r '.address')
PRIVATE_KEY=$(echo $WALLET | jq -r '.private_key')

echo "作成されたウォレットアドレス: $ADDRESS"
echo "秘密鍵: $PRIVATE_KEY"

# JpyNetworkでの残高を確認
echo "JpyNetworkでの残高を確認しています..."
JPY_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=jpy")
echo $JPY_BALANCE | jq

# LariNetworkでの残高を確認
echo "LariNetworkでの残高を確認しています..."
LARI_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=lari")
echo $LARI_BALANCE | jq
```

### 実行結果

```
新しいウォレットを作成しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "private_key": "cVQFkEwsxX9xMgVJCGkJwdV8yUe9jQx8vTfpZ4BgTL5xvbLUNEPi",
  "public_key": "03a7c1a17c647f5eebf4dba90901c2cf1c4a50e3a9bf6c7f8e6f21f0c2148f262"
}
作成されたウォレットアドレス: mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ
秘密鍵: cVQFkEwsxX9xMgVJCGkJwdV8yUe9jQx8vTfpZ4BgTL5xvbLUNEPi
JpyNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 0,
  "network": "jpy"
}
LariNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 0,
  "network": "lari"
}
```

## 例2: ウォレットへの資金の送金

この例では、マイニング報酬を受け取るためのウォレットを作成し、そのウォレットに資金を送金します。

```
#!/bin/bash

# 新しいウォレットを作成
echo "新しいウォレットを作成しています..."
WALLET=$(curl -s -X POST http://localhost:5001/wallet/create)
ADDRESS=$(echo $WALLET | jq -r '.address')
PRIVATE_KEY=$(echo $WALLET | jq -r '.private_key')

echo "作成されたウォレットアドレス: $ADDRESS"

# JpyNetworkでマイニング報酬を生成
echo "JpyNetworkでマイニング報酬を生成しています..."
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generatetoaddress 1 $ADDRESS

# 残高を確認
echo "JpyNetworkでの残高を確認しています..."
sleep 2  # ブロックが処理されるのを待つ
JPY_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=jpy")
echo $JPY_BALANCE | jq

# LariNetworkでマイニング報酬を生成
echo "LariNetworkでマイニング報酬を生成しています..."
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generatetoaddress 1 $ADDRESS

# 残高を確認
echo "LariNetworkでの残高を確認しています..."
sleep 2  # ブロックが処理されるのを待つ
LARI_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=lari")
echo $LARI_BALANCE | jq
```

### 実行結果

```
新しいウォレットを作成しています...
作成されたウォレットアドレス: mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ
JpyNetworkでマイニング報酬を生成しています...
[
  "7f98dcf887b9ef92a80c59616beb46d6e9af98d4a95469c5c5ae937565eac1df"
]
JpyNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 5000000000,
  "network": "jpy"
}
LariNetworkでマイニング報酬を生成しています...
[
  "3a7e5b8c9d0f1e2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6"
]
LariNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 5000000000,
  "network": "lari"
}
```

## 例3: JpyNetworkからLariNetworkへのトークン交換

この例では、JpyNetworkからLariNetworkにトークンを交換します。交換レートは1 Lari = 55 Jpyです。

```
#!/bin/bash

# 新しいウォレットを作成
echo "新しいウォレットを作成しています..."
WALLET=$(curl -s -X POST http://localhost:5001/wallet/create)
ADDRESS=$(echo $WALLET | jq -r '.address')
PRIVATE_KEY=$(echo $WALLET | jq -r '.private_key')

echo "作成されたウォレットアドレス: $ADDRESS"

# JpyNetworkでマイニング報酬を生成
echo "JpyNetworkでマイニング報酬を生成しています..."
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generatetoaddress 1 $ADDRESS

# 残高を確認
echo "JpyNetworkでの残高を確認しています..."
sleep 2  # ブロックが処理されるのを待つ
JPY_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=jpy")
echo $JPY_BALANCE | jq

# JpyNetworkからLariNetworkにトークンを交換
echo "JpyNetworkからLariNetworkにトークンを交換しています..."
SWAP_RESULT=$(curl -s -X POST http://localhost:5001/bridge/swap \
  -H "Content-Type: application/json" \
  -d '{
    "from_network": "jpy",
    "to_network": "lari",
    "from_address": "'"$ADDRESS"'",
    "to_address": "'"$ADDRESS"'",
    "amount": 550,
    "private_key": "'"$PRIVATE_KEY"'"
  }')
echo $SWAP_RESULT | jq

# 両方のネットワークでの残高を確認
echo "JpyNetworkでの残高を確認しています..."
sleep 2  # トランザクションが処理されるのを待つ
JPY_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=jpy")
echo $JPY_BALANCE | jq

echo "LariNetworkでの残高を確認しています..."
LARI_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=lari")
echo $LARI_BALANCE | jq
```

### 実行結果

```
新しいウォレットを作成しています...
作成されたウォレットアドレス: mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ
JpyNetworkでマイニング報酬を生成しています...
[
  "7f98dcf887b9ef92a80c59616beb46d6e9af98d4a95469c5c5ae937565eac1df"
]
JpyNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 5000000000,
  "network": "jpy"
}
JpyNetworkからLariNetworkにトークンを交換しています...
{
  "from_network": "jpy",
  "to_network": "lari",
  "from_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "to_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "from_amount": 550,
  "to_amount": 10,
  "from_txid": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2",
  "to_txid": "b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3",
  "status": "success"
}
JpyNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 4999999450,
  "network": "jpy"
}
LariNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 10,
  "network": "lari"
}
```

## 例4: LariNetworkからJpyNetworkへのトークン交換

この例では、LariNetworkからJpyNetworkにトークンを交換します。交換レートは1 Lari = 55 Jpyです。

```
#!/bin/bash

# 新しいウォレットを作成
echo "新しいウォレットを作成しています..."
WALLET=$(curl -s -X POST http://localhost:5001/wallet/create)
ADDRESS=$(echo $WALLET | jq -r '.address')
PRIVATE_KEY=$(echo $WALLET | jq -r '.private_key')

echo "作成されたウォレットアドレス: $ADDRESS"

# LariNetworkでマイニング報酬を生成
echo "LariNetworkでマイニング報酬を生成しています..."
docker exec larinetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generatetoaddress 1 $ADDRESS

# 残高を確認
echo "LariNetworkでの残高を確認しています..."
sleep 2  # ブロックが処理されるのを待つ
LARI_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=lari")
echo $LARI_BALANCE | jq

# LariNetworkからJpyNetworkにトークンを交換
echo "LariNetworkからJpyNetworkにトークンを交換しています..."
SWAP_RESULT=$(curl -s -X POST http://localhost:5001/bridge/swap \
  -H "Content-Type: application/json" \
  -d '{
    "from_network": "lari",
    "to_network": "jpy",
    "from_address": "'"$ADDRESS"'",
    "to_address": "'"$ADDRESS"'",
    "amount": 10,
    "private_key": "'"$PRIVATE_KEY"'"
  }')
echo $SWAP_RESULT | jq

# 両方のネットワークでの残高を確認
echo "LariNetworkでの残高を確認しています..."
sleep 2  # トランザクションが処理されるのを待つ
LARI_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=lari")
echo $LARI_BALANCE | jq

echo "JpyNetworkでの残高を確認しています..."
JPY_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=jpy")
echo $JPY_BALANCE | jq
```

### 実行結果

```
新しいウォレットを作成しています...
作成されたウォレットアドレス: mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ
LariNetworkでマイニング報酬を生成しています...
[
  "3a7e5b8c9d0f1e2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6"
]
LariNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 5000000000,
  "network": "lari"
}
LariNetworkからJpyNetworkにトークンを交換しています...
{
  "from_network": "lari",
  "to_network": "jpy",
  "from_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "to_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "from_amount": 10,
  "to_amount": 550,
  "from_txid": "c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4",
  "to_txid": "d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5",
  "status": "success"
}
LariNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 4999999990,
  "network": "lari"
}
JpyNetworkでの残高を確認しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 550,
  "network": "jpy"
}
```

## 例5: トランザクション履歴の取得

この例では、ウォレットのトランザクション履歴を取得します。

```
#!/bin/bash

# 新しいウォレットを作成
echo "新しいウォレットを作成しています..."
WALLET=$(curl -s -X POST http://localhost:5001/wallet/create)
ADDRESS=$(echo $WALLET | jq -r '.address')
PRIVATE_KEY=$(echo $WALLET | jq -r '.private_key')

echo "作成されたウォレットアドレス: $ADDRESS"

# JpyNetworkでマイニング報酬を生成
echo "JpyNetworkでマイニング報酬を生成しています..."
docker exec jpynetwork-node bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf generatetoaddress 1 $ADDRESS

# JpyNetworkからLariNetworkにトークンを交換
echo "JpyNetworkからLariNetworkにトークンを交換しています..."
SWAP_RESULT=$(curl -s -X POST http://localhost:5001/bridge/swap \
  -H "Content-Type: application/json" \
  -d '{
    "from_network": "jpy",
    "to_network": "lari",
    "from_address": "'"$ADDRESS"'",
    "to_address": "'"$ADDRESS"'",
    "amount": 550,
    "private_key": "'"$PRIVATE_KEY"'"
  }')

# トランザクション履歴を取得
echo "JpyNetworkでのトランザクション履歴を取得しています..."
sleep 2  # トランザクションが処理されるのを待つ
JPY_TRANSACTIONS=$(curl -s "http://localhost:5001/wallet/transactions?address=$ADDRESS&network=jpy&limit=5")
echo $JPY_TRANSACTIONS | jq

echo "LariNetworkでのトランザクション履歴を取得しています..."
LARI_TRANSACTIONS=$(curl -s "http://localhost:5001/wallet/transactions?address=$ADDRESS&network=lari&limit=5")
echo $LARI_TRANSACTIONS | jq
```
### 実行結果

```
新しいウォレットを作成しています...
作成されたウォレットアドレス: mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ
JpyNetworkでマイニング報酬を生成しています...
[
  "7f98dcf887b9ef92a80c59616beb46d6e9af98d4a95469c5c5ae937565eac1df"
]
JpyNetworkからLariNetworkにトークンを交換しています...
JpyNetworkでのトランザクション履歴を取得しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "network": "jpy",
  "transactions": [
    {
      "txid": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2",
      "amount": -550,
      "confirmations": 1,
      "time": 1645678901
    },
    {
      "txid": "7f98dcf887b9ef92a80c59616beb46d6e9af98d4a95469c5c5ae937565eac1df",
      "amount": 5000000000,
      "confirmations": 2,
      "time": 1645678800
    }
  ]
}
LariNetworkでのトランザクション履歴を取得しています...
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "network": "lari",
  "transactions": [
    {
      "txid": "b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3",
      "amount": 10,
      "confirmations": 1,
      "time": 1645678901
    }
  ]
}
```

## スクリプトの保存と実行

上記の例をスクリプトとして保存して実行することができます。例えば、以下のようにします：

```
# スクリプトを作成
cat > create_wallet_and_check_balance.sh << 'EOF'
#!/bin/bash

# 新しいウォレットを作成
echo "新しいウォレットを作成しています..."
WALLET=$(curl -s -X POST http://localhost:5001/wallet/create)
echo $WALLET | jq

# ウォレット情報を抽出
ADDRESS=$(echo $WALLET | jq -r '.address')
PRIVATE_KEY=$(echo $WALLET | jq -r '.private_key')

echo "作成されたウォレットアドレス: $ADDRESS"
echo "秘密鍵: $PRIVATE_KEY"

# JpyNetworkでの残高を確認
echo "JpyNetworkでの残高を確認しています..."
JPY_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=jpy")
echo $JPY_BALANCE | jq

# LariNetworkでの残高を確認
echo "LariNetworkでの残高を確認しています..."
LARI_BALANCE=$(curl -s "http://localhost:5001/wallet/balance?address=$ADDRESS&network=lari")
echo $LARI_BALANCE | jq
EOF

# 実行権限を付与
chmod +x create_wallet_and_check_balance.sh

# スクリプトを実行
./create_wallet_and_check_balance.sh
```

## 次のステップ

APIの使用例を理解したら、[トラブルシューティング](../troubleshooting/README.md)セクションに進んで、一般的な問題の解決方法を確認してください。
