export async function onRequestPost(context) {
  try {
    console.log('お問い合わせフォーム処理開始');
    
    // 環境変数の確認
    const envVars = {
      RESEND_API_KEY: context.env.RESEND_API_KEY ? '設定済み' : '未設定',
      hasEnv: !!context.env
    };
    
    console.log('環境変数確認:', envVars);
    
    const { request } = context;
    const formData = await request.json();
    
    console.log('受信したフォームデータ:', formData);
    
    const { clubName, contactName, contactEmail, contactMessage } = formData;
    
    // 必須項目のバリデーション
    if (!clubName || !contactName || !contactEmail) {
      console.error('必須項目が不足:', { clubName, contactName, contactEmail });
      return new Response(JSON.stringify({ 
        error: '必須項目が入力されていません' 
      }), { 
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    // 一時的にメール送信をスキップしてテスト
    console.log('メール送信処理をスキップ（テスト中）');
    
    // 成功レスポンス
    return new Response(JSON.stringify({ 
      success: true,
      message: 'お問い合わせを受け付けました。ありがとうございます。（テスト中：メール送信は無効）',
      envVars: envVars
    }), { 
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    });
    
  } catch (error) {
    console.error('お問い合わせフォーム処理エラー:', error);
    
    return new Response(JSON.stringify({ 
      error: 'サーバーエラーが発生しました: ' + error.message,
      stack: error.stack
    }), { 
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}
