# Caddygate Dashboard Design Principles（12 原則）

作成: design-strategist
作成日: 2026-06-01
位置付け: dashboard-research.md からの「型」抽出と統合。既存 principles.md（LP 14 原則）の **dashboard 拡張版**。visual-implementer はこの 12 原則を順守してダッシュボード（golf_dashboard.html / caddy_dashboard.html / profile.html / dashboard.html）を実装する。

## 0. 設計哲学（1 行）

> **「主役は数字と予約。装飾は引く。50-60 代男性が 3 秒で『今週の予約』を把握できる。」**

LP は「3 秒で SaaS と判定させる」、ダッシュボードは「3 秒で **業務状態を把握**させる」場。LP 原則「沈黙の余白」は維持しつつ、情報密度を 60-70% に上げて並べる。

---

## 12 原則 一覧

| # | 原則 | 一言で |
|---|---|---|
| D-01 | desktop = sidebar 240px + main、mobile = bottom tab bar | 上部タブ羅列の卒業 |
| D-02 | タブは **underline 型**、box-shadow / transform / 色塗りピル禁止 | Linear/Stripe/Notion 流 |
| D-03 | 状態バッジは「●dot + 短ラベル」、4 セマンティック色 | 色覚多様性 + 50-60代可読性 |
| D-04 | data table は zebra 禁止、row 高 48px + border-bottom のみ | 2026 標準 |
| D-05 | カレンダーは 4 状態（空/確定/NG/不可）を**背景色 + アイコン**併記 | 色だけに頼らない |
| D-06 | カード（予約・キャディ・研修）は **3 種類のみ標準化** | 自由 div の禁止 |
| D-07 | 予約詳細・キャディ詳細は **modal ではなく drawer** | context を破壊しない |
| D-08 | 上部に **KPI ストリップ 4 個**（ゴルフ場・キャディそれぞれ） | Home 着地 3 秒判定 |
| D-09 | empty state は **mono icon + warm copy + 1 CTA** | Linear/Notion 流 |
| D-10 | ダッシュボード余白は **LP の 60-70%**、section 間 24-48px | 情報密度確保 |
| D-11 | logout は header 右端 ghost ボタン、赤塗り禁止 | 業務動線の安全装置 |
| D-12 | LP design tokens 完全継承、追加トークンのみ dash- prefix | 二重管理回避 |

---

## D-01. desktop = sidebar 240px + main、mobile = bottom tab bar

### Why
Vercel / Linear / Stripe / Notion 2026 全件、**240-280px left sidebar + 12 column main canvas**。Caddygate 現状の「上部タブ 5 個羅列」は 2018-2020 設計で、(a) 機能追加に弱い (b) タブ名が長くなると折り返す (c) 同時に「今どこ?」「何を選べる?」の認知負荷が高い、の 3 重欠点。

ただし機能数が 6-7 個と少ないため、**desktop sidebar / mobile bottom tab bar** のハイブリッドが最適。bottom tab は親指リーチ範囲で、50-60 代でも片手操作可。

### 実装パターン
```css
/* デスクトップ: sidebar layout */
.dash-shell {
  display: grid;
  grid-template-columns: 240px 1fr;
  min-height: 100vh;
  background: var(--color-bg);
}
.dash-sidebar {
  background: var(--color-bg);                    /* main と同じ背景で「沈ませる」 */
  border-right: 1px solid var(--color-border);
  padding: var(--space-5) var(--space-3);
  position: sticky; top: 0; height: 100vh;
  overflow-y: auto;
}
.dash-main {
  padding: var(--space-5) var(--space-6);
  max-width: 1280px;
}

/* モバイル: bottom tab bar */
@media (max-width: 767px) {
  .dash-shell { grid-template-columns: 1fr; }
  .dash-sidebar { display: none; }
  .dash-bottom-nav { display: flex; }
}
.dash-bottom-nav {
  display: none;
  position: fixed; left: 0; right: 0; bottom: 0;
  background: var(--color-surface);
  border-top: 1px solid var(--color-border);
  padding: var(--space-2) 0 calc(var(--space-2) + env(safe-area-inset-bottom));
  z-index: var(--z-sticky);
  justify-content: space-around;
}
```

