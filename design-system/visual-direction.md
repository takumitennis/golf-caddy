# Caddygate Dashboard Visual Direction

作成: art-director
作成日: 2026-06-01
位置付け: design-strategist が確立した 12 原則（dashboard-principles.md）と HTML 構造（dashboard-components.md）の上に、**実際の見え方（配色トーン、シャドウ、ボーダー、角丸、KPI/テーブル/バッジ/ボタン/サイドバー/empty state の visual spec）** を載せる責任。LP（古紙ベージュ＋朱赤）は温存し、ダッシュボードのみ別トーンで分離。

---

## 0. 一行サマリー

> **「印刷された業務台帳のような白基調、サイドバーは薄いウォームグレー、アクションは near-black、ブランドの息継ぎだけ深い苔緑」**

Linear / Vercel / Cal.com / Stripe / Resend / Supabase が 2026 で揃って到達したのは「ほぼ色を使わない」「シャドウではなく低不透明 1px ボーダー」「角丸 6-8px」「near-black が CTA、ブランドカラーは active state と微量のアクセントだけ」というトーン。Caddygate ダッシュボードはこれに合流する。**色は引く、文字と数字で読ませる。**

---

## 1. リサーチ観察まとめ（7 サイト・現役 B2B SaaS）

design-strategist のリサーチ 22 件を、art-director の視点で 2026 ダッシュボード代表 7 件に絞って visual 観察を補強した。

| # | サイト | 配色トーン | ボーダー/シャドウ | 角丸 | アクセント |
|---|---|---|---|---|---|
| 1 | Linear（UI Refresh 2026-03） | pure white surface + 薄グレー sidebar、テキスト near-black、color はほぼ使わず | 1px @ 8-10% opacity border、shadow なし | 6-8px、コンテナで一定 | brand purple は active と link のみ |
| 2 | Vercel（Dashboard Redesign 2026-02） | 純白 + #000 ボタン、grid line #E5E7EB を 10-20% に薄める | border 中心、card に shadow ほぼなし | 6-8px、ボタンは 6px | 黒一色、緑/青はステータスのみ |
| 3 | Cal.com | off-white に近い純白、ブランド黒 + アクセント無彩 | 1px border、シャドウは popover のみ極弱 | 8px 主、ボタン 6px | 黒 CTA、green は予約確定のみ |
| 4 | Stripe Dashboard | 純白 + 淡グレー sidebar、blue/purple はチャートとリンクのみ | border 1px、card に subtle shadow（1px 4% 程度） | 8px | violet/indigo がブランドだが量は少ない |
| 5 | Resend | ほぼモノクロ、CTA は black solid | 1px border、shadow ほぼなし | 8px | 黒一色、green は send 状態のみ |
| 6 | Supabase Studio | 白基調、サイドバー薄、テキスト hierarchical gray | 1px border、shadow なし | 6px | brand green は active と logo のみ、UI 内は黒 |
| 7 | Notion（業務側） | warm off-white 寄り、padding 寛大 | hairline border、shadow ほぼなし | 6px | テキスト色強調主体 |

### 共通結論（art-director 視点）
1. **2026 のダッシュボードは「色を引く」が前提**。ブランドカラーは active state、リンク、ロゴ、status の "確定" など意味のある一点でしか使わない。
2. **CTA は near-black（#0A0A0A〜#18181B）が標準**。ブランドの緑/紫/青を CTA に塗ると、5 分後に「うるさい」と感じる。
3. **シャドウはほぼ使わない**。card は 1px ボーダーで縁取る方が「ちゃんとした業務 SaaS」に見える。ポップオーバー/ドロワーのみ控えめなシャドウ。
4. **角丸は 6-8px**。ボタンも card も同じ系の角丸。4px は古く、12px+ は B2C 寄りで業務に向かない。
5. **サイドバーは main より「沈ませる」**。背景を薄ウォームグレーにし、main canvas を相対的に "立たせる"。

---

## 2. ユーザーフィードバックへの判定

