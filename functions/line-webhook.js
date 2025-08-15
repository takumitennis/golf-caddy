// Cloudflare Pages Functions用 LINE Webhook
// https://golf-caddy.pages.dev/line-webhook でアクセス可能

export async function onRequest(context) {
  const { request, env } = context;

  // CORSヘッダー
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type, x-line-signature',
    'Access-Control-Allow-Methods': 'POST, OPTIONS'
  };

  // OPTIONSリクエストの処理
  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  // POSTリクエストのみ処理
  if (request.method !== 'POST') {
    return new Response('Method Not Allowed', { 
      status: 405, 
      headers: corsHeaders 
    });
  }

  try {
    const signature = request.headers.get('x-line-signature');
    const body = await request.text();

    console.log('Received webhook request');

    // 署名検証
    if (!verifySignature(body, signature, env.LINE_CHANNEL_SECRET)) {
      console.error('Invalid signature');
      return new Response('Unauthorized', { 
        status: 401, 
        headers: corsHeaders 
      });
    }

    const data = JSON.parse(body);
    console.log('Webhook data:', data);

    // イベント処理
    for (const eventData of data.events || []) {
      await handleEvent(eventData, env);
    }

    return new Response('OK', { status: 200, headers: corsHeaders });

  } catch (error) {
    console.error('Webhook error:', error);
    return new Response('Internal Server Error', { 
      status: 500, 
      headers: corsHeaders 
    });
  }
}