### sidebar アイテム
- 選択中: background `var(--color-primary-soft-bg)`、text `var(--color-primary)`、weight 600
- 非選択: background transparent、text `var(--color-ink-sub)`、weight 500
- hover: background `rgba(0,0,0,0.04)`

---

## D-02. タブは underline 型、box-shadow / transform / 色塗りピル禁止

### Why
Caddygate 現状（golf_dashboard.html L40-55）の `.tabs-main button.active` は:
```
background: #27ae60;
color: #fff;
border-color: #27ae60;
box-shadow: 0 4px 12px rgba(39,174,96,0.25);
transform: translateY(-2px);
```
これは **B2C アプリ感**で、Linear / Stripe / Notion の B2B 標準から乖離。**業務効率優先の SaaS では装飾を引く**。

### 実装パターン
```css
.dash-tabs {
  display: flex;
  gap: var(--space-1);
  border-bottom: 1px solid var(--color-border);
  margin-bottom: var(--space-5);
  overflow-x: auto;
  scrollbar-width: none;
}
.dash-tabs::-webkit-scrollbar { display: none; }

.dash-tab {
  appearance: none; background: transparent; border: 0;
  padding: var(--space-3) var(--space-4);
  font-size: var(--fs-body);
  font-weight: 500;
  color: var(--color-ink-sub);
  border-bottom: 2px solid transparent;
  margin-bottom: -1px; /* border 重ねでガタつき防止 */
  cursor: pointer;
  white-space: nowrap;
  transition: color var(--t-fast);
}
.dash-tab:hover { color: var(--color-ink); }
.dash-tab[aria-selected="true"],
.dash-tab.is-active {
  color: var(--color-primary);
  border-bottom-color: var(--color-primary);
  font-weight: 600;
}
```

active の selection indicator は **color + weight + border-bottom の 3 重**（Setproduct 推奨「2 つ以上」を超えて 3 つ）。

---

## D-03. 状態バッジは「●dot + 短ラベル」、4 セマンティック色

### Why
Carbon / Setproduct 共通主張: badge は**色だけで識別可能**であるべき、かつ色覚多様性のため dot や icon を併用。Caddygate の予約状態（仮予約 / 確定 / 完了 / キャンセル）は **4 セマンティック色**にちょうどマップ。

### セマンティック割当
| 状態 | dot 色 | bg 色 | text 色 | label |
|---|---|---|---|---|
| 仮予約 (pending) | warn | warn-soft | warn-deep | 仮予約 |
| 確定 (confirmed) | primary | primary-soft-bg | primary-deep | 確定 |
| 完了 (completed) | info | info-soft | info-deep | 完了 |
| キャンセル (cancelled) | mute | gray-soft | ink-sub | キャンセル |
| 拒否/エラー (error) | accent | accent-soft | accent-deep | 拒否 |

### 実装パターン
```css
.badge {
  display: inline-flex; align-items: center;
  gap: var(--space-1);
  padding: var(--space-1) var(--space-2);
  font-size: var(--fs-micro);
  font-weight: 600;
  line-height: 1.2;
  border-radius: var(--radius-sm);
  letter-spacing: var(--ls-wide);
  white-space: nowrap;
}
.badge::before {
  content: ""; width: 6px; height: 6px; border-radius: 50%;
  background: currentColor; opacity: 0.9;
}

.badge--pending   { background: var(--color-warn-soft);    color: var(--color-warn-deep); }
.badge--confirmed { background: var(--color-primary-soft-bg); color: var(--color-primary-deep); }
.badge--completed { background: var(--color-info-soft);    color: var(--color-info-deep); }
.badge--cancelled { background: var(--color-gray-soft);    color: var(--color-ink-sub); }
.badge--error     { background: var(--color-accent-soft);  color: var(--color-accent-deep); }
```

