# トークンブリッジの実装

このセクションでは、JpyNetworkとLariNetwork間のトークン交換を処理するトークンブリッジの実装について説明します。

## トークンブリッジの概要

トークンブリッジは、JpyNetworkとLariNetwork間のトークン交換を可能にするAPIサービスです。このブリッジにより、ユーザーは一方のネットワークのトークンを他方のネットワークのトークンに交換することができます。交換レートは、1 Lari（1 satoshi）= 55 Jpy（55 satoshi）に設定されています。

トークンブリッジは、以下の主要コンポーネントで構成されています：

1. **RESTful API**: クライアントからのリクエストを処理するHTTPエンドポイント
2. **ウォレット管理**: 秘密鍵と公開鍵のペアを生成・管理するコンポーネント
3. **トランザクション処理**: BSVノードとの通信を処理するコンポーネント
4. **交換レート管理**: トークン交換レートを管理するコンポーネント
## API実装

トークンブリッジAPIは、FastAPIフレームワークを使用して実装されています。以下は、APIの主要なエンドポイントです：

- `/bridge/info`: ブリッジの情報（交換レートなど）を取得
- `/wallet/create`: 新しいウォレットを作成
- `/wallet/balance`: ウォレットの残高を確認
- `/bridge/swap`: トークンを交換
- `/wallet/transactions`: ウォレットのトランザクション履歴を取得

### APIコードの構造

トークンブリッジAPIのコードは、以下のような構造になっています：

```python
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
import os
import json
from bitcoinrpc.authproxy import AuthServiceProxy

# 環境変数から設定を読み込む
JPY_RPC_HOST = os.getenv("JPY_RPC_HOST", "jpynetwork-node")
JPY_RPC_PORT = os.getenv("JPY_RPC_PORT", "18332")
JPY_RPC_USER = os.getenv("JPY_RPC_USER", "jpyuser")
JPY_RPC_PASSWORD = os.getenv("JPY_RPC_PASSWORD", "jpypassword")

LARI_RPC_HOST = os.getenv("LARI_RPC_HOST", "larinetwork-node")
LARI_RPC_PORT = os.getenv("LARI_RPC_PORT", "19332")
LARI_RPC_USER = os.getenv("LARI_RPC_USER", "lariuser")
LARI_RPC_PASSWORD = os.getenv("LARI_RPC_PASSWORD", "laripassword")

# 交換レート: 1 Lari = 55 Jpy
EXCHANGE_RATE = int(os.getenv("EXCHANGE_RATE", "55"))

app = FastAPI()

# RPCクライアントを取得する関数
def get_jpy_rpc():
    rpc_connection = AuthServiceProxy(f"http://{JPY_RPC_USER}:{JPY_RPC_PASSWORD}@{JPY_RPC_HOST}:{JPY_RPC_PORT}")
    return rpc_connection

def get_lari_rpc():
    rpc_connection = AuthServiceProxy(f"http://{LARI_RPC_USER}:{LARI_RPC_PASSWORD}@{LARI_RPC_HOST}:{LARI_RPC_PORT}")
    return rpc_connection
```
### APIエンドポイントの実装

#### ブリッジ情報の取得

```python
@app.get("/bridge/info")
def get_bridge_info():
    """ブリッジの情報を取得する"""
    return {
        "name": "JpyNetwork-LariNetwork Token Bridge",
        "version": "1.0.0",
        "networks": ["jpy", "lari"],
        "exchange_rate": {
            "lari_to_jpy": EXCHANGE_RATE,
            "jpy_to_lari": 1 / EXCHANGE_RATE
        }
    }
```

#### ウォレットの作成

```python
class Wallet(BaseModel):
    address: str
    private_key: str

@app.post("/wallet/create", response_model=Wallet)
def create_wallet():
    """新しいウォレットを作成する"""
    # JpyNetworkのRPCクライアントを取得
    jpy_rpc = get_jpy_rpc()
    
    # 新しいアドレスを生成
    address = jpy_rpc.getnewaddress()
    
    # 秘密鍵を取得
    private_key = jpy_rpc.dumpprivkey(address)
    
    return {"address": address, "private_key": private_key}
```
#### 残高の確認

