// LINE Login コールバックエンドポイント
// GET /api/line-login-callback?code=...&state=...
//
// 役割:
//   1. cookie の state と URL の state を照合（CSRF 対策）
//   2. LINE token endpoint に code を渡して access_token + id_token を取得
//   3. id_token から sub (LINE userId), name, picture を取り出す
//   4. Supabase admin API で user を upsert（email = line_{userId}@caddygate.local）
//   5. line_integrations に upsert（cid は後で profile.html で発行されるので、ここでは line_user_id のみ）
//   6. Supabase admin generate_link (magiclink) で one-time token を発行
//   7. HTML を返して frontend で verifyOtp → セッション確立 → dashboard.html?role=caddy に遷移
//
// 必要な環境変数:
//   - LINE_LOGIN_CHANNEL_ID
//   - LINE_LOGIN_CHANNEL_SECRET
//   - SUPABASE_URL
//   - SUPABASE_SERVICE_KEY        ← 既存 send-line-notification.js と共通
//   - SUPABASE_ANON_KEY           ← frontend に渡すための公開 key（埋め込み）
//   - SITE_ORIGIN（省略時は request.url の origin）

export async function onRequest(context) {
  const { request, env } = context;

  if (request.method !== "GET") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  const url = new URL(request.url);
  const code = url.searchParams.get("code");
  const stateFromUrl = url.searchParams.get("state");
  const errorParam = url.searchParams.get("error");
  const errorDesc = url.searchParams.get("error_description");

  const siteOrigin = env.SITE_ORIGIN || `${url.protocol}//${url.host}`;

  // 1. cookie からの state 取り出し
  const cookieHeader = request.headers.get("Cookie") || "";
  const stateCookie = cookieHeader.split(";").map(s => s.trim())
    .find(s => s.startsWith("line_login_state="));
  const stateFromCookie = stateCookie ? stateCookie.split("=")[1] : null;

  try {
    // 必須環境変数チェック
    const missingEnv = [];
    if (!env.LINE_LOGIN_CHANNEL_ID) missingEnv.push("LINE_LOGIN_CHANNEL_ID");
    if (!env.LINE_LOGIN_CHANNEL_SECRET) missingEnv.push("LINE_LOGIN_CHANNEL_SECRET");
    if (!env.SUPABASE_URL) missingEnv.push("SUPABASE_URL");
    if (!env.SUPABASE_SERVICE_KEY) missingEnv.push("SUPABASE_SERVICE_KEY");
    if (!env.SUPABASE_ANON_KEY) missingEnv.push("SUPABASE_ANON_KEY");
    if (missingEnv.length > 0) {
      return errorHtml(`サーバー設定エラー: 以下の環境変数が未設定です: ${missingEnv.join(", ")}`, siteOrigin);
    }

    // 2. LINE 側の error 応答チェック
    if (errorParam) {
      return errorHtml(`LINE 認可エラー: ${errorParam} - ${errorDesc || ""}`, siteOrigin);
    }
    if (!code || !stateFromUrl) {
      return errorHtml("code または state が見つかりません", siteOrigin);
    }

    // 3. state 検証
    if (!stateFromCookie || stateFromCookie !== stateFromUrl) {
      return errorHtml("state 不一致 (CSRF 検証失敗)。最初からやり直してください。", siteOrigin);
    }

    // 4. LINE token endpoint で code → access_token + id_token
    const redirectUri = `${siteOrigin}/api/line-login-callback`;
    const tokenBody = new URLSearchParams({
      grant_type: "authorization_code",
      code: code,
      redirect_uri: redirectUri,
      client_id: env.LINE_LOGIN_CHANNEL_ID,
      client_secret: env.LINE_LOGIN_CHANNEL_SECRET
    });

    const tokenRes = await fetch("https://api.line.me/oauth2/v2.1/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: tokenBody.toString()
    });

    if (!tokenRes.ok) {
      const errText = await tokenRes.text();
      console.error("[line-login-callback] token exchange failed:", tokenRes.status, errText);
      return errorHtml(`LINE トークン取得失敗 (${tokenRes.status}): ${errText}`, siteOrigin);
    }

    const tokenData = await tokenRes.json();
    const idToken = tokenData.id_token;
    if (!idToken) {
      return errorHtml("id_token が LINE から返ってきませんでした。scope=openid が必要です。", siteOrigin);
    }

    // 5. id_token デコード（簡易: 署名検証は省略。LINE channel_secret で HS256 検証も可）
    //    ※ 本番では LINE の JWKS / verify エンドポイントで verify が望ましい
    const claims = decodeJwtPayload(idToken);
    const lineUserId = claims.sub;
    const displayName = claims.name || "";
    const picture = claims.picture || "";
    const lineEmail = claims.email || null;  // scope=email を申請してる時のみ
    if (!lineUserId) {
      return errorHtml("LINE userId が取得できませんでした", siteOrigin);
    }

    // 6. Supabase user の email を決定
    //    - LINE が email を返してくれば優先（scope=email 申請済みの場合）
    //    - なければ line_{userId}@caddygate.local
    const supabaseEmail = lineEmail || `line_${lineUserId}@caddygate.local`;

    // 7. Supabase admin で user upsert
    //    まず email で既存 user を検索
    const existingUser = await findUserByEmail(env, supabaseEmail);
    let userId;
    if (existingUser) {
      userId = existingUser.id;
      // user_metadata 更新（role と line_user_id を確実にセット）
      await updateUserMetadata(env, userId, {
        role: "caddy",
        line_user_id: lineUserId,
        name: displayName,
        picture: picture,
        provider: "line"
      });
    } else {
      const created = await createUser(env, {
        email: supabaseEmail,
        email_confirm: true,
        user_metadata: {
          role: "caddy",
          line_user_id: lineUserId,
          name: displayName,
          picture: picture,
          provider: "line"
        }
      });
      userId = created.id;
    }

    // 8. line_integrations に upsert (cid は後で profile.html で発行されるので暫定値 null)
    //    既存 row があれば是非更新、なければ作る。
    //    既存仕様(cid 主キー)が崩れないよう、ここでは line_user_id をキーに check して insert する
    await upsertLineIntegration(env, lineUserId, userId);

    // 9. magic link で one-time hashed_token を発行 → frontend で verifyOtp
    const otpRes = await fetch(`${env.SUPABASE_URL}/auth/v1/admin/generate_link`, {
      method: "POST",
      headers: {
        "apikey": env.SUPABASE_SERVICE_KEY,
        "Authorization": `Bearer ${env.SUPABASE_SERVICE_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        type: "magiclink",
        email: supabaseEmail
      })
    });
    if (!otpRes.ok) {
      const errText = await otpRes.text();
      console.error("[line-login-callback] generate_link failed:", otpRes.status, errText);
      return errorHtml(`Supabase magic link 発行失敗: ${errText}`, siteOrigin);
    }
    const otpData = await otpRes.json();
    // generate_link の戻り値は properties.hashed_token / properties.email_otp / properties.action_link
    const hashedToken = otpData?.properties?.hashed_token || otpData?.hashed_token;
    if (!hashedToken) {
      return errorHtml("hashed_token を取得できませんでした", siteOrigin);
    }

    // 10. HTML を返して frontend で verifyOtp → セッション確立 → dashboard.html?role=caddy へ
    return successHtml({
      siteOrigin,
      supabaseUrl: env.SUPABASE_URL,
      supabaseAnonKey: env.SUPABASE_ANON_KEY,
      email: supabaseEmail,
      tokenHash: hashedToken
    });

  } catch (err) {
    console.error("[line-login-callback] fatal:", err);
    return errorHtml(`内部エラー: ${err.message || String(err)}`, siteOrigin);
  }
}

// ───────────────────────────────────────────────────────────
//  ヘルパー
// ───────────────────────────────────────────────────────────

function decodeJwtPayload(jwt) {
  const parts = jwt.split(".");
  if (parts.length < 2) throw new Error("invalid jwt format");
  const payload = parts[1];
  // base64url → base64
  const b64 = payload.replace(/-/g, "+").replace(/_/g, "/")
    .padEnd(payload.length + (4 - payload.length % 4) % 4, "=");
  const json = atob(b64);
  return JSON.parse(decodeURIComponent(escape(json)));
}

async function findUserByEmail(env, email) {
  // Supabase admin: GET /auth/v1/admin/users?email=...
  const res = await fetch(
    `${env.SUPABASE_URL}/auth/v1/admin/users?email=${encodeURIComponent(email)}`,
    {
      headers: {
        "apikey": env.SUPABASE_SERVICE_KEY,
        "Authorization": `Bearer ${env.SUPABASE_SERVICE_KEY}`
      }
    }
  );
  if (!res.ok) {
    console.warn("[findUserByEmail] not ok:", res.status);
    return null;
  }
  const data = await res.json();
  // 環境によって data.users[] か data[] のどちらかで返る
  const users = data.users || (Array.isArray(data) ? data : []);
  return users.find(u => u.email && u.email.toLowerCase() === email.toLowerCase()) || null;
}

async function createUser(env, payload) {
  const res = await fetch(`${env.SUPABASE_URL}/auth/v1/admin/users`, {
    method: "POST",
    headers: {
      "apikey": env.SUPABASE_SERVICE_KEY,
      "Authorization": `Bearer ${env.SUPABASE_SERVICE_KEY}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });
  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`createUser failed: ${res.status} ${errText}`);
  }
  return await res.json();
}