---

## D-04. data table は zebra 禁止、row 高 48px + border-bottom のみ

### Why
Eleken / Pencil & Paper 2026: zebra stripe は hover / focus / active states と衝突し**現代では非推奨**。代わりに「**1px border-bottom + 適切な行高**」で十分なリズム。

### 実装パターン
```css
.dash-table {
  width: 100%;
  background: var(--color-surface);
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
  overflow: hidden;
  font-size: var(--fs-body);
}
.dash-table thead th {
  padding: var(--space-3) var(--space-4);
  background: var(--color-surface-alt);
  color: var(--color-ink-sub);
  font-size: var(--fs-small);
  font-weight: 600;
  text-align: left;
  letter-spacing: var(--ls-wide);
  border-bottom: 1px solid var(--color-border);
}
.dash-table tbody td {
  padding: var(--space-3) var(--space-4);
  height: 48px;                                 /* 標準行高 48px */
  border-bottom: 1px solid var(--color-border);
  vertical-align: middle;
}
.dash-table tbody tr:last-child td { border-bottom: 0; }
.dash-table tbody tr:hover { background: var(--color-bg); }   /* zebra ではなく hover で active row 強調 */

/* 数値列は右寄せ（Polaris 流） */
.dash-table .num { text-align: right; font-variant-numeric: tabular-nums; }
```

zebra 禁止。`thead` 背景のみ `surface-alt` で区別。

---

## D-05. カレンダーは 4 状態を背景色 + アイコン併記

### Why
Caddygate 現状の `.cal-green / .cal-yellow / .cal-red` は色だけ。STORES / Airbnb は色 + 小アイコン / 数字併記。意味推測コストを下げる + プリント対応 + 色覚多様性。

### 4 状態マッピング
| 状態 | bg | icon | 意味 |
|---|---|---|---|
| 空き（予約可） | `--color-surface` | ○ | 予約可能・キャディあり |
| 確定（自分の予約） | `--color-primary-soft-bg` | ✓ | 自分が確定済 |
| 一部空き（残少） | `--color-warn-soft` | △ | 残 1-2 名のみ |
| 不可（休日・上限） | `--color-gray-soft` | × | 予約不可 |

### 実装パターン
```css
.cal-grid {
  width: 100%;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  overflow: hidden;
  border-collapse: separate;
  border-spacing: 0;
}
.cal-grid th {
  padding: var(--space-2);
  background: var(--color-surface-alt);
  font-size: var(--fs-micro);
  font-weight: 600;
  color: var(--color-ink-sub);
  border-bottom: 1px solid var(--color-border);
}
.cal-grid td {
  position: relative;
  padding: var(--space-2);
  height: 72px;
  vertical-align: top;
  border-right: 1px solid var(--color-border);
  border-bottom: 1px solid var(--color-border);
  cursor: pointer;
  transition: background var(--t-fast);
}
.cal-grid td:last-child { border-right: 0; }
.cal-grid tr:last-child td { border-bottom: 0; }

.cal-grid td:hover:not(.cal-disabled) { background: var(--color-bg); }
.cal-grid .cal-date {
  font-size: var(--fs-small);
  font-weight: 600;
  color: var(--color-ink);
}
.cal-grid .cal-mark {
  position: absolute;
  bottom: var(--space-2);
  right: var(--space-2);
  font-size: var(--fs-small);
  font-weight: 700;
}

/* 4 状態 */
.cal-available  { background: var(--color-surface); }
.cal-available .cal-mark::after { content: "○"; color: var(--color-primary); }

.cal-confirmed  { background: var(--color-primary-soft-bg); }
.cal-confirmed .cal-mark::after { content: "✓"; color: var(--color-primary-deep); }

.cal-warn       { background: var(--color-warn-soft); }
.cal-warn .cal-mark::after { content: "△"; color: var(--color-warn-deep); }

.cal-disabled   { background: var(--color-gray-soft); cursor: not-allowed; }
.cal-disabled .cal-mark::after { content: "×"; color: var(--color-ink-mute); }
.cal-disabled .cal-date { color: var(--color-ink-mute); }
```