// 署名検証
async function verifySignature(body, signature, channelSecret) {
  if (!channelSecret || !signature) {
    return false;
  }

  const encoder = new TextEncoder();
  const key = await crypto.subtle.importKey(
    'raw',
    encoder.encode(channelSecret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign']
  );

  const signatureBuffer = await crypto.subtle.sign(
    'HMAC',
    key,
    encoder.encode(body)
  );

  const hashArray = Array.from(new Uint8Array(signatureBuffer));
  const hashBase64 = btoa(String.fromCharCode.apply(null, hashArray));

  return signature === hashBase64;
}

// イベント処理
async function handleEvent(event, env) {
  try {
    switch (event.type) {
      case 'message':
        if (event.message.type === 'text') {
          await handleTextMessage(event, env);
        }
        break;
      case 'follow':
        await handleFollow(event, env);
        break;
      case 'unfollow':
        await handleUnfollow(event, env);
        break;
      default:
        console.log('Unknown event type:', event.type);
    }
  } catch (error) {
    console.error('Event handling error:', error);
  }
}

// テキストメッセージ処理
async function handleTextMessage(event, env) {
  const messageText = event.message.text;
  const lineUserId = event.source.userId;

  console.log(`Text message from ${lineUserId}: ${messageText}`);

  // トークンによる紐付け処理
  if (messageText.startsWith('LINK:')) {
    await handleAccountLinking(event, messageText, lineUserId, env);
  } else {
    // その他のメッセージへの対応
    await sendReplyMessage(event.replyToken, 
      'キャディプラスをご利用いただきありがとうございます！🎉\n\n' +
      'アカウント連携をご希望の場合は、アプリで表示される連携用トークンを送信してください。\n\n' +
      '例: LINK:abc123def456',
      env
    );
  }
}

// アカウント紐付け処理
async function handleAccountLinking(event, token, lineUserId, env) {
  try {
    console.log(`Attempting to link account with token: ${token}`);

    // Supabase クライアント初期化
    const supabaseResponse = await fetch(`${env.SUPABASE_URL}/rest/v1/line_link_tokens?token=eq.${token}&select=cid,expires_at,used_at`, {
      headers: {
        'apikey': env.SUPABASE_SERVICE_KEY,
        'Authorization': `Bearer ${env.SUPABASE_SERVICE_KEY}`,
        'Content-Type': 'application/json'
      }
    });

    const tokenData = await supabaseResponse.json();

    if (!tokenData || tokenData.length === 0) {
      console.error('Token not found');
      await sendReplyMessage(event.replyToken, 
        '❌ 無効なトークンです。\nアプリで新しいトークンを取得してください。',
        env
      );
      return;
    }

    const token_info = tokenData[0];

    // 既に使用済みかチェック
    if (token_info.used_at) {
      await sendReplyMessage(event.replyToken, 
        '⚠️ このトークンは既に使用済みです。\nアプリで新しいトークンを取得してください。',
        env
      );
      return;
    }

    // 有効期限チェック
    if (new Date() > new Date(token_info.expires_at)) {
      await sendReplyMessage(event.replyToken, 
        '⏰ トークンの有効期限が切れています。\nアプリで新しいトークンを取得してください。',
        env
      );
      return;
    }

    // LINE連携情報を保存
    const integrationResponse = await fetch(`${env.SUPABASE_URL}/rest/v1/line_integrations`, {
      method: 'POST',
      headers: {
        'apikey': env.SUPABASE_SERVICE_KEY,
        'Authorization': `Bearer ${env.SUPABASE_SERVICE_KEY}`,
        'Content-Type': 'application/json',
        'Prefer': 'resolution=merge-duplicates'
      },
      body: JSON.stringify({
        cid: token_info.cid,
        line_user_id: lineUserId,
        is_active: true,
        linked_at: new Date().toISOString()
      })
    });

    if (!integrationResponse.ok) {
      throw new Error('Integration save failed');
    }

    // トークンを使用済みにマーク
    await fetch(`${env.SUPABASE_URL}/rest/v1/line_link_tokens?token=eq.${token}`, {
      method: 'PATCH',
      headers: {
        'apikey': env.SUPABASE_SERVICE_KEY,
        'Authorization': `Bearer ${env.SUPABASE_SERVICE_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        used_at: new Date().toISOString()
      })
    });

    console.log(`Account linked successfully: CID ${token_info.cid} ↔ LINE ${lineUserId}`);

    // 成功メッセージを送信
    await sendReplyMessage(event.replyToken, 
      '✅ アカウント連携が完了しました！\n\n' +
      '今後、以下の通知をLINEでお受け取りいただけます：\n' +
      '🎯 キャディ依頼の確定\n' +
      '📅 予約のリマインダー\n' +
      '❌ キャンセルの通知\n\n' +
      'キャディプラスをよろしくお願いします！',
      env
    );

  } catch (error) {
    console.error('Account linking error:', error);
    await sendReplyMessage(event.replyToken, 
      '❌ 連携処理中にエラーが発生しました。\n少し時間をおいて再度お試しください。',
      env
    );
  }
}

// 友達追加時の処理
async function handleFollow(event, env) {
  const lineUserId = event.source.userId;
  console.log(`New follower: ${lineUserId}`);

  await sendReplyMessage(event.replyToken, 
    '🎉 キャディプラス公式LINEにご登録いただき、ありがとうございます！\n\n' +
    '📱 アカウント連携をするには：\n' +
    '1. キャディプラスアプリにログイン\n' +
    '2. LINE設定画面を開く\n' +
    '3. 表示されるトークンをこちらに送信\n\n' +
    '連携完了後、重要な通知をお送りします！',
    env
  );
}

// フォロー解除時の処理
async function handleUnfollow(event, env) {
  const lineUserId = event.source.userId;
  console.log(`User unfollowed: ${lineUserId}`);

  try {
    // 連携を無効化
    await fetch(`${env.SUPABASE_URL}/rest/v1/line_integrations?line_user_id=eq.${lineUserId}`, {
      method: 'PATCH',
      headers: {
        'apikey': env.SUPABASE_SERVICE_KEY,
        'Authorization': `Bearer ${env.SUPABASE_SERVICE_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        is_active: false
      })
    });
  } catch (error) {
    console.error('Unfollow handling error:', error);
  }
}

// 返信メッセージ送信
async function sendReplyMessage(replyToken, messageText, env) {
  if (!env.LINE_CHANNEL_ACCESS_TOKEN) {
    console.error('LINE_CHANNEL_ACCESS_TOKEN not set');
    return;
  }

  try {
    const response = await fetch('https://api.line.me/v2/bot/message/reply', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${env.LINE_CHANNEL_ACCESS_TOKEN}`
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
