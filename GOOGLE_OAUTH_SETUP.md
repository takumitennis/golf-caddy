# Google OAuth セットアップ手順（ゴルフ場側）

このドキュメントは「ゴルフ場担当者が Google ボタン一発でログイン／新規登録できる」機能を有効化するための手順書です。
LINE Login と違い、Supabase Auth が Google OAuth を **ネイティブ対応** しているので、Cloudflare 側の Functions は不要です。

---

## 全体像

```
caddytas (Cloudflare Pages)
   └ login/index.html  ─── [Google で続ける] ボタン
                              ↓
              supabase.auth.signInWithOAuth({ provider: "google" })
                              ↓
                Google 同意画面（accounts.google.com）
                              ↓
            Supabase callback (auth/v1/callback)
                              ↓
              redirectTo: /dashboard.html?role=golf
                              ↓
                プロフィール初期化 or golf_dashboard.html へ
```

---

## ステップ 1. Google Cloud Console で OAuth 2.0 Client ID を作る

1. https://console.cloud.google.com/ にアクセス
2. プロジェクトを選択（無ければ「Caddygate」プロジェクトを新規作成）
3. **APIs & Services** → **OAuth consent screen**:
   - User Type: **External**
   - アプリ名: `Caddygate`
   - サポートメール: 自分の Gmail
   - アプリのロゴ・ドメイン等は任意
   - スコープ: `userinfo.email`, `userinfo.profile`, `openid` の 3 つを追加
   - テストユーザー: 開発中なら自分の Gmail を追加
4. **APIs & Services** → **Credentials** → **+ CREATE CREDENTIALS** → **OAuth client ID**:
   - Application type: **Web application**
   - 名前: `Caddygate Web`
   - **Authorized JavaScript origins**:
     - `https://caddygate.pages.dev`
     - `https://dfvxzwrqkxklfutlzqiq.supabase.co`
   - **Authorized redirect URIs**:
     - `https://dfvxzwrqkxklfutlzqiq.supabase.co/auth/v1/callback`
     - ⚠️ ここは Supabase の URL を入れる（Cloudflare ではない！）
5. **CREATE** すると **Client ID** と **Client Secret** が表示されるので両方コピー

---

## ステップ 2. Supabase Dashboard で Google プロバイダーを有効化

1. https://supabase.com/dashboard にアクセス
2. caddygate プロジェクト（`dfvxzwrqkxklfutlzqiq`）を開く
3. **Authentication** → **Providers** → **Google**:
   - Toggle を **ON**
   - **Client ID (for OAuth)**: ステップ 1 でコピーしたものを貼る
   - **Client Secret (for OAuth)**: 同上
   - **Authorized Client IDs**: 空でも OK（mobile アプリ用なので不要）
   - **Save**

---

## ステップ 3. Supabase の URL Configuration を確認

1. **Authentication** → **URL Configuration**:
   - **Site URL**: `https://caddygate.pages.dev`
   - **Redirect URLs**（許可リスト・複数登録可）:
     - `https://caddygate.pages.dev/**`
     - `https://caddygate.pages.dev/dashboard.html`
     - 独自ドメインがあれば: `https://your-domain.com/**`
     - ローカル開発: `http://localhost:8788/**`

⚠️ **Redirect URL のホワイトリストに入っていない URL に redirect しようとすると Supabase が弾きます**。`/dashboard.html?role=golf` で戻したいので `/**` パターンを必ず登録すること。

---

## ステップ 4. メール認証（Confirm Email）を ON にする

1. **Authentication** → **Sign In / Up**:
   - **Enable Email provider** ON（既にそうなってるはず）
   - **Confirm email** ON ← **これが今回新規 ON にするポイント**
2. **Authentication** → **Email Templates** → **Confirm signup** で本文をカスタマイズ可能（任意）。
   - リンク先 URL は自動で Supabase 側がハンドリング → セッション確立 → site URL へ戻ってくる
   - 戻り先は signUp 時に渡した `emailRedirectTo`（本実装では `/dashboard.html?role={role}&verified=1`）

これで通常メアド新規登録時にも確認メールが送られるようになります。

---

## ステップ 5. 動作確認

1. 本番にデプロイ後、`https://caddygate.pages.dev/login/?role=golf` を開く
2. 「Google で続ける」ボタンが表示されているか確認
3. ボタンを押す → Google アカウント選択画面 → 同意
4. Supabase callback → `/dashboard.html?role=golf` に戻ってくる
5. 初回ログインなら `/profile.html?role=golf` でプロフィール入力 → `/golf_dashboard.html` へ
6. 2 回目以降なら直接 `/golf_dashboard.html`

### 通常メアド新規登録の動作確認

1. `https://caddygate.pages.dev/login/?role=golf` で「新規登録はこちら」リンク
2. メールアドレス・パスワード・パスワード（確認）を入力 → 登録
3. 「確認メールを送信しました」バナーが出る
4. メールを開いてリンクをクリック
5. `/dashboard.html?role=golf&verified=1` に戻ってきて、`/profile.html?role=golf` に遷移
6. プロフィール入力完了 → `/golf_dashboard.html`

### 失敗時のチェックポイント

| エラー | 原因 |
|---|---|
| `redirect_uri_mismatch` | Google Cloud Console の Authorized redirect URIs に Supabase callback URL が入ってない |
| `Provider is not enabled` | Supabase で Google プロバイダーが OFF のまま |
| `Invalid login credentials` | Confirm email が ON で、メール確認前にログインしようとしている |
| Supabase の Auth Logs に何も来ない | Site URL / Redirect URLs のホワイトリスト漏れ |
| `verified=1` が付いて戻ってくるが profile.html に飛ばない | dashboard.html の onAuthStateChange が SIGNED_IN を拾えていない（コンソールログを確認） |

---

## 補足: キャディ側で同じ Google ボタンを使いたい場合

仕様上、キャディ側は **LINE Login 優先（おすすめバッジ付き）** にしていますが、もし Google も並列で出したい場合は `login/index.html` の以下行をいじる:

```js
if (role === "golf") {
  googleBtn.style.display = "inline-flex";
} else if (role === "caddy") {
  lineBtn.style.display = "inline-flex";
  // ↓ 追加すれば caddy にも Google を出せる
  // googleBtn.style.display = "inline-flex";
}
```

ただしキャディは「LINE で完結」のほうがオンボーディング摩擦が低いので、当面 LINE 単独運用を推奨します。
