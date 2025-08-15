# LINE公式アカウント・API設定ガイド

## 📱 Step 1: LINE公式アカウントの確認

### 既存のLINE公式アカウントがある場合
1. LINE公式アカウントマネージャーにログイン
2. 「設定」→「アカウント設定」でボットIDを確認
3. `@` から始まる文字列（例：`@abc1234`）をメモ

## 🔧 Step 2: LINE Developers Console 設定

### 2-1. LINE Developersアカウント作成・ログイン
1. https://developers.line.biz/ にアクセス
2. LINE アカウントでログイン
3. プロバイダーを作成（会社名など）

### 2-2. Messaging APIチャンネル作成
1. 「新規チャンネル作成」→「Messaging API」
2. 必要情報を入力：
   - チャンネル名: キャディプラス通知
   - チャンネル説明: キャディ向け通知システム
   - 大業種: サービス業
   - 小業種: その他サービス業

### 2-3. 重要な設定値を取得
```
Channel ID: 1234567890
Channel Secret: [32文字の文字列]
Channel Access Token: [長い文字列]
Bot ID: @abc1234
```

## 🌐 Step 3: Webhook設定

### 3-1. Webhookエンドポイント準備
現在のシステムでは、以下のような構成が推奨されます：

```
Option A: Netlify Functions
- /.netlify/functions/line-webhook

Option B: Vercel Functions  
- /api/line-webhook

Option C: 外部サーバー
- https://yourdomain.com/webhook/line
```

### 3-2. Webhook URL設定
LINE Developers Console で：
1. 「Messaging API設定」タブ
2. Webhook URL を入力
3. 「検証」ボタンでテスト
4. Webhook の利用を「オン」

## 🔐 Step 4: セキュリティ設定

### 4-1. 環境変数設定（Netlifyの場合）
```
LINE_CHANNEL_ACCESS_TOKEN=your_access_token_here
LINE_CHANNEL_SECRET=your_channel_secret_here
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 4-2. 応答設定
LINE Developers Console で：
1. 「応答設定」
2. 「自動応答メッセージ」→ オフ
3. 「Webhook」→ オン

## 📊 Step 5: 動作テスト

### 5-1. 基本テスト
1. QRコードで友達追加
2. 「テスト」とメッセージ送信
3. Webhook にリクエストが届くか確認

### 5-2. 連携テスト
1. アプリでLINE連携開始
2. トークン送信
3. 紐付け完了確認

## ⚠️ 注意事項

### セキュリティ
- Channel Secret は絶対に公開しない
- Access Token は環境変数で管理
- Webhook URLはHTTPS必須

### 料金
- 月1,000通まで無料
- 超過分は従量課金（約0.3円/通）

### 制限事項
- プッシュメッセージは友達のみ
- 1日の送信数制限あり（要確認）

## 🎯 現在必要な情報

実装を進めるために以下をお教えください：

1. **LINE公式アカウントのBot ID** (`@abc1234`形式)
2. **Channel Access Token** (取得済みの場合)
3. **Channel Secret** (取得済みの場合)
4. **Webhook設置予定場所** (Netlify/Vercel/自社サーバー等)

これらの情報があれば、具体的な実装コードを提供できます！
