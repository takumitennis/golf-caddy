// LINE通知送信用 Cloudflare Functions
export async function onRequest(context) {
  const { request, env } = context;

  // CORSヘッダー
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
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
    // 環境変数の確認
    console.log('=== 環境変数確認 ===');
    console.log('LINE_CHANNEL_ACCESS_TOKEN:', env.LINE_CHANNEL_ACCESS_TOKEN ? '設定済み' : '未設定');
    console.log('SUPABASE_URL:', env.SUPABASE_URL ? '設定済み' : '未設定');
    console.log('SUPABASE_SERVICE_KEY:', env.SUPABASE_SERVICE_KEY ? '設定済み' : '未設定');
    
    if (!env.LINE_CHANNEL_ACCESS_TOKEN) {
      console.error('LINE_CHANNEL_ACCESS_TOKEN not set');
      return new Response('LINE configuration missing: LINE_CHANNEL_ACCESS_TOKEN not set', { 
        status: 500, 
        headers: corsHeaders 
      });
    }

    const body = await request.json();
    const { lineUserId, message } = body;

    console.log(`Sending LINE notification to: ${lineUserId}`);
    console.log(`Message: ${message}`);

    if (!lineUserId || !message) {
      return new Response('Missing lineUserId or message', { 
        status: 400, 
        headers: corsHeaders 
      });
    }

    // LINE通知を送信
    const response = await fetch('https://api.line.me/v2/bot/message/push', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${env.LINE_CHANNEL_ACCESS_TOKEN}`
      },
      body: JSON.stringify({
        to: lineUserId,
        messages: [{
          type: 'text',
          text: message
        }]
      })
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error('LINE API error:', response.status, errorText);
      return new Response(`LINE API error: ${response.status} - ${errorText}`, { 
        status: 500, 
        headers: corsHeaders 
      });
    }

    console.log('LINE notification sent successfully');

    // 通知履歴をデータベースに保存
    try {
      if (env.SUPABASE_URL && env.SUPABASE_SERVICE_KEY) {
        await fetch(`${env.SUPABASE_URL}/rest/v1/line_notifications`, {
          method: 'POST',
          headers: {
            'apikey': env.SUPABASE_SERVICE_KEY,
            'Authorization': `Bearer ${env.SUPABASE_SERVICE_KEY}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            line_integration_id: lineUserId, // 簡易的な対応
            message_type: 'booking_confirmation',
            message_content: message,
            sent_at: new Date().toISOString(),
            status: 'sent'
          })
        });
      }
    } catch (dbError) {
      console.error('Failed to save notification history:', dbError);
      // 通知履歴の保存失敗は致命的ではないので、ログのみ残す
    }

    return new Response('OK', { 
      status: 200, 
      headers: corsHeaders 
    });

  } catch (error) {
    console.error('Send LINE notification error:', error);
    return new Response('Internal Server Error', { 
      status: 500, 
      headers: corsHeaders 
    });
  }
}
