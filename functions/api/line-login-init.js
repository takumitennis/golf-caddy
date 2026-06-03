// LINE Login 開始エンドポイント
// GET /api/line-login-init
//
// 役割:
//   1. CSRF 対策の state (random UUID) と nonce を発行
//   2. state を HttpOnly cookie で保持（callback で照合）
//   3. LINE の authorize URL を組み立てて JSON で返す
//
// 必要な環境変数:
//   - LINE_LOGIN_CHANNEL_ID
//   - SITE_ORIGIN（例: https://caddygate.pages.dev）— 省略時は request.url の origin を採用

export async function onRequest(context) {
  const { request, env } = context;

  const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Allow-Methods": "GET, OPTIONS"
  };

  if (request.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }
  if (request.method !== "GET") {
    return new Response("Method Not Allowed", { status: 405, headers: corsHeaders });
  }

  try {
    if (!env.LINE_LOGIN_CHANNEL_ID) {
      return new Response(
        JSON.stringify({ error: "LINE_LOGIN_CHANNEL_ID not set" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const url = new URL(request.url);
    const siteOrigin = env.SITE_ORIGIN || `${url.protocol}//${url.host}`;
    const redirectUri = `${siteOrigin}/api/line-login-callback`;

    const state = crypto.randomUUID();
    const nonce = crypto.randomUUID();

    const authorizeUrl = new URL("https://access.line.me/oauth2/v2.1/authorize");
    authorizeUrl.searchParams.set("response_type", "code");
    authorizeUrl.searchParams.set("client_id", env.LINE_LOGIN_CHANNEL_ID);
    authorizeUrl.searchParams.set("redirect_uri", redirectUri);
    authorizeUrl.searchParams.set("state", state);
    authorizeUrl.searchParams.set("scope", "openid profile");
    authorizeUrl.searchParams.set("nonce", nonce);

    // state を HttpOnly cookie で保持（callback で照合する）
    // SameSite=Lax: LINE → 自サイトへの top-level redirect は通る
    const cookie = [
      `line_login_state=${state}`,
      "Path=/",
      "HttpOnly",
      "Secure",
      "SameSite=Lax",
      "Max-Age=600"
    ].join("; ");

    return new Response(
      JSON.stringify({
        authorize_url: authorizeUrl.toString(),
        state: state
      }),
      {
        status: 200,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
          "Set-Cookie": cookie
        }
      }
    );
  } catch (err) {
    console.error("[line-login-init] error:", err);
    return new Response(
      JSON.stringify({ error: err.message || String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
}