---

## D-06. カードは 3 種類のみ標準化

### Why
現状 `caddy_dashboard.html` / `golf_dashboard.html` には **無限の div + inline style** がある。これは visual-implementer が増築するたびにスタイル分岐が起き、半年で崩壊する。**3 種類に固定**して、それ以外は禁止。

### 3 種類
1. **`.card`** — 標準カード（プロフィール表示、設定フォーム等）
2. **`.booking-card`** — 予約アイテムカード（日付・時間・キャディ・状態を 1 セット）
3. **`.person-card`** — 人物カード（キャディ一覧・ゴルフ場一覧）

### 実装パターン
```css
/* 1. 標準カード */
.card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-5);
}
.card__title {
  font-size: var(--fs-h3);
  font-weight: 600;
  margin-bottom: var(--space-3);
}

/* 2. 予約カード */
.booking-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  padding: var(--space-4);
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: var(--space-4);
  align-items: center;
}
.booking-card__date {
  font-size: var(--fs-h3);
  font-weight: 700;
  color: var(--color-primary);
  font-variant-numeric: tabular-nums;
  line-height: 1.1;
  min-width: 56px;
}
.booking-card__date-day {
  font-size: var(--fs-small);
  color: var(--color-ink-sub);
  font-weight: 500;
}
.booking-card__main { display: flex; flex-direction: column; gap: var(--space-1); }
.booking-card__title { font-weight: 600; font-size: var(--fs-body); }
.booking-card__meta  { font-size: var(--fs-small); color: var(--color-ink-sub); }
.booking-card__actions { display: flex; gap: var(--space-2); }

/* 3. 人物カード */
.person-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  padding: var(--space-4);
  display: flex;
  gap: var(--space-3);
  align-items: center;
}
.person-card__avatar {
  width: 48px; height: 48px;
  border-radius: 50%;
  background: var(--color-primary-soft-bg);
  display: flex; align-items: center; justify-content: center;
  font-weight: 700; color: var(--color-primary-deep);
  flex-shrink: 0;
}
.person-card__info { flex: 1; min-width: 0; }
.person-card__name { font-weight: 600; font-size: var(--fs-body); }
.person-card__meta { font-size: var(--fs-small); color: var(--color-ink-sub); }
```

---

## D-07. 予約・キャディ詳細は modal ではなく drawer

### Why
Userpilot / LogRocket 2026 共通: modal は context を破壊する。drawer なら親一覧（table / calendar）が見えたまま編集可能。Caddygate は **予約詳細 / キャディ詳細 / 研修詳細**を全部 drawer に。modal は「ログアウト確認」「予約キャンセル確認」などの critical/irreversible のみ。

### 実装パターン
```css
.drawer-backdrop {
  position: fixed; inset: 0;
  background: rgba(26, 26, 26, 0.32);
  opacity: 0; pointer-events: none;
  transition: opacity var(--t-base);
  z-index: var(--z-modal);
}
.drawer-backdrop[data-open="true"] { opacity: 1; pointer-events: auto; }

.drawer {
  position: fixed; top: 0; right: 0; bottom: 0;
  width: min(480px, 92vw);
  background: var(--color-surface);
  border-left: 1px solid var(--color-border);
  transform: translateX(100%);
  transition: transform var(--t-slow);
  z-index: calc(var(--z-modal) + 1);
  display: flex; flex-direction: column;
  box-shadow: -8px 0 24px rgba(26, 26, 26, 0.08);
}
.drawer[data-open="true"] { transform: translateX(0); }
.drawer__header {
  padding: var(--space-4) var(--space-5);
  border-bottom: 1px solid var(--color-border);
  display: flex; align-items: center; justify-content: space-between;
}
.drawer__title { font-size: var(--fs-h3); font-weight: 600; }
.drawer__close {
  width: 32px; height: 32px;
  border-radius: var(--radius-sm);
  display: flex; align-items: center; justify-content: center;
}
.drawer__close:hover { background: var(--color-bg); }
.drawer__body { flex: 1; overflow-y: auto; padding: var(--space-5); }
.drawer__footer {
  padding: var(--space-4) var(--space-5);
  border-top: 1px solid var(--color-border);
  display: flex; gap: var(--space-3); justify-content: flex-end;
}

@media (max-width: 767px) {
  /* モバイルは bottom sheet */
  .drawer {
    top: auto; left: 0; right: 0; bottom: 0;
    width: 100%;
    max-height: 88vh;
    border-left: 0;
    border-top: 1px solid var(--color-border);
    border-radius: var(--radius-lg) var(--radius-lg) 0 0;
    transform: translateY(100%);
  }
  .drawer[data-open="true"] { transform: translateY(0); }
}
```

