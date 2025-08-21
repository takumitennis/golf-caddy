export async function onRequestPost(context) {
  try {
    console.log('テストFunction開始');
    
    // 環境変数の確認
    const envVars = {
      RESEND_API_KEY: context.env.RESEND_API_KEY ? '設定済み' : '未設定',
      hasEnv: !!context.env
    };
    
    console.log('環境変数確認:', envVars);
    
    // 成功レスポンス
    return new Response(JSON.stringify({ 
      success: true,
      message: 'テストFunctionが正常に動作しています',
      envVars: envVars
    }), { 
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    });
    
  } catch (error) {
    console.error('テストFunctionエラー:', error);
    
    return new Response(JSON.stringify({ 
      error: 'テストFunctionでエラーが発生: ' + error.message,
      stack: error.stack
    }), { 
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}