async function updateUserMetadata(env, userId, metadata) {
  const res = await fetch(`${env.SUPABASE_URL}/auth/v1/admin/users/${userId}`, {
    method: "PUT",
    headers: {
      "apikey": env.SUPABASE_SERVICE_KEY,
      "Authorization": `Bearer ${env.SUPABASE_SERVICE_KEY}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ user_metadata: metadata })
  });
  if (!res.ok) {
    const errText = await res.text();
    console.error("[updateUserMetadata] failed:", res.status, errText);
  }
}

async function upsertLineIntegration(env, lineUserId, supabaseUserId) {
  // line_integrations は cid を PK としている既存スキーマ。
  // LINE Login 直後は profile.html での cid 発行前なので、
  //   - 既に当該 line_user_id の row があれば is_active=true で更新
  //   - 無い場合は cid = "auth_" + supabaseUserId.slice(0,8) を暫定 PK にして作成
  //     （後で profile.html で cid を再発行した時点で migration できるよう、
  //      別途 line_login_user_links みたいなテーブルを用意する方が clean だが
  //      ここでは追加スキーマを増やさず暫定的に line_integrations を流用）
  try {
    const existingRes = await fetch(
      `${env.SUPABASE_URL}/rest/v1/line_integrations?line_user_id=eq.${encodeURIComponent(lineUserId)}&select=cid,is_active`,
      {
        headers: {
          "apikey": env.SUPABASE_SERVICE_KEY,
          "Authorization": `Bearer ${env.SUPABASE_SERVICE_KEY}`
        }
      }
    );
    const existing = await existingRes.json();
    if (existing && existing.length > 0) {
      // 既存 row → is_active 更新
      await fetch(
        `${env.SUPABASE_URL}/rest/v1/line_integrations?line_user_id=eq.${encodeURIComponent(lineUserId)}`,
        {
          method: "PATCH",
          headers: {
            "apikey": env.SUPABASE_SERVICE_KEY,
            "Authorization": `Bearer ${env.SUPABASE_SERVICE_KEY}`,
            "Content-Type": "application/json"
          },
          body: JSON.stringify({
            is_active: true,
            linked_at: new Date().toISOString()
          })
        }
      );
    } else {
      // 新規 row。cid は暫定値（後で profile.html 側で正規 cid を発行）
      const tempCid = "auth_" + supabaseUserId.slice(0, 8);
      await fetch(`${env.SUPABASE_URL}/rest/v1/line_integrations`, {
        method: "POST",
        headers: {
          "apikey": env.SUPABASE_SERVICE_KEY,
          "Authorization": `Bearer ${env.SUPABASE_SERVICE_KEY}`,
          "Content-Type": "application/json",
          "Prefer": "resolution=merge-duplicates"
        },
        body: JSON.stringify({
          cid: tempCid,
          line_user_id: lineUserId,
          is_active: true,
          linked_at: new Date().toISOString()
        })
      });
    }
  } catch (err) {
    console.error("[upsertLineIntegration] error:", err);
    // 連携失敗は致命的ではないので続行
  }
}

function successHtml({ siteOrigin, supabaseUrl, supabaseAnonKey, email, tokenHash }) {
  // frontend で supabase.auth.verifyOtp を呼んでセッション確立後、
  // /dashboard.html?role=caddy へ遷移する HTML を返す
  const html = `<!DOCTYPE html>
<html lang="ja"><head>
<meta charset="UTF-8" />
<title>LINE ログイン処理中…</title>
<style>
  body { font-family: 'Segoe UI', sans-serif; background: #F5F0E6; color: #1A1A1A;
         display:flex; justify-content:center; align-items:center; min-height: 100vh; margin: 0; }
  .box { background:#fff; border:1px solid #E8E2D5; border-radius:8px; padding:32px 40px;
         text-align:center; min-width:280px; }
  .msg { font-size: 14px; color: #5C5C5C; }
  .err { color: #B83A2E; margin-top: 12px; font-size: 13px; }
</style>
</head><body>
<div class="box">
  <p class="msg" id="msg">LINE ログイン処理中…</p>
  <p class="err" id="err"></p>
</div>
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4/dist/umd/supabase.js"></script>
<script>
(async () => {
  try {
    const sb = window.supabase.createClient(${JSON.stringify(supabaseUrl)}, ${JSON.stringify(supabaseAnonKey)});
    // Supabase v2 仕様: token_hash を渡す時は email を含めてはいけない
    const { data, error } = await sb.auth.verifyOtp({
      token_hash: ${JSON.stringify(tokenHash)},
      type: "magiclink"
    });
    if (error) {
      document.getElementById("msg").textContent = "セッション確立に失敗しました";
      document.getElementById("err").textContent = error.message;
      console.error(error);
      return;
    }
    // state cookie をクリア
    document.cookie = "line_login_state=; Path=/; Max-Age=0";
    location.href = ${JSON.stringify(siteOrigin + "/dashboard.html?role=caddy")};
  } catch (e) {
    document.getElementById("msg").textContent = "エラーが発生しました";
    document.getElementById("err").textContent = e.message || String(e);
    console.error(e);
  }
})();
</script>
</body></html>`;
  return new Response(html, {
    status: 200,
    headers: {
      "Content-Type": "text/html; charset=utf-8",
      // state cookie はもう不要
      "Set-Cookie": "line_login_state=; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=0"
    }
  });
}

function errorHtml(message, siteOrigin) {
  const safeMessage = String(message).replace(/</g, "&lt;").replace(/>/g, "&gt;");
  const safeOrigin = siteOrigin || "/";
  const html = `<!DOCTYPE html>
<html lang="ja"><head>
<meta charset="UTF-8" />
<title>LINE ログインエラー</title>
<style>
  body { font-family: 'Segoe UI', sans-serif; background: #F5F0E6; color: #1A1A1A;
         display:flex; justify-content:center; align-items:center; min-height: 100vh; margin: 0; }
  .box { background:#fff; border:1px solid #E8E2D5; border-radius:8px; padding:32px 40px;
         max-width: 460px; }
  h2 { margin: 0 0 12px; font-size: 18px; color: #B83A2E; }
  p { font-size: 14px; color: #5C5C5C; line-height: 1.6; margin: 0 0 16px; }
  a { color: #2f8f2f; font-weight: 600; text-decoration: none; }
  a:hover { text-decoration: underline; }
</style>
</head><body>
<div class="box">
  <h2>LINE ログインエラー</h2>
  <p>${safeMessage}</p>
  <p><a href="${safeOrigin}/login/?role=caddy">ログイン画面に戻る</a></p>
</div>
</body></html>`;
  return new Response(html, {
    status: 400,
    headers: {
      "Content-Type": "text/html; charset=utf-8",
      "Set-Cookie": "line_login_state=; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=0"
    }
  });
}