---

## D-08. 上部に KPI ストリップ 4 個

### Why
Calendly / Stripe Dashboard / 2026 SaaS 標準。**Home 着地 3 秒で業務状態が把握できる**ことが業務 SaaS の存在意義。

### ゴルフ場側 4 指標
1. 今週の予約数
2. 来週の予約数
3. 待機中キャディ数
4. 研修希望者数

### キャディ側 4 指標
1. 今週の予約数
2. 今月の収入見込
3. 未対応の研修
4. 未読メッセージ

### 実装パターン
```css
.kpi-strip {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: var(--space-3);
  margin-bottom: var(--space-5);
}
@media (max-width: 767px) {
  .kpi-strip { grid-template-columns: repeat(2, 1fr); gap: var(--space-2); }
}
.kpi-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  padding: var(--space-4);
}
.kpi-card__label {
  font-size: var(--fs-small);
  color: var(--color-ink-sub);
  margin-bottom: var(--space-2);
  font-weight: 500;
}
.kpi-card__value {
  font-size: var(--fs-stat-md);
  font-weight: 700;
  color: var(--color-ink);
  line-height: 1.1;
  font-variant-numeric: tabular-nums;
}
.kpi-card__unit { font-size: var(--fs-body); color: var(--color-ink-sub); margin-left: 2px; }
.kpi-card__delta { font-size: var(--fs-micro); color: var(--color-ink-mute); margin-top: var(--space-1); }
.kpi-card__delta--up   { color: var(--color-primary); }
.kpi-card__delta--down { color: var(--color-accent); }
```

---

## D-09. empty state は mono icon + warm copy + 1 CTA

### Why
Linear / Notion / Vercel 共通: empty state は「無」ではなく「次の一歩」を示す。50-60 代男性に「何をしていいか分からない」を起こさせない。

### 実装パターン
```css
.empty {
  text-align: center;
  padding: var(--space-9) var(--space-5);
  color: var(--color-ink-sub);
}
.empty__icon {
  width: 48px; height: 48px;
  margin: 0 auto var(--space-3);
  color: var(--color-ink-mute);
  stroke-width: 1.5;
}
.empty__title {
  font-size: var(--fs-lead);
  font-weight: 600;
  color: var(--color-ink);
  margin-bottom: var(--space-2);
}
.empty__desc {
  font-size: var(--fs-small);
  max-width: 360px;
  margin: 0 auto var(--space-4);
  line-height: var(--lh-snug);
}
.empty__cta { display: inline-flex; }
```

### コピー型
- 「今週はまだ予約がありません」+ 「空きキャディを探す」CTA
- 「研修希望のキャディはまだいません」+ 「研修可能日を設定する」CTA
- 「メッセージはまだありません」+ （CTA なし、待つ）

---

## D-10. ダッシュボード余白は LP の 60-70%

### Why
LP では sectoin 間 96-120px だが、ダッシュボードでこの余白は冗長。**情報密度が業務効率を決める**。Polaris の density 思想に合わせる。