> 「ベージュ基調に白抜きカードは弱い」「赤色が微妙」

### 判定: フィードバック完全に正しい。暫定パレットの方向は正解、ただし 3 点の追加修正で完成度を上げる。

| 観点 | 暫定 | 判定 | 推奨 |
|---|---|---|---|
| 基調 | 純白 #FFFFFF | OK（2026 標準） | そのまま |
| sidebar | #F9FAFB | OK だがクールすぎる印象 | **#F7F7F5（わずかに warm）に微調整**（LP の古紙感を 5% だけ持ち越し） |
| accent (CTA) | #18181B near-black | OK | そのまま |
| primary (brand 緑) | #2C4A3B | **白背景 9.77:1 で読みやすさ十分**。沈むのは「同色面積が小さすぎて存在感が消える」だけ | active state には pair の薄背景（**#ECF3EE**）を必ず添える。緑単色では使わない |
| primary deep（強調用） | 未定義 | 必要 | **#1F3A2D** を新設。active state の文字色や、グラフの強調にだけ使う |
| border | #E5E7EB | OK | そのまま、ただし `rgba(17, 24, 39, 0.08)` 由来として opacity 8% 相当と理解する |
| 赤 | 廃止 | **正解。ダッシュボードに赤は不要**。destructive action のみ #B91C1C のラベル色で出す（塗り禁止） | そのまま |

### "ベージュ基調に白抜きカード" が弱かった理由（art-director 解釈）
- 古紙ベージュ #F5F0E6 と純白カードはコントラスト比約 1.07:1 で、境界線は実質ゼロ。border が無いと「カードが浮いていない」**けど浮かせる必要もない**業務画面では、結果「のっぺり」だけが残る。
- これは LP では成立する（広告的余白がベージュを生かす）が、業務密度が高いダッシュボードでは「面が立ち上がっていない」と感じる。
- **解決: ベージュは捨てる→純白基調にする**だけで「カードがちゃんと見える」状態になる。すでに正しい方向。

### "赤色が微妙" だった理由
- LP の朱赤 #B83A2E は「Before の損失」「失った機会」のドラマ色。**業務ダッシュボードに毎日いる支配人/キャディがこれを目に入れ続けるとストレスになる**。
- 一般的に赤はエラー・取消・キャンセルなどの **マイナス行動の最後の確認** にしか使わない（Modal 内のみ）。常設の destructive action は赤塗りせず、ghost button + 文字色 #B91C1C 程度に抑える。

---

## 3. Color Palette 完全版（最終トークン）

### 3-1. Surface（背景）

| Token | Hex | 用途 | 白との比 |
|---|---|---|---|
| `--color-bg` | `#FFFFFF` | アプリ全体の最下層、main canvas | 1.00 |
| `--color-surface` | `#FFFFFF` | card / table / drawer の面 | 1.00 |
| `--color-surface-alt` | `#F7F7F5` | sidebar、table thead、入力フォームの薄背景。**わずかに warm（古紙の名残）** | 1.04 |
| `--color-surface-sunken` | `#F2F2EE` | section の最奥、drawer の背景仕切り | 1.10 |

**推奨修正**: 現在 `#F9FAFB`（Tailwind gray-50, クール寄り）→ **`#F7F7F5`（わずかに温かみのあるニュートラル）**。LP の古紙感と完全分離せず、5% だけ持ち越すと「同じプロダクトの裏側」感が出る。

### 3-2. Text / Ink

| Token | Hex | 用途 | 白との比 |
|---|---|---|---|
| `--color-ink` | `#1A1A1A` | 本文・見出し（near-black） | 16.10:1 (AAA) |
| `--color-ink-sub` | `#5C5C5C` | サブテキスト、meta、placeholder | 6.69:1 (AAA) |
| `--color-ink-mute` | `#9CA3AF` | disable、ヒント、empty 状態の本文 | 2.54:1（非テキスト UI 用、本文には使わない） |

