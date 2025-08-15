const crypto = require('crypto');

// Supabase設定
const { createClient } = require('@supabase/supabase-js');
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

// LINE API設定
const LINE_CHANNEL_ACCESS_TOKEN = process.env.LINE_CHANNEL_ACCESS_TOKEN;
const LINE_CHANNEL_SECRET = process.env.LINE_CHANNEL_SECRET;

exports.handler = async (event, context) => {
  // CORSヘッダー
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type, x-line-signature',
    'Access-Control-Allow-Methods': 'POST, OPTIONS'
  };

  // OPTIONSリクエストの処理
  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 200, headers, body: '' };
  }

  // POSTリクエストのみ処理
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, headers, body: 'Method Not Allowed' };
  }

  try {
    const signature = event.headers['x-line-signature'];
    const body = event.body;

    // 署名検証
    if (!verifySignature(body, signature)) {
      console.error('Invalid signature');
      return { statusCode: 401, headers, body: 'Unauthorized' };
    }

    const data = JSON.parse(body);
    console.log('Received webhook:', JSON.stringify(data, null, 2));

    // イベント処理
    for (const eventData of data.events || []) {
      await handleEvent(eventData);
    }

    return { statusCode: 200, headers, body: 'OK' };

  } catch (error) {
    console.error('Webhook error:', error);
    return { statusCode: 500, headers, body: 'Internal Server Error' };
  }
};

// 署名検証
function verifySignature(body, signature) {
  if (!LINE_CHANNEL_SECRET || !signature) {
    return false;
  }

  const hash = crypto
    .createHmac('sha256', LINE_CHANNEL_SECRET)
    .update(body)
    .digest('base64');

  return signature === hash;
}

// イベント処理
async function handleEvent(event) {
  try {
    switch (event.type) {
      case 'message':
        if (event.message.type === 'text') {
          await handleTextMessage(event);
        }
        break;
      case 'follow':
        await handleFollow(event);
        break;
      case 'unfollow':
        await handleUnfollow(event);
        break;
      default:
        console.log('Unknown event type:', event.type);
    }
  } catch (error) {
    console.error('Event handling error:', error);
  }
}

// テキストメッセージ処理
async function handleTextMessage(event) {
  const messageText = event.message.text;
  const lineUserId = event.source.userId;

  console.log(`Text message from ${lineUserId}: ${messageText}`);

  // トークンによる紐付け処理
  if (messageText.startsWith('LINK:')) {
    await handleAccountLinking(event, messageText, lineUserId);
  } else {
    // その他のメッセージへの対応
    await sendReplyMessage(event.replyToken, 
      'キャディプラスをご利用いただきありがとうございます！🎉\n\n' +
      'アカウント連携をご希望の場合は、アプリで表示される連携用トークンを送信してください。\n\n' +
      '例: LINK:abc123def456'
    );
  }
}

