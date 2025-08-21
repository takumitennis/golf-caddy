export async function onRequestPost(context) {
  try {
    console.log('=== デバッグFunction開始 ===');
    
    // 基本的な情報をログ出力
    console.log('リクエスト受信時刻:', new Date().toISOString());
    console.log('環境変数の存在確認:', {
      hasEnv: !!context.env,
      envKeys: context.env ? Object.keys(context.env) : 'なし'
    });
    
    // リクエストデータの確認
    const { request } = context;
    console.log('リクエストメソッド:', request.method);
    console.log('リクエストURL:', request.url);
    
    // フォームデータの確認
    try {
      const formData = await request.json();
      console.log('受信したフォームデータ:', formData);
      
      // 成功レスポンス
      return new Response(JSON.stringify({ 
        success: true,
        message: 'デバッグFunctionが正常に動作しています',
        receivedData: formData,
        timestamp: new Date().toISOString()
      }), { 
        status: 200,
        headers: { 'Content-Type': 'application/json' }
      });
      
    } catch (parseError) {
      console.error('JSONパースエラー:', parseError);
      return new Response(JSON.stringify({ 
        error: 'JSONパースエラー: ' + parseError.message
      }), { 
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
  } catch (error) {
    console.error('=== デバッグFunctionエラー ===');
    console.error('エラータイプ:', error.constructor.name);
    console.error('エラーメッセージ:', error.message);
    console.error('エラースタック:', error.stack);
    
    return new Response(JSON.stringify({ 
      error: 'デバッグFunctionでエラーが発生: ' + error.message,
      errorType: error.constructor.name,
      timestamp: new Date().toISOString()
    }), { 
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}
