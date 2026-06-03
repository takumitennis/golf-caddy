# LINE Login セットアップ手順（キャディ側）

このドキュメントは「キャディが LINE ボタン一発でログイン／新規登録できる」機能を有効化するための手順書です。
既存の **Messaging API（友だち追加 + 通知送信用）** とは別の **Login channel** を新規で作る必要があります。

---

## 全体像

```
caddytas (Cloudflare Pages)
   ├ login/index.html  ─── [LINE で続ける] ボタン
   ├ /api/line-login-init        ← state 発行・authorize URL を返す
   └ /api/line-login-callback    ← code → token 交換、Supabase user upsert、session 確立
```

完成後フロー:

1. キャディがログイン画面で「LINE で続ける」を押す
2. LINE の同意画面で許可
3. Supabase 側でユーザーが自動作成され、`role=caddy` でセッション確立
4. 既存ユーザーならキャディダッシュボードへ、初回なら `profile.html?role=caddy` でプロフィール入力

---

## ステップ 1. LINE Developers Console で Login channel を作る

1. https://developers.line.biz/console/ にアクセス
2. 既存のプロバイダー（Messaging API channel を作ったところ）を開く
   - もし無ければ「新規プロバイダー作成」
3. プロバイダー内で **「新規チャネル作成」** → **「LINEログイン」** を選択
   - **注意**: Messaging API channel は流用できません。Login 専用の channel が必須
4. 必須項目:
   - チャネル名: `Caddygate Login`
   - チャネル説明: 任意
   - アプリタイプ: `ウェブアプリ` にチェック（必須）
   - メールアドレス: 通知用
5. 作成完了後、**チャネル基本設定** タブで:
   - **チャネル ID** をメモ（後で Cloudflare に登録）
   - **チャネルシークレット** をメモ（同上）

---

## ステップ 2. Callback URL を登録

LINE Developers Console → 作成した Login channel → **LINEログイン設定** タブ:

- **コールバック URL** に以下を追加（複数登録可・改行区切り）:
  - 本番: `https://caddygate.pages.dev/api/line-login-callback`
  - 独自ドメインがあればそれも追加
  - ローカル開発する場合: `http://localhost:8788/api/line-login-callback`

⚠️ ここで登録した URL と Cloudflare Pages の URL は **完全一致** が必須。typo / 末尾スラッシュ違いで全部弾かれます。

---

## ステップ 3. スコープ（権限）の設定

同じ「LINEログイン設定」タブ内:

- **OpenID Connect** → `email_address` 取得を **要望しない** ままで OK
  - 取得する場合は別途審査が要る（メールアドレス取得申請）
  - 本実装は email 無しでも動く（合成 email `line_{userId}@caddygate.local` を使う）

- スコープ:
  - `profile`（必須）
  - `openid`（必須・id_token 取得用）

---

## ステップ 4. Cloudflare Pages の環境変数を追加

Cloudflare Pages dashboard → 該当プロジェクト → **Settings** → **Environment variables**:

| 変数名 | 値 | スコープ |
|---|---|---|
| `LINE_LOGIN_CHANNEL_ID` | ステップ 1 でメモしたチャネル ID | Production / Preview 両方 |
| `LINE_LOGIN_CHANNEL_SECRET` | ステップ 1 でメモしたチャネルシークレット | 両方 |
| `SUPABASE_SERVICE_KEY` | Supabase の service_role key（既存）| 両方 |
| `SUPABASE_ANON_KEY` | Supabase の anon public key | 両方 |
| `SUPABASE_URL` | `https://dfvxzwrqkxklfutlzqiq.supabase.co`（既存）| 両方 |
| `SITE_ORIGIN` | 本番 URL（例 `https://caddygate.pages.dev`）| 両方 |

⚠️ 環境変数を変更したら、**Pages を再デプロイしないと反映されません**（Deployments → 最新を選んで Retry deployment）。

---

## ステップ 5. 動作確認

1. 本番にデプロイ後、`https://caddygate.pages.dev/login/?role=caddy` を開く
2. 「LINE で続ける」ボタンが表示されているか確認
3. ボタンを押す → LINE の同意画面が出る → 許可
4. `/api/line-login-callback` に戻ってきて、「LINE ログイン処理中…」と一瞬出てから `/dashboard.html` → `/profile.html?role=caddy` に遷移する
5. プロフィール入力 → `caddy_dashboard.html` へ進めば成功

### 失敗時のチェックポイント

| エラー | 原因 |
|---|---|
| `state 不一致` | cookie がブロックされている、または別ブラウザで callback が開かれた |
| `id_token が LINE から返ってきませんでした` | scope に `openid` が含まれてない |
| `LINE トークン取得失敗 (400)` | Callback URL の登録ミス / Channel Secret 間違い |
| `Supabase magic link 発行失敗` | `SUPABASE_SERVICE_KEY` が anon key になっている |
| `サーバー設定エラー: ...` | 必須環境変数が抜けている。Cloudflare Pages の env vars を再確認 |

---

## アーキテクチャ補足

- LINE ユーザーには **Supabase 上で email-less な user** を作るのが理想ですが、Supabase auth は email 必須なので `line_{userId}@caddygate.local` というダミー email を採用しています。
- `line_integrations` には `cid = "auth_{userIdの先頭8文字}"` を暫定 PK で入れます。
  - 後で `profile.html` でキャディが正式 `cid` を発行するタイミングで、必要なら別途 migration を書いてください。
- LINE Login と既存の **Messaging API（通知送信）の友だち追加リンク** は別物です。LINE Login しただけでは公式アカウントの友だちにはならないので、通知を受け取りたいキャディには別途友だち追加 + LINK トークン送信フロー（既存）を案内する必要があります。

## 将来 email 取得もしたい場合

LINE Developers Console → 該当 Login channel → 「メールアドレス取得権限」を申請（数日かかる）。
取得後は authorize URL の scope に `email` を追加すれば `id_token.email` が入ってきます。
本実装の callback コードは既に `claims.email` を優先して使う実装なので、追加コード変更は不要です。