// アカウント紐付け処理
async function handleAccountLinking(event, token, lineUserId) {
  try {
    console.log(`Attempting to link account with token: ${token}`);

    // 1. トークンの確認
    const { data: tokenData, error: tokenError } = await supabase
      .from('line_link_tokens')
      .select('cid, expires_at, used_at')
      .eq('token', token)
      .single();

    if (tokenError || !tokenData) {
      console.error('Token not found:', tokenError);
      await sendReplyMessage(event.replyToken, 
        '❌ 無効なトークンです。\nアプリで新しいトークンを取得してください。'
      );
      return;
    }

    // 2. 既に使用済みかチェック
    if (tokenData.used_at) {
      await sendReplyMessage(event.replyToken, 
        '⚠️ このトークンは既に使用済みです。\nアプリで新しいトークンを取得してください。'
      );
      return;
    }

    // 3. 有効期限チェック
    if (new Date() > new Date(tokenData.expires_at)) {
      await sendReplyMessage(event.replyToken, 
        '⏰ トークンの有効期限が切れています。\nアプリで新しいトークンを取得してください。'
      );
      return;
    }

    // 4. 既存の連携をチェック
    const { data: existingLink } = await supabase
      .from('line_integrations')
      .select('id')
      .eq('cid', tokenData.cid)
      .eq('is_active', true)
      .single();

    if (existingLink) {
      // 既存の連携を更新
      await supabase
        .from('line_integrations')
        .update({
          line_user_id: lineUserId,
          linked_at: new Date().toISOString()
        })
        .eq('id', existingLink.id);
    } else {
      // 新規連携を作成
      await supabase
        .from('line_integrations')
        .insert({
          cid: tokenData.cid,
          line_user_id: lineUserId,
          is_active: true,
          linked_at: new Date().toISOString()
        });
    }

    // 5. トークンを使用済みにマーク
    await supabase
      .from('line_link_tokens')
      .update({ used_at: new Date().toISOString() })
      .eq('token', token);

    console.log(`Account linked successfully: CID ${tokenData.cid} ↔ LINE ${lineUserId}`);

    // 6. 成功メッセージを送信
    await sendReplyMessage(event.replyToken, 
      '✅ アカウント連携が完了しました！\n\n' +
      '今後、以下の通知をLINEでお受け取りいただけます：\n' +
      '🎯 キャディ依頼の確定\n' +
      '📅 予約のリマインダー\n' +
      '❌ キャンセルの通知\n\n' +
      'キャディプラスをよろしくお願いします！'
    );

  } catch (error) {
    console.error('Account linking error:', error);
    await sendReplyMessage(event.replyToken, 
      '❌ 連携処理中にエラーが発生しました。\n少し時間をおいて再度お試しください。'
    );
  }
}

// 友達追加時の処理
async function handleFollow(event) {
  const lineUserId = event.source.userId;
  console.log(`New follower: ${lineUserId}`);

  await sendReplyMessage(event.replyToken, 
    '🎉 キャディプラス公式LINEにご登録いただき、ありがとうございます！\n\n' +
    '📱 アカウント連携をするには：\n' +
    '1. キャディプラスアプリにログイン\n' +
    '2. LINE設定画面を開く\n' +
    '3. 表示されるトークンをこちらに送信\n\n' +
    '連携完了後、重要な通知をお送りします！'
  );
}

// フォロー解除時の処理
async function handleUnfollow(event) {
  const lineUserId = event.source.userId;
  console.log(`User unfollowed: ${lineUserId}`);

  // 連携を無効化
  try {
    await supabase
      .from('line_integrations')
      .update({ is_active: false })
      .eq('line_user_id', lineUserId);
  } catch (error) {
    console.error('Unfollow handling error:', error);
  }
}

// 返信メッセージ送信
async function sendReplyMessage(replyToken, messageText) {
  if (!LINE_CHANNEL_ACCESS_TOKEN) {
    console.error('LINE_CHANNEL_ACCESS_TOKEN not set');
    return;
  }

  try {
    const response = await fetch('https://api.line.me/v2/bot/message/reply', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${LINE_CHANNEL_ACCESS_TOKEN}`
      },
      body: JSON.stringify({
        replyToken: replyToken,
        messages: [{
          type: 'text',
          text: messageText
        }]
      })
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error('LINE API error:', response.status, errorText);
    } else {
      console.log('Reply message sent successfully');
    }
  } catch (error) {
    console.error('Send reply message error:', error);
  }
}

// プッシュメッセージ送信（通知用）
async function sendPushMessage(lineUserId, messageText) {
  if (!LINE_CHANNEL_ACCESS_TOKEN) {
    console.error('LINE_CHANNEL_ACCESS_TOKEN not set');
    return;
  }

  try {
    const response = await fetch('https://api.line.me/v2/bot/message/push', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${LINE_CHANNEL_ACCESS_TOKEN}`
      },
      body: JSON.stringify({
        to: lineUserId,
        messages: [{
          type: 'text',
          text: messageText
        }]
      })
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error('LINE Push API error:', response.status, errorText);
      throw new Error(`LINE API error: ${response.status}`);
    } else {
      console.log('Push message sent successfully');
    }
  } catch (error) {
    console.error('Send push message error:', error);
    throw error;
  }
}

// 通知送信用の関数（他の関数から呼び出し可能）
exports.sendLineNotification = sendPushMessage;
