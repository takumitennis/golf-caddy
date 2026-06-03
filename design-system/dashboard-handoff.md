# Caddygate Dashboard — visual-implementer 引き継ぎノート

作成: design-strategist
作成日: 2026-06-01
宛先: visual-implementer
目的: 設計フェーズは完了。実装で守るべき仕様・順番・チェックポイントを 1 枚にまとめる。

---

## 0. 前提

- 設計の憲法は `/Users/takumi/caddytas/design-system/` 配下
- LP design-system（既存）に **dashboard-* 5 ファイルを追加**した。LP の token / utility は破壊していない
- 実装対象は以下 4 ファイル（既存）:
  - `/Users/takumi/caddytas/golf_dashboard.html`
  - `/Users/takumi/caddytas/caddy_dashboard.html`
  - `/Users/takumi/caddytas/profile.html`
  - `/Users/takumi/caddytas/dashboard.html`

---

## 1. 読み込み順序（絶対）

```html
<link rel="stylesheet" href="/design-system/framework.css">          <!-- LP 用、先 -->
<link rel="stylesheet" href="/design-system/dashboard-framework.css"> <!-- ダッシュボード追加、後 -->
```

順序逆転すると LP token が上書きされて事故る。

---

## 2. 守るべき制約（絶対）

1. **既存の Supabase JS 呼び出しを壊さない** — `sb.from(...)`, `sb.auth...` 等のクエリは変更禁止
2. **既存の DOM ID を維持** — `btnMainStat`, `mainStatus`, `tabConfirm`, `mainCalendar`, `welcome`, `logoutBtn`, `gcCreateForm`, `gcName` 等。既存 JS が ID で参照しているため
3. **新規 class は ID と並行付与** — 例: `<button id="btnMainStat" class="dash-tab is-active">`
4. **inline style 完全削除**（`style="display:none"` 等の動的トグル用は許可、装飾は禁止）
5. **HTML 構造の外側を入れ替える** — body 直下に `.dash-shell` を入れ、その内側に既存のコンテンツを移植

---

## 3. 実装順序（推奨）

各ファイル独立で進めること。golf_dashboard.html から着手するのが効果的。

### Step 1: shell + header の置換
- `<body>` 直下を `<div class="dash-shell">` で包む
- 内部に `<aside class="dash-sidebar">` と `<main class="dash-main">` を作る
- 既存の `<h1>` を削除し、main 内の `<header class="dash-header">` に置換
- mobile 用に `<nav class="dash-bottom-nav">` を `.dash-shell` 内末尾に追加

### Step 2: タブの underline 化
- `.tabs-main` → `.dash-tabs`、内部 button に `.dash-tab` + active 時 `.is-active`
- 既存の inline `style="margin-left:auto"`（logout のため）は削除し、logout は sidebar 末尾に移動

### Step 3: badge 統一
- 「仮予約」「予約済」「完了」「キャンセル」「拒否」と表示している箇所を、JS の状態値マッピングで `<span class="badge badge--{state}">` に出力

### Step 4: card / table / form 置換
- inline style の `<div style="background:#fff;...">` を `<div class="card">` に
- table は `<table class="dash-table">` に
- form は `.form-field` + `.form-input` 構造に

### Step 5: calendar 4 状態化
- `.calendar` → `.cal-shell` + `.cal-grid`
- `.cal-green / .cal-yellow / .cal-red` を `.cal-confirmed / .cal-warn / .cal-disabled` に置換
- `.cal-mark` 要素を各セル末尾に追加し、icon を自動付与
- legend 帯を grid 下に追加

### Step 6: drawer 導入
- 既存の inline 詳細表示や `#reserveBar` を `.drawer` に移行
- backdrop + drawer の HTML を body 末尾に配置

### Step 7: KPI ストリップ追加
- ゴルフ場側: 今週予約 / 来週予約 / 待機キャディ / 研修希望者
- キャディ側: 今週予約 / 今月収入見込 / 未対応研修 / 未読メッセージ
- データは Supabase クエリで取得して数値を埋める

