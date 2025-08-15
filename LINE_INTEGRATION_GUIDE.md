# LINE連携システム実装ガイド

## 📋 概要
キャディ専用のLINE通知システムで、キャディ確定などの重要な通知をLINEで受け取れるようにします。

## 🔧 必要な技術要素

### 1. LINE Messaging API
- **LINE Developers Console**でチャンネルを作成
- **Channel Access Token**を取得
- **Webhook URL**を設定

### 2. 友達追加の実装方法

#### Option A: LINE Add Friend URL
```javascript
// LINEの友達追加URL（最もシンプル）
const LINE_BOT_ID = '@your-bot-id'; // LINEボットのID
const addFriendUrl = `https://line.me/R/ti/p/${LINE_BOT_ID}`;

// 友達追加ボタン
function openLineAddFriend() {
  window.open(addFriendUrl, '_blank');
}
```

#### Option B: QRコード表示
```javascript
// QRコードを生成してモーダル表示
function showLineQRCode() {
  const qrCodeUrl = `https://qr-official.line.me/sid/L/${LINE_BOT_ID}.png`;
  // QRコードをモーダルで表示
}
```

### 3. アカウント紐付けの実装

#### ステップ1: 紐付け用トークンの生成
```javascript
// 会員登録時またはプロフィール設定時
async function generateLinkToken(cid) {
  const linkToken = generateUniqueToken(); // 一意のトークン生成
  
  // データベースに一時保存（有効期限付き）
  await supabase.from('line_link_tokens').insert({
    cid: cid,
    token: linkToken,
    expires_at: new Date(Date.now() + 10 * 60 * 1000) // 10分間有効
  });
  
  return linkToken;
}
```

#### ステップ2: LINE Webhookでの紐付け処理
```javascript
// LINE Webhook（サーバーサイド）
app.post('/webhook/line', async (req, res) => {
  const events = req.body.events;
  
  for (const event of events) {
    if (event.type === 'message' && event.message.type === 'text') {
      const messageText = event.message.text;
      const lineUserId = event.source.userId;
      
      // トークンによる紐付け確認
      if (messageText.startsWith('LINK:')) {
        const token = messageText.replace('LINK:', '');
        await linkUserAccount(token, lineUserId);
      }
    } else if (event.type === 'follow') {
      // 友達追加時の処理
      await handleNewFollower(event.source.userId);
    }
  }
  
  res.status(200).send('OK');
});
```

### 4. 通知送信システム

```javascript
// LINE通知送信関数
async function sendLineNotification(cid, messageType, data) {
  // 1. キャディのLINE連携情報を取得
  const { data: lineIntegration } = await supabase
    .from('line_integrations')
    .select('line_user_id, is_active')
    .eq('cid', cid)
    .eq('is_active', true)
    .single();
  
  if (!lineIntegration) {
    console.log('LINE integration not found for caddy:', cid);
    return;
  }
  
  // 2. メッセージテンプレートを生成
  const message = generateMessage(messageType, data);
  
  // 3. LINE APIで送信
  await sendToLine(lineIntegration.line_user_id, message);
  
  // 4. 送信履歴を記録
  await supabase.from('line_notifications').insert({
    line_integration_id: lineIntegration.id,
    message_type: messageType,
    message_content: message,
    status: 'sent'
  });
}

// メッセージテンプレート
function generateMessage(type, data) {
  const templates = {
    'booking_confirmed': `🎉 キャディ依頼が確定しました！
📅 日時: ${data.date} ${data.time}
🏌️ ゴルフ場: ${data.golfCourseName}
👥 人数: ${data.playerCount}名
詳細はアプリでご確認ください。`,
    
    'booking_cancelled': `❌ キャディ依頼がキャンセルされました
📅 日時: ${data.date} ${data.time}
🏌️ ゴルフ場: ${data.golfCourseName}`,
    
    'reminder': `🔔 明日のキャディ依頼のリマインダーです
📅 明日 ${data.time}から
🏌️ ${data.golfCourseName}でお待ちしております！`
  };
  
  return templates[type] || 'キャディプラスからの通知です。';
}
```

## 🎯 実装フロー

### A. 会員登録時のLINE連携
1. 会員登録完了後、LINE連携の案内を表示
2. 「LINE通知を受け取る」ボタンで友達追加URLを開く
3. 紐付け用トークンを表示
4. ユーザーがLINEでトークンを送信
5. サーバーで紐付け処理を実行

### B. プロフィールからのLINE連携
1. プロフィール画面にLINE連携セクションを追加
2. 連携状況の表示（未連携/連携済み）
3. 連携または連携解除の操作

### C. 通知送信タイミング
1. キャディ依頼確定時
2. キャディ依頼キャンセル時
3. 前日のリマインダー
4. その他重要な更新

## 🔒 セキュリティ考慮事項

1. **トークンの有効期限**: 紐付け用トークンは短時間で期限切れ
2. **一意性の保証**: 1つのLINEアカウントは1つのキャディアカウントのみ
3. **連携解除機能**: ユーザーがいつでも連携を解除可能
4. **通知設定**: 通知タイプごとのON/OFF設定

## 📱 UI/UX設計

### LINE連携ボタンのデザイン
- LINEの公式カラー（#00B900）を使用
- 明確な「LINE友達追加」ボタン
- 連携後は「LINE通知設定」に変更

### 紐付け手順の案内
1. 友達追加完了の確認
2. トークン送信方法の説明
3. 連携完了の通知
