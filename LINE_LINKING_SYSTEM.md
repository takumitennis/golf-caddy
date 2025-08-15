# LINE連携・紐付けシステム詳細設計

## 🎯 問題の本質
LINE友達追加 → **LINEユーザーID** と **キャディアカウント** の紐付けが必要
→ 予約通知を正しい人に送れるようになる

## 🔗 紐付けの流れ

### Step 1: 友達追加
```
ユーザー → LINE友達追加 → @775xibyg
```

### Step 2: アカウント紐付け
```
アプリ → 連携用トークン生成 → "LINK:abc123def456"
ユーザー → LINEでトークン送信 → @775xibyg に "LINK:abc123def456"
システム → トークン認識 → キャディアカウントと紐付け完了
```

### Step 3: 通知送信
```
予約確定 → システムがキャディIDからLINEユーザーID取得 → 通知送信
```

## 🛠️ 実装に必要な要素

### 1. LINE Webhook（サーバーサイド）
```javascript
// Netlify Functions の場合: /.netlify/functions/line-webhook.js
exports.handler = async (event, context) => {
  const signature = event.headers['x-line-signature'];
  const body = event.body;
  
  // 署名検証
  if (!verifySignature(body, signature)) {
    return { statusCode: 401, body: 'Unauthorized' };
  }
  
  const events = JSON.parse(body).events;
  
  for (const eventData of events) {
    if (eventData.type === 'message' && eventData.message.type === 'text') {
      await handleTextMessage(eventData);
    } else if (eventData.type === 'follow') {
      await handleFollow(eventData);
    }
  }
  
  return { statusCode: 200, body: 'OK' };
};

async function handleTextMessage(event) {
  const messageText = event.message.text;
  const lineUserId = event.source.userId;
  
  // トークンによる紐付け処理
  if (messageText.startsWith('LINK:')) {
    const token = messageText;
    await linkAccount(token, lineUserId);
    
    // 成功メッセージを送信
    await sendReplyMessage(event.replyToken, '✅ アカウント連携が完了しました！\nキャディ確定などの通知をお送りします。');
  } else {
    // その他のメッセージへの対応
    await sendReplyMessage(event.replyToken, 'ご利用ありがとうございます！\nアカウント連携の際は、アプリで表示されるトークンを送信してください。');
  }
}
```

### 2. トークン管理テーブル（追加）
```sql
-- 一時的なトークン保存用テーブル
CREATE TABLE IF NOT EXISTS public.line_link_tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cid TEXT NOT NULL REFERENCES public.caddies(cid),
  token TEXT UNIQUE NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  used_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_line_link_tokens_token ON public.line_link_tokens(token);
CREATE INDEX idx_line_link_tokens_expires ON public.line_link_tokens(expires_at);
```

### 3. 紐付け処理関数
```javascript
async function linkAccount(token, lineUserId) {
  try {
    // 1. トークンの確認
    const { data: tokenData, error: tokenError } = await supabase
      .from('line_link_tokens')
      .select('cid, expires_at')
      .eq('token', token)
      .is('used_at', null)
      .single();
    
    if (tokenError || !tokenData) {
      throw new Error('無効なトークンです');
    }
    
    // 2. 有効期限チェック
    if (new Date() > new Date(tokenData.expires_at)) {
      throw new Error('トークンの有効期限が切れています');
    }
    
    // 3. LINE連携情報を保存
    const { error: integrationError } = await supabase
      .from('line_integrations')
      .upsert({
        cid: tokenData.cid,
        line_user_id: lineUserId,
        is_active: true,
        linked_at: new Date().toISOString()
      });
    
    if (integrationError) {
      throw new Error('連携の保存に失敗しました');
    }
    
    // 4. トークンを使用済みにマーク
    await supabase
      .from('line_link_tokens')
      .update({ used_at: new Date().toISOString() })
      .eq('token', token);
    
    console.log(`Account linked: CID ${tokenData.cid} ↔ LINE ${lineUserId}`);
    
  } catch (error) {
    console.error('Link account error:', error);
    throw error;
  }
}
```

## 📱 フロントエンド側の改善

### 1. トークン生成・保存の強化
```javascript
async function generateAndSaveLinkToken(cid) {
  const token = 'LINK:' + Math.random().toString(36).substring(2, 15) + 
                Math.random().toString(36).substring(2, 15);
  
  try {
    // トークンをデータベースに保存（10分間有効）
    const { error } = await supabase
      .from('line_link_tokens')
      .insert({
        cid: cid,
        token: token,
        expires_at: new Date(Date.now() + 10 * 60 * 1000).toISOString()
      });
    
    if (error) throw error;
    
    return token;
  } catch (error) {
    console.error('Token save error:', error);
    throw error;
  }
}
```

### 2. 連携状況のリアルタイム確認
```javascript
async function checkLinkingStatus(token) {
  try {
    const { data, error } = await supabase
      .from('line_link_tokens')
      .select('used_at')
      .eq('token', token)
      .single();
    
    if (error) throw error;
    
    return data.used_at !== null; // 使用済み = 連携完了
  } catch (error) {
    return false;
  }
}

// モーダル表示中にポーリングで確認
function startLinkingStatusCheck(token) {
  const interval = setInterval(async () => {
    if (await checkLinkingStatus(token)) {
      clearInterval(interval);
      showSuccessMessage('LINE連携が完了しました！');
      document.getElementById('lineModal').remove();
    }
  }, 3000); // 3秒ごとにチェック
  
  // 5分後に自動停止
  setTimeout(() => clearInterval(interval), 5 * 60 * 1000);
}
```

## 🚀 デプロイ手順

### 1. Netlify Functions設定
```bash
# プロジェクトルートに netlify.toml を作成
[build]
  functions = "netlify/functions"

[build.environment]
  NODE_VERSION = "18"
```

### 2. 環境変数設定
```
LINE_CHANNEL_ACCESS_TOKEN=your_access_token
LINE_CHANNEL_SECRET=your_channel_secret
SUPABASE_URL=your_supabase_url
SUPABASE_SERVICE_KEY=your_service_key
```

### 3. LINE Webhook URL設定
```
https://your-site.netlify.app/.netlify/functions/line-webhook
```

## 🔄 現在の状況と次のステップ

### ✅ 完了済み
- LINE友達追加リンク（@775xibyg）
- UI・フロントエンド実装
- データベース設計

### 🔄 次に必要
1. **LINE Developers Console**でChannel Access Token取得
2. **Netlify Functions**でWebhook実装
3. **Webhook URL**をLINEに設定
4. **実際のテスト**

## 💡 簡単テスト方法

Webhook実装後：
1. キャディ登録 → トークン表示
2. LINEでトークン送信
3. データベースで紐付け確認
4. テスト通知送信

この紐付けシステムにより、**LINEユーザー** ↔ **キャディアカウント** の確実な連携が可能になります！
