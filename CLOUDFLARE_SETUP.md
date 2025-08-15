# Cloudflare Pages での LINE連携設定手順

## 🌐 現在の状況
- サイトURL: `https://golf-caddy.pages.dev/`
- プラットフォーム: Cloudflare Pages
- Webhook URL: `https://golf-caddy.pages.dev/line-webhook`

## 🔧 設定手順

### Step 1: Cloudflare Pages 環境変数設定

1. **Cloudflare Dashboardにアクセス**
   - [https://dash.cloudflare.com](https://dash.cloudflare.com) にログイン

2. **Pages → golf-caddy を選択**

3. **Settings → Environment variables**

4. **以下の環境変数を追加：**

```
変数名: LINE_CHANNEL_ACCESS_TOKEN
値: JB6aJjelKtMtZW/1BjktWYqrWu/hPvtfuP9iYPoXCy6QZtPmBSzCsUOdjfLT1XWVQx0bHMaUKLWf1JnB1T8ErFV/+i7yWZEo2lJrdcKLMMrwF+s/32LqeFgFXUiHRknz0MDxIEClGb4nvefgelVr6QdB04t89/1O/w1cDnyilFU=

変数名: LINE_CHANNEL_SECRET  
値: 3ce27edf5017d7a8ba1af8d3e14fb4d8

変数名: SUPABASE_URL
値: (Supabaseプロジェクトの URL)

変数名: SUPABASE_SERVICE_KEY
値: (Supabaseの service_role key)
```

### Step 2: LINE Developers Console でWebhook URL設定

1. **LINE Developers Console に戻る**
   - [https://developers.line.biz](https://developers.line.biz)

2. **キャディタス公式 → Messaging API設定**

3. **Webhook設定**
   ```
   Webhook URL: https://golf-caddy.pages.dev/line-webhook
   ```

4. **「検証」ボタンをクリック**して接続テスト

5. **「Webhookの利用」をONにする**

### Step 3: デプロイ

環境変数設定後、Cloudflare Pagesが自動的に再デプロイされます。

## 🧪 テスト手順

### 1. 基本動作テスト
```bash
curl -X POST https://golf-caddy.pages.dev/line-webhook \
  -H "Content-Type: application/json" \
  -d '{"events":[]}'
```

### 2. LINE連携テスト
1. キャディとして会員登録
2. LINE連携モーダルが表示される
3. LINE友達追加 (@775xibyg)
4. トークンをLINEで送信
5. 連携完了メッセージを確認

## 🔍 トラブルシューティング

### エラー: 401 Unauthorized
- Channel Secretの設定を確認
- Webhook URLが正しいか確認

### エラー: 500 Internal Server Error  
- Supabase URLとサービスキーを確認
- Cloudflare Pages Functions のログを確認

### 環境変数が反映されない
- Cloudflare Pages → Settings → Functions → Environment variables
- 設定後、再デプロイが必要

## 🎯 完成後の動作

1. **ユーザーがLINE友達追加** → ウェルカムメッセージ
2. **アプリでトークン生成** → `LINK:abc123def456`
3. **LINEでトークン送信** → 自動アカウント紐付け
4. **連携完了** → 今後の通知送信が可能

## 📱 実際のWebhook URL

設定するWebhook URL:
```
https://golf-caddy.pages.dev/line-webhook
```

この設定により、Cloudflare Pages環境で完全なLINE連携システムが動作します。