### Step 8: empty state 追加
- 各リスト/カレンダーで「データなし」の箇所を `.empty` 構造に
- copy は dashboard-components.md の例に従う

### Step 9: logout の ghost 化
- `#logoutBtn` の inline `background: #dc3545` を削除
- `class="btn--ghost"` を付与
- click で `.modal-backdrop[data-open]` を開いて確認 modal を出す

### Step 10: チェックリストで全件検証
- dashboard-components.md L13 の「実装チェックリスト」を順に確認

---

## 4. 優先適用すべき原則（最重要 5 つ）

| 優先 | 原則 | 効果 |
|---|---|---|
| 1 | **D-11**（logout ghost 化） | 赤塗り削除だけで全体トーン改善 |
| 2 | **D-02**（タブ underline 化） | B2C 感の払拭 |
| 3 | **D-01**（sidebar + main 化） | 情報構造の根本リフレッシュ |
| 4 | **D-03**（badge 統一） | 状態表現の一貫性 |
| 5 | **D-05**（calendar 4 状態 + アイコン） | 業務理解度向上 |

これら 5 つを終えれば「現代 B2B SaaS の見た目」に到達する。残りは完成度の底上げ。

---

## 5. やってはいけないこと

- **新しい色を導入する** — 必ず既存 token を使う
- **box-shadow を足す** — `--shadow-card` 以外禁止
- **border-radius を 12px 以上にする** — 最大 `--radius-lg` = 8px
- **transform: translateY や scale でホバー演出を作る** — フラット運用
- **タブを pill 型にする** — underline のみ
- **絵文字を bullet 代わりに使う** — Lucide icon のみ
- **inline style を残す** — 動的トグル以外は全て class に

---

## 6. 完了の判定

すべて Yes になれば完了:

- [ ] golf_dashboard.html / caddy_dashboard.html / profile.html / dashboard.html の 4 ファイルが新型に
- [ ] 既存の予約フロー（空きキャディ確認 → 予約 → 確定 → メッセージ）が壊れていない
- [ ] mobile（iPhone）で sidebar 非表示、bottom nav 表示
- [ ] 全ての色が LP の token と一致（苔緑 / 古紙オフ / 朱）
- [ ] LP（index.html）からログインしてダッシュボードに着地した時、**世界観の断絶**を感じない
- [ ] 50-60 代支配人ターゲットがタップ精度 48px 以上を満たす
- [ ] dashboard-components.md の HTML パターン以外の自由 div / inline style がゼロ

---

## 7. 関連ファイル一覧

設計の根拠 / 仕様:
- `/Users/takumi/caddytas/design-system/dashboard-research.md`（リサーチログ 22 件）
- `/Users/takumi/caddytas/design-system/dashboard-principles.md`（12 原則 D-01〜D-12）
- `/Users/takumi/caddytas/design-system/dashboard-framework.css`（CSS framework）
- `/Users/takumi/caddytas/design-system/dashboard-components.md`（HTML サンプル + マッピング表）
- `/Users/takumi/caddytas/design-system/dashboard-before-after.md`（差分言語化）

既存 LP 用（壊さない）:
- `/Users/takumi/caddytas/design-system/framework.css`
- `/Users/takumi/caddytas/design-system/principles.md`
- `/Users/takumi/caddytas/design-system/research.md`
- `/Users/takumi/caddytas/design-system/components.md`
- `/Users/takumi/caddytas/design-system/layouts.md`
- `/Users/takumi/caddytas/design-system/responsive.md`
- `/Users/takumi/caddytas/design-system/tokens.md`
- `/Users/takumi/caddytas/design-system/typography.md`
- `/Users/takumi/caddytas/design-system/tone-of-voice.md`

実装対象（既存、刷新する）:
- `/Users/takumi/caddytas/golf_dashboard.html`
- `/Users/takumi/caddytas/caddy_dashboard.html`
- `/Users/takumi/caddytas/profile.html`
- `/Users/takumi/caddytas/dashboard.html`