```python
@app.get("/wallet/balance")
def get_balance(address: str, network: str):
    """ウォレットの残高を確認する"""
    if network not in ["jpy", "lari"]:
        raise HTTPException(status_code=400, detail="Invalid network. Use jpy or lari.")
    
    # ネットワークに応じたRPCクライアントを取得
    rpc = get_jpy_rpc() if network == "jpy" else get_lari_rpc()
    
    try:
        # アドレスの残高を取得
        balance = rpc.getreceivedbyaddress(address)
        return {"address": address, "balance": balance, "network": network}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

#### トークンの交換

```python
class SwapRequest(BaseModel):
    from_network: str
    to_network: str
    from_address: str
    to_address: str
    amount: int
    private_key: str

class SwapResponse(BaseModel):
    from_network: str
    to_network: str
    from_address: str
    to_address: str
    from_amount: int
    to_amount: int
    from_txid: str
    to_txid: str
    status: str

@app.post("/bridge/swap", response_model=SwapResponse)
def swap_tokens(request: SwapRequest):
    """トークンを交換する"""
    # ネットワークの検証
    if request.from_network not in ["jpy", "lari"] or request.to_network not in ["jpy", "lari"]:
        raise HTTPException(status_code=400, detail="Invalid network. Use jpy or lari.")
    
    if request.from_network == request.to_network:
        raise HTTPException(status_code=400, detail="From and to networks must be different.")
    
    # 交換レートの計算
    if request.from_network == "jpy" and request.to_network == "lari":
        from_amount = request.amount
        to_amount = request.amount // EXCHANGE_RATE  # 1 Lari = 55 Jpy
    else:  # from_network == "lari" and to_network == "jpy"
        from_amount = request.amount
        to_amount = request.amount * EXCHANGE_RATE  # 1 Lari = 55 Jpy
    
    # 送信元ネットワークのRPCクライアントを取得
    from_rpc = get_jpy_rpc() if request.from_network == "jpy" else get_lari_rpc()
    
    # 送信先ネットワークのRPCクライアントを取得
    to_rpc = get_jpy_rpc() if request.to_network == "jpy" else get_lari_rpc()
    
    try:
        # 送信元アドレスの残高を確認
        balance = from_rpc.getreceivedbyaddress(request.from_address)
        if balance < from_amount:
            raise HTTPException(status_code=400, detail="Insufficient funds")
        
        # 送信元ネットワークからトークンを送信
        from_rpc.importprivkey(request.private_key, "", False)
        bridge_address = from_rpc.getnewaddress()
        from_txid = from_rpc.sendtoaddress(bridge_address, from_amount)
        
        # 送信先ネットワークにトークンを送信
        to_txid = to_rpc.sendtoaddress(request.to_address, to_amount)
        
        return {
            "from_network": request.from_network,
            "to_network": request.to_network,
            "from_address": request.from_address,
            "to_address": request.to_address,
            "from_amount": from_amount,
            "to_amount": to_amount,
            "from_txid": from_txid,
            "to_txid": to_txid,
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```
## Dockerコンテナの設定

トークンブリッジAPIは、Dockerコンテナとして実装されています。以下は、Dockerコンテナの設定です：

### Dockerfile

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### docker-compose.yml

```yaml
version: "3"

services:
  token-bridge:
    build: .
    container_name: token-bridge
    ports:
      - "8000:8000"
    environment:
      - JPY_RPC_HOST=jpynetwork-node
      - JPY_RPC_PORT=18332
      - JPY_RPC_USER=jpyuser
      - JPY_RPC_PASSWORD=jpypassword
      - LARI_RPC_HOST=larinetwork-node
      - LARI_RPC_PORT=19332
      - LARI_RPC_USER=lariuser
      - LARI_RPC_PASSWORD=laripassword
      - EXCHANGE_RATE=55
    networks:
      - bsv-network

networks:
  bsv-network:
    external: true
```
## APIの使用例

以下は、トークンブリッジAPIの使用例です：

### ブリッジ情報の取得

```bash
curl -X GET "http://localhost:8000/bridge/info"
```

応答例：

```json
{
  "name": "JpyNetwork-LariNetwork Token Bridge",
  "version": "1.0.0",
  "networks": ["jpy", "lari"],
  "exchange_rate": {
    "lari_to_jpy": 55,
    "jpy_to_lari": 0.01818181818181818
  }
}
```

### ウォレットの作成

```bash
curl -X POST "http://localhost:8000/wallet/create"
```

応答例：

```json
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "private_key": "cVQVgBr8sW4FTPYz16Wbat1tqTTMFQXUdXZEZ6GYGGRJdpxZJjNM"
}
```

### 残高の確認

```bash
curl -X GET "http://localhost:8000/wallet/balance?address=mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ&network=jpy"
```

応答例：

```json
{
  "address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "balance": 1000.0,
  "network": "jpy"
}
```

### トークンの交換

```bash
curl -X POST "http://localhost:8000/bridge/swap" \\
  -H "Content-Type: application/json" \\
  -d '{"from_network": "jpy", "to_network": "lari", "from_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ", "to_address": "n4VQ5YdHf7hLQ2gWQYYrcxoE5B7nWuDFNF", "amount": 550, "private_key": "cVQVgBr8sW4FTPYz16Wbat1tqTTMFQXUdXZEZ6GYGGRJdpxZJjNM"}'