### 3-3. Border / Divider

| Token | Hex | 用途 |
|---|---|---|
| `--color-border` | `#E5E7EB` | card / table / input 全部の 1px ボーダー（= rgba(17,24,39,0.08) 相当） |
| `--color-border-strong` | `#D1D5DB` | hover / focus 時のボーダー強化、drawer の仕切り |
| `--color-divider` | `rgba(17,24,39,0.06)` | table row 間など「もっと薄く」したい時 |

### 3-4. Action（CTA）

| Token | Hex | 用途 | 白との比 |
|---|---|---|---|
| `--color-accent` | `#18181B` | primary button の塗り、強い CTA | 17.72:1 (AAA) |
| `--color-accent-deep` | `#0A0A0A` | accent の hover 時 | 19.86:1 |
| `--color-accent-soft` | `#F3F4F6` | secondary button の hover 背景 | — |

### 3-5. Brand（苔緑、息継ぎ）

| Token | Hex | 用途 | 白との比 |
|---|---|---|---|
| `--color-primary` | `#2C4A3B` | ロゴ、sidebar active 文字色、リンク、確定バッジの文字色 | 9.77:1 (AAA) |
| `--color-primary-deep` | `#1F3A2D` | 強調したい時の primary（KPI 数字、グラフの主線）。**コントラスト 12.34:1** | 12.34:1 |
| `--color-primary-soft-bg` | `#ECF3EE` | sidebar active item の背景、確定バッジの背景、カレンダー確定セルの背景 | 1.10 |
| `--color-primary-ring` | `rgba(44, 74, 59, 0.18)` | focus ring、active item の左 2px ボーダー |

**重要**: primary を**単色で背景塗り**しない。必ず "deep 文字色 + soft-bg" のペアで使う。これで暫定 #2C4A3B が「弱い」問題は消える。

### 3-6. Status（4 色のみ。赤の常設は禁止）

| 状態 | bg | text/deep | 用途 |
|---|---|---|---|
| 確定 (success) | `#ECF3EE` | `#1F3A2D` | 予約確定、キャディ稼働中、完了 |
| 仮 (warn) | `#FEF3C7` | `#92400E` | 仮予約、確認待ち、残少 |
| 情報 (info) | `#DBEAFE` | `#1E40AF` | 完了、通知、システムメッセージ |
| 不可/休止 (mute) | `#F3F4F6` | `#6B7280` | キャンセル、休日、不可セル |
| 取消 (destructive) | `#FEE2E2` | `#991B1B` | **modal 内・取消ボタンのみ**。常設バッジには使わない |

すべて WCAG AA / AAA をクリア（計算済み: warn 6.37、info 7.15、error 6.80）。

### 3-7. 配色比率の鉄則

ダッシュボード 1 画面あたりの面積比率:

```
白 (bg + surface)     : 70-80%
薄ウォームグレー (surface-alt) : 12-18%（sidebar + thead + input）
near-black (ink + accent button)  : 6-10%（テキスト + CTA）
苔緑 (primary + soft-bg)   : 2-5%（active item + 確定バッジ）
status colors  : 1-3%（バッジ・カレンダーの状態セル）
```

5% を超えてブランド緑を入れると業務画面として騒がしくなる。

---

## 4. Shadow / Border / Radius の整え方

### 4-1. Shadow ルール

**原則: card / table / KPI / sidebar に shadow を使わない。border 1px のみ。** 浮かせる必要のあるもの（drawer / popover / toast / modal）だけ shadow を許可する。

| 用途 | 値 | 強さ |
|---|---|---|
| card / KPI / table | `none` | 使わない |
| sidebar | `none` | border-right のみ |
| header | `none` | border-bottom のみ |
| drawer | `-8px 0 24px rgba(17, 24, 39, 0.06)` | 控えめ |
| popover / dropdown | `0 4px 12px rgba(17, 24, 39, 0.08), 0 1px 2px rgba(17, 24, 39, 0.04)` | 中 |
| modal | `0 16px 40px rgba(17, 24, 39, 0.12)` | やや強 |
| toast | `0 8px 20px rgba(17, 24, 39, 0.10)` | 中 |

