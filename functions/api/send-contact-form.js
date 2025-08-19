export async function onRequestPost(context) {
  try {
    const { request } = context;
    const formData = await request.json();
    
    const { clubName, contactName, contactEmail, contactMessage } = formData;
    
    // 必須項目のバリデーション
    if (!clubName || !contactName || !contactEmail) {
      return new Response(JSON.stringify({ 
        error: '必須項目が入力されていません' 
      }), { 
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    // メール送信処理
    const emailContent = `
ゴルフ部/サークルからのお問い合わせ

ゴルフ部/サークル名: ${clubName}
担当者名: ${contactName}
メールアドレス: ${contactEmail}

お問い合わせ内容:
${contactMessage}

---
このメールはキャディプラスのお問い合わせフォームから送信されました。
    `;
    
    // Resendを使用してメール送信
    const RESEND_API_KEY = context.env.RESEND_API_KEY;
    
    if (!RESEND_API_KEY) {
      console.error('RESEND_API_KEYが設定されていません');
      return new Response(JSON.stringify({ 
        error: 'メール送信の設定が完了していません。しばらく時間をおいて再度お試しください。' 
      }), { 
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    try {
      const emailResponse = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${RESEND_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          from: 'noreply@golf-caddy.pages.dev',
          to: 'caddytas@gmail.com',
          subject: `ゴルフ部/サークルからのお問い合わせ: ${clubName}`,
          text: emailContent,
          html: emailContent.replace(/\n/g, '<br>')
        }),
      });
      
      if (!emailResponse.ok) {
        const errorData = await emailResponse.json();
        console.error('Resend API エラー:', errorData);
        throw new Error(`メール送信に失敗しました: ${errorData.message || 'Unknown error'}`);
      }
      
      const emailResult = await emailResponse.json();
      console.log('メール送信成功:', emailResult);
      
    } catch (emailError) {
      console.error('メール送信エラー:', emailError);
      return new Response(JSON.stringify({ 
        error: 'メールの送信に失敗しました。しばらく時間をおいて再度お試しください。' 
      }), { 
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    // 成功レスポンス
    return new Response(JSON.stringify({ 
      success: true,
      message: 'お問い合わせを受け付けました。ありがとうございます。'
    }), { 
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    });
    
  } catch (error) {
    console.error('お問い合わせフォーム処理エラー:', error);
    
    return new Response(JSON.stringify({ 
      error: 'サーバーエラーが発生しました。しばらく時間をおいて再度お試しください。' 
    }), { 
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}