### 実装ルール
- 大カテゴリ間（KPI ストリップ → メインリスト 等）: `var(--space-6)` = 32px
- カード間: `var(--space-3)` = 12px
- カード内余白: `var(--space-4)` = 16px（小） / `var(--space-5)` = 24px（標準）
- table 行内 padding: `var(--space-3)` 縦 / `var(--space-4)` 横

LP の `--space-9〜--space-11`（80-120px）は dashboard では原則使わない。

---

## D-11. logout は header 右端 ghost ボタン、赤塗り禁止

### Why
Caddygate 現状の `#logoutBtn{ background: #dc3545 !important; }` は「危険なボタン」を表す配色で、毎日見るには威圧的すぎる。logout は **業務動線の安全装置**であり、毎日触るものではない。**header 右端の ghost 状態**で十分。確認 modal を挟めば誤クリックも防げる。

### 実装パターン
```css
.dash-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: var(--space-3) var(--space-5);
  background: var(--color-surface);
  border-bottom: 1px solid var(--color-border);
  position: sticky; top: 0; z-index: var(--z-header);
}
.dash-header__brand {
  font-size: var(--fs-body);
  font-weight: 700;
  color: var(--color-primary);
  letter-spacing: var(--ls-tight);
}
.dash-header__actions { display: flex; gap: var(--space-2); align-items: center; }
.dash-header__user {
  font-size: var(--fs-small);
  color: var(--color-ink-sub);
}
.btn--ghost {
  background: transparent;
  border: 1px solid var(--color-border);
  color: var(--color-ink-sub);
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-sm);
  font-size: var(--fs-small);
  font-weight: 500;
}
.btn--ghost:hover {
  background: var(--color-bg);
  color: var(--color-ink);
}
```

---

## D-12. LP design tokens を完全継承、追加トークンのみ dash- prefix

### Why
LP framework.css の token を破壊すると、後で LP と dashboard で色がずれて「同じサービスに見えない」事故が起きる。dashboard 専用追加トークンは **dash- prefix** で衝突回避。

### 追加トークン（dashboard-framework.css に定義）
```css
:root {
  /* status soft backgrounds（badge / calendar 用） */
  --color-primary-soft-bg: #E8F2E8;   /* 苔緑 5% 抜き */
  --color-warn-soft:       #FAF1D8;
  --color-warn-deep:       #7A6420;
  --color-info-soft:       #F0E8D8;
  --color-info-deep:       #6B5630;
  --color-gray-soft:       #F0EEE8;
  --color-accent-soft:     #F7E5E1;

  /* dashboard 専用 spacing alias（読みやすさ向上のみ） */
  --dash-sidebar-w:        240px;
  --dash-main-max:         1280px;
  --dash-row-h-compact:    40px;
  --dash-row-h-normal:     48px;
  --dash-row-h-tall:       56px;
  --dash-cal-cell-h:       72px;
  --dash-header-h:         56px;
  --dash-bottom-nav-h:     64px;

  /* dashboard 専用 z-index */
  --z-drawer:              1100;
  --z-toast:               1200;
}
```

LP の token はそのまま使う（color-primary / color-bg / space-* / fs-* / radius-* 等）。

---

## 13. visual-implementer への引き継ぎ要約

ダッシュボード実装時は以下の順で:

1. `framework.css`（LP 用）読み込みは維持
2. `dashboard-framework.css`（新規追加）を `framework.css` の **後**に読み込み
3. body 直下を `<div class="dash-shell">` で包む
4. `<aside class="dash-sidebar">` + `<main class="dash-main">` の 2 ペイン
5. main 内は `<header class="dash-header">` → `<section class="kpi-strip">` → `<nav class="dash-tabs">` → メインコンテンツの順
6. 既存の DOM ID（btnMainStat, mainStatus 等）と Supabase JS 呼び出しは**絶対に壊さない**。クラス追加のみで再スタイル
7. inline style は全て削除し、class 経由に変換

優先適用すべき原則（実装時の最重要）: **D-02（タブ underline 化）、D-03（badge 統一）、D-05（カレンダー再設計）、D-06（カード 3 種固定）、D-11（logout ghost 化）**