**やってはいけない**: card 全体に `box-shadow: 0 4px 12px rgba(0,0,0,0.1)` 等の "B2C 風の浮かせ"。Linear / Vercel が「border 1px のみで見せる」事に倣う。

### 4-2. Border ルール

- すべての構造物（card, table, input, sidebar, header）は **1px solid `--color-border`** で輪郭。
- hover/focus は border 色を `--color-border-strong` (#D1D5DB) に変える。色塗りで強調しない。
- table の行間は border-bottom 1px のみ、zebra 禁止（design-strategist D-04 を継承）。

### 4-3. Radius スケール

| Token | 値 | 用途 |
|---|---|---|
| `--radius-sm` | `4px` | badge, small chip, focus ring |
| `--radius-md` | `6px` | button, input, KPI card, booking card |
| `--radius-lg` | `8px` | card, table 外枠, drawer, modal |
| `--radius-xl` | `12px` | empty state illustration container |
| `--radius-pill` | `999px` | avatar, dot |

**統一原則**: 同一画面内で 6px と 8px を混ぜない。card 外枠を 8px にしたら、内側の KPI/table も 8px、ボタンは 6px、badge は 4px に固定。

---

## 5. Visual Spec：主要コンポーネント

### 5-1. KPI Card

```css
.kpi-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);   /* 6px */
  padding: 20px 20px 16px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-height: 96px;
  transition: border-color 150ms ease-out;
}
.kpi-card:hover {
  border-color: var(--color-border-strong);
}
.kpi-card__label {
  font-size: 13px;
  color: var(--color-ink-sub);
  font-weight: 500;
  letter-spacing: 0.01em;
}
.kpi-card__value {
  font-size: 32px;
  line-height: 1.05;
  font-weight: 700;
  color: var(--color-ink);
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.02em;
}
.kpi-card__value--brand { color: var(--color-primary-deep); }  /* 主要指標だけ深い苔緑 */
.kpi-card__unit { font-size: 16px; color: var(--color-ink-sub); margin-left: 2px; font-weight: 500; }
.kpi-card__delta {
  font-size: 12px;
  color: var(--color-ink-mute);
  display: inline-flex; align-items: center; gap: 4px;
}
.kpi-card__delta--up   { color: var(--color-primary); }
.kpi-card__delta--down { color: var(--color-ink-sub); }  /* 赤は使わない */
```

**ポイント**:
- 数字は 32px / weight 700 / tabular-nums で「**業務数字は読みやすく**」。
- 1 つだけ主要指標（例: 今週の予約数）の数字色を `--color-primary-deep` にして "これがこのカードの主役" を出す。残り 3 個は `--color-ink`（黒）でフラット。
- 差分 (delta) は赤を使わない。下降も `--color-ink-sub` の灰色で淡々と。

### 5-2. Data Table

```css
.dash-table {
  width: 100%;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);    /* 8px */
  border-collapse: separate;
  border-spacing: 0;
  overflow: hidden;
}
.dash-table thead th {
  height: 40px;
  padding: 0 16px;
  background: var(--color-surface-alt);
  color: var(--color-ink-sub);
  font-size: 12px;
  font-weight: 600;
  text-align: left;
  letter-spacing: 0.04em;
  text-transform: uppercase;        /* 業務 SaaS では small caps 風が読みやすい */
  border-bottom: 1px solid var(--color-border);
}
.dash-table tbody td {
  height: 48px;
  padding: 0 16px;
  font-size: 14px;
  color: var(--color-ink);
  border-bottom: 1px solid var(--color-border);
}
.dash-table tbody tr:last-child td { border-bottom: 0; }
.dash-table tbody tr {
  transition: background 100ms ease-out;
}
.dash-table tbody tr:hover {
  background: var(--color-surface-alt);
  cursor: pointer;
}
.dash-table .num { text-align: right; font-variant-numeric: tabular-nums; }
```

**ポイント**:
- thead は uppercase + 12px + letter-spacing 0.04em で「データの目次」と分かる。これは Linear / Stripe / Supabase 共通。
- 行高 48px（design-strategist D-04 / D-06 と一致）。
- zebra なし、hover でのみ背景変化。
- 列内に badge を置く場合は inline-flex で行高を保つ。

### 5-3. Status Badge

```css
.badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  height: 22px;
  padding: 0 8px;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.01em;
  border-radius: var(--radius-sm);   /* 4px */
  white-space: nowrap;
  line-height: 1;
}
.badge::before {
  content: "";
  width: 6px; height: 6px;
  border-radius: 50%;
  background: currentColor;
}
.badge--confirmed { background: #ECF3EE; color: #1F3A2D; }
.badge--pending   { background: #FEF3C7; color: #92400E; }
.badge--completed { background: #DBEAFE; color: #1E40AF; }
.badge--cancelled { background: #F3F4F6; color: #6B7280; }
.badge--error     { background: #FEE2E2; color: #991B1B; }   /* drawer/modal 内のみ */
```

**ポイント**: 高さ 22px 固定。テーブル行内に置いても行高が崩れない。dot + label の組み合わせで色覚多様性対応。

### 5-4. Button Hierarchy

3 階層 + アイコンボタンの 4 種類。**これ以上増やさない**。

```css
/* Primary: 最も強い CTA。1 ビューに 1 つだけ */
.btn--primary {
  background: var(--color-accent);          /* #18181B near-black */
  color: #FFFFFF;
  border: 1px solid var(--color-accent);
  border-radius: var(--radius-md);          /* 6px */
  height: 36px;
  padding: 0 14px;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.01em;
  transition: background 100ms ease-out;
}
.btn--primary:hover { background: var(--color-accent-deep); border-color: var(--color-accent-deep); }
.btn--primary:focus-visible {
  outline: 2px solid var(--color-primary-ring);
  outline-offset: 2px;
}

/* Secondary: outline タイプ */
.btn--secondary {
  background: var(--color-surface);
  color: var(--color-ink);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  height: 36px;
  padding: 0 14px;
  font-size: 14px;
  font-weight: 500;
}
.btn--secondary:hover {
  background: var(--color-surface-alt);
  border-color: var(--color-border-strong);
}

/* Ghost: 装飾なし、文字のみ */
.btn--ghost {
  background: transparent;
  color: var(--color-ink-sub);
  border: 1px solid transparent;
  border-radius: var(--radius-md);
  height: 32px;
  padding: 0 10px;
  font-size: 13px;
  font-weight: 500;
}
.btn--ghost:hover { color: var(--color-ink); background: var(--color-surface-alt); }

/* Icon button */
.btn--icon {
  width: 32px; height: 32px;
  border-radius: var(--radius-md);
  background: transparent;
  border: 1px solid transparent;
  color: var(--color-ink-sub);
  display: inline-flex; align-items: center; justify-content: center;
}
.btn--icon:hover { background: var(--color-surface-alt); color: var(--color-ink); }

/* Danger: destructive 専用、塗りではなく文字色のみ */
.btn--danger {
  background: transparent;
  color: #991B1B;
  border: 1px solid #FECACA;
  border-radius: var(--radius-md);
  height: 36px; padding: 0 14px;
  font-size: 14px; font-weight: 500;
}
.btn--danger:hover { background: #FEE2E2; }
```

**注意**: ブランドの苔緑をボタン背景に使わない。常に near-black が primary。緑は active state / バッジでのみ。

### 5-5. Sidebar Active State

```css
.dash-sidebar {
  background: var(--color-surface-alt);       /* #F7F7F5 */
  border-right: 1px solid var(--color-border);
  padding: 16px 12px;
  width: 240px;
  height: 100vh;
  position: sticky; top: 0;
  overflow-y: auto;
}

.dash-nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  height: 36px;
  padding: 0 10px;
  border-radius: var(--radius-md);
  color: var(--color-ink-sub);
  font-size: 14px;
  font-weight: 500;
  text-decoration: none;
  position: relative;
  transition: background 100ms ease-out, color 100ms ease-out;
}
.dash-nav-item__icon {
  width: 16px; height: 16px;
  flex-shrink: 0;
  color: var(--color-ink-mute);
}

.dash-nav-item:hover {
  background: rgba(17, 24, 39, 0.04);
  color: var(--color-ink);
}
.dash-nav-item:hover .dash-nav-item__icon { color: var(--color-ink-sub); }

.dash-nav-item.is-active {
  background: var(--color-primary-soft-bg);   /* #ECF3EE */
  color: var(--color-primary-deep);           /* #1F3A2D */
  font-weight: 600;
}
.dash-nav-item.is-active .dash-nav-item__icon {
  color: var(--color-primary);                /* #2C4A3B */
}
/* active を 3 重に表現: 背景 + 文字色 + 左の 2px バー */
.dash-nav-item.is-active::before {
  content: "";
  position: absolute;
  left: -12px;
  top: 6px; bottom: 6px;
  width: 2px;
  background: var(--color-primary);
  border-radius: 0 2px 2px 0;
}
```

**動きの見せ方**:
- hover: 100ms で背景が `rgba(17,24,39,0.04)` に。色がつかない・transform しない・shadow も付かない。**控えめに反応する**。
- active: 背景 #ECF3EE + 文字 #1F3A2D + 左 2px の苔緑バー。**3 重表現** で色覚多様性 + 50-60 代男性が一瞥で分かる。
- アイコンは active 時のみ苔緑 #2C4A3B に染まる。これで「いまここ」感がはっきり出る。

### 5-6. Header

```css
.dash-header {
  height: 56px;
  padding: 0 24px;
  background: var(--color-surface);
  border-bottom: 1px solid var(--color-border);
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: sticky; top: 0;
  z-index: 50;
}
.dash-header__title {
  font-size: 16px;
  font-weight: 600;
  color: var(--color-ink);
  letter-spacing: -0.01em;
}
.dash-header__actions { display: flex; gap: 8px; align-items: center; }
```

shadow 禁止、border-bottom のみ。スクロールしても影が落ちない（sticky で位置だけ固定）。

### 5-7. Empty State

```css
.empty {
  background: var(--color-surface);
  border: 1px dashed var(--color-border);     /* dashed で「空である」感を出す */
  border-radius: var(--radius-lg);
  padding: 56px 24px;
  text-align: center;
}
.empty__icon-wrap {
  width: 56px; height: 56px;
  margin: 0 auto 16px;
  background: var(--color-surface-alt);
  border-radius: var(--radius-xl);            /* 12px、優しい角丸 */
  display: flex; align-items: center; justify-content: center;
  color: var(--color-ink-mute);
}
.empty__icon { width: 24px; height: 24px; stroke-width: 1.5; }
.empty__title {
  font-size: 16px; font-weight: 600;
  color: var(--color-ink);
  margin-bottom: 6px;
}
.empty__desc {
  font-size: 13px;
  color: var(--color-ink-sub);
  max-width: 320px;
  margin: 0 auto 20px;
  line-height: 1.5;
}
```

**絵的な処理（重要）**:
- イラストは入れない。Linear / Vercel 流に **アイコン 1 個 + コピー + 1 CTA** のミニマル構成。
- ボーダーを `dashed` にすることで「ここに何かが入る場所だが、まだ空」と視覚的に伝わる。実 card の solid border と意味分離。
- アイコン背景の薄グレー丸 (`--color-surface-alt`、12px 角丸) で柔らかさを出す。**かわいくしすぎない**。
- コピーは warm に。「今週はまだ予約がありません」のような事実 + 「空きキャディを探す」のような次の一手。CTA は `.btn--secondary`（outline）か `.btn--ghost`。primary 黒は強すぎる場合があるので、空状態では outline が無難。

---

## 6. 動きのプリンシプル（micro-interaction）

- すべての transition は **100-150ms ease-out**。それ以上長くしない。業務 SaaS で動きが重いとストレスになる。
- `transform: translateY` / `scale` は **使わない**（design-strategist D-02 を継承）。動きで装飾せず、色とボーダーで状態を伝える。
- focus ring は `outline: 2px solid rgba(44,74,59,0.18)` + `outline-offset: 2px`。**苔緑系 18% 不透明で柔らかく**、Tab キーナビゲーションで主役を奪わない。
- toast: 右下 fade-in 200ms、auto-dismiss 4000ms、`-8px 0` の進入。

---

## 7. タイポ精密化（dashboard 用に追加）

LP の `--fs-body: clamp(16px, ..., 17px)` は dashboard では大きすぎる行もある。**dashboard 専用に固定 px を追加**:

```css
:root {
  --dash-fs-display: 32px;       /* KPI 数字 */
  --dash-fs-h1: 20px;            /* page title */
  --dash-fs-h2: 16px;            /* section title */
  --dash-fs-body: 14px;          /* table cell, form input, badge */
  --dash-fs-caption: 13px;       /* sidebar item, meta */
  --dash-fs-micro: 12px;         /* thead label, hint */

  --dash-fw-regular: 400;
  --dash-fw-medium: 500;         /* sidebar item, button */
  --dash-fw-semibold: 600;       /* h2, active item, badge, thead */
  --dash-fw-bold: 700;           /* KPI value */

  --dash-ls-tight: -0.02em;      /* KPI 数字 */
  --dash-ls-default: -0.005em;   /* 本文 */
  --dash-ls-wide: 0.04em;        /* thead, label uppercase */
}
```

**フォント切り替えの原則**:
- 業務画面は Inter（数字の tabular-nums が美しい）を主にし、Noto Sans JP を fallback で日本語に当てる。
- 数字を含むセル/KPI は必ず `font-variant-numeric: tabular-nums`。「12」「8」が縦に揃う。

---

## 8. 画面別の見え方ガイド

### 8-1. golf_dashboard.html
- 左 sidebar（240px, #F7F7F5）、上 header 56px、main canvas 純白。
- 上部に KPI 4 個（今週の予約 / 来週の予約 / 待機キャディ / 研修希望）。1 個目だけ数字色 `--color-primary-deep`、残り 3 個は黒。
- 下に「今週の予約」テーブル（行高 48px、確定/仮予約 badge 入り）。
- 右上 header に通知アイコン + ゴルフ場名 + ログアウト ghost ボタン。

### 8-2. caddy_dashboard.html
- 同じ shell。KPI は（今週の予約 / 今月の見込収入 / 未対応の研修 / 未読メッセージ）。
- 見込収入の数字だけ `--color-primary-deep`、ほかは黒。
- KPI 下に「次回の予約」booking-card（横長 1 列）+「あなたを指名したゴルフ場」person-card grid。

### 8-3. profile.html
- sidebar 同じ。main は 1 列固定 720px の card 形式フォーム。
- form input は 36px 高 / 6px 角丸 / 1px ボーダー、focus 時 2px 苔緑 outline。
- 保存ボタンは右下 primary black。「キャンセル」は ghost。

### 8-4. dashboard.html（ロール選択 or ルート）
- ログイン後最初に着地。card 2 枚（ゴルフ場として続ける / キャディとして続ける）の選択画面、または最後に使ったロールに自動遷移。
- 中央寄せ、max-width 480px、card は radius-lg + border 1px。

### 8-5. password.html
- 中央寄せ 1 列、card 1 枚、形式は profile と同じフォームトーン。
- 「変更する」ボタンが primary black。

---

## 9. 既存暫定パレットへの最終差分

`dashboard-framework.css` の現状（さっき暫定修正済み）に対する追加修正箇所:

```diff
:root {
-  --color-surface-alt:     #F9FAFB;
+  --color-surface-alt:     #F7F7F5;   /* わずかに warm、LP の古紙感を 5% 残す */
+  --color-surface-sunken:  #F2F2EE;   /* 新規: drawer 仕切り等 */

-  --color-border:          #E5E7EB;
+  --color-border:          #E5E7EB;   /* そのまま */
+  --color-border-strong:   #D1D5DB;   /* 新規: hover/focus 時の border 強化 */

-  /* primary は LP から継承（#2f8f2f）*/
+  --color-primary:         #2C4A3B;   /* dashboard 専用 override、深い苔緑 */
+  --color-primary-deep:    #1F3A2D;   /* 新規: 強調用、KPI 数字色等 */
+  --color-primary-soft-bg: #ECF3EE;   /* 上書き: より落ち着いた緑薄背景 */
+  --color-primary-ring:    rgba(44, 74, 59, 0.18);   /* 新規: focus ring */
}
```

**注意**: LP の framework.css の `--color-primary: #2f8f2f` は LP では維持。dashboard-framework.css 側でのみ `#2C4A3B` に上書きすることで「LP は鮮緑、dashboard は深い苔緑」のトーン分離が完成する。

---

## 10. visual-implementer への引き継ぎ（チェックリスト追記）

dashboard-components.md の §16 チェックリストに追加:

- [ ] `--color-surface-alt` を `#F7F7F5` に変更
- [ ] `--color-border-strong` `#D1D5DB` を追加し、hover/focus 時のボーダー強化に使う
- [ ] `--color-primary-deep` `#1F3A2D` を追加し、KPI 数字の主役 1 個と active 文字色に適用
- [ ] sidebar active item に左 2px 苔緑バー（`::before`）を追加
- [ ] KPI card 1 枚目（最重要指標）の数字色だけ `--color-primary-deep`、残り 3 枚は `--color-ink`
- [ ] thead を uppercase + 12px + letter-spacing 0.04em に
- [ ] empty state は `border: 1px dashed` に変更し、アイコン背景に薄丸 box を入れる
- [ ] shadow は drawer / popover / modal / toast 以外すべて none
- [ ] `.btn--primary` は `#18181B`、緑塗りボタンは存在しない
- [ ] 削除ボタンは赤塗りではなく、border `#FECACA` + 文字 `#991B1B` の outline 形式
- [ ] focus ring を `outline: 2px solid rgba(44,74,59,0.18); outline-offset: 2px` に統一

---

## 11. 観察したサイト一覧（最終）

| # | サイト | 役割 |
|---|---|---|
| 1 | Linear (linear.app, UI Refresh 2026-03) | sidebar を沈ませる + 1px border + ほぼ無彩 |
| 2 | Vercel (Dashboard Redesign 2026-02) | 純白 + #000 ボタン + grid line を 10-20% 不透明に |
| 3 | Cal.com | off-white に近い純白、ブランド黒 + 緑は確定状態のみ |
| 4 | Stripe Dashboard | 淡グレー sidebar + violet は最小量 + card に 1px shadow |
| 5 | Resend | モノクロ、black solid CTA、green は send 状態のみ |
| 6 | Supabase Studio | 白 + brand green は active と logo のみ、UI 内は黒 |
| 7 | Notion 業務側 | warm off-white、hairline border、padding 寛大 |

これに加え、design-strategist が観察した 22 件（dashboard-research.md §1）のパターン抽出も並列で取り込み済み。

---

## 12. art-director からの最終判定（一行）

> **暫定パレットは方向性 100% 正解。修正は (a) sidebar を `#F7F7F5` に温め、(b) `--color-primary-deep #1F3A2D` を新設して KPI と active に効かせ、(c) sidebar active に左 2px 苔緑バーを足す、の 3 点のみ。これで「白基調＋深緑息継ぎ＋黒 CTA」のトーンが Linear / Vercel と並ぶ。**