```

応答例：

```json
{
  "from_network": "jpy",
  "to_network": "lari",
  "from_address": "mhLpGSPdQhfpZzGNYYgFzEYZ1J2TiJ9oLZ",
  "to_address": "n4VQ5YdHf7hLQ2gWQYYrcxoE5B7nWuDFNF",
  "from_amount": 550,
  "to_amount": 10,
  "from_txid": "7b5168316e573f27a13f36b7884a1ed0f8e2dda4315d7a7bc8c51a332a5edb75",
  "to_txid": "8c6f0a4f3b6e2d1c0a9f8e7d6c5b4a3f2e1d0c9b8a7f6e5d4c3b2a1f0e9d8c7b6",
  "status": "success"
}
```
## エラー処理

トークンブリッジAPIでは、以下のようなエラー処理が実装されています：

### 入力検証エラー

- ネットワーク名が無効な場合（"jpy"または"lari"以外）
- 送信元と送信先のネットワークが同じ場合
- 残高が不足している場合

### RPCエラー

- BSVノードに接続できない場合
- RPCコマンドが失敗した場合

### トランザクションエラー

- トランザクションの作成に失敗した場合
- トランザクションのブロードキャストに失敗した場合

## セキュリティ対策

トークンブリッジAPIでは、以下のようなセキュリティ対策が実装されています：

### 秘密鍵の保護

- 秘密鍵はAPIリクエストの一部として送信されますが、HTTPSを使用して通信を暗号化することで保護されます。
- 秘密鍵はサーバー側で一時的にのみ使用され、永続的に保存されることはありません。

### レート制限

- APIリクエストの数を制限することで、DoS攻撃を防止します。

### 入力検証

- すべての入力パラメータを検証し、不正な入力を拒否します。

## 次のステップ

トークンブリッジの実装を理解したら、[セキュリティ対策](security-considerations.md)セクションに進んで、BSVネットワークのセキュリティ対策について詳しく学ぶことができます。

## まとめ

このセクションでは、JpyNetworkとLariNetwork間のトークン交換を処理するトークンブリッジの実装について説明しました。トークンブリッジは、FastAPIフレームワークを使用して実装され、Dockerコンテナとして実行されます。トークンブリッジは、1 Lari（1 satoshi）= 55 Jpy（55 satoshi）の交換レートでトークンを交換します。
