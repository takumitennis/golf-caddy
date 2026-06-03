# Caddygate Design Principles（14 原則）

作成: design-strategist
作成日: 2026-05-31
位置付け: research.md からの「型」抽出と統合。visual-implementer はこの 14 原則を順守して実装する。

## 0. 設計哲学（1 行）

> **「現代ミニマル × 日本 B2B 実用感 × 名門コースの落ち着き」を、装飾ではなく余白と階層差で表現する。**

50-60代男性ゴルフ場支配人が、3秒で「ちゃんとした企業のサービスだ」と判定でき、5分間スクロールしても読み疲れない設計。

---

## 14 原則 一覧

| # | 原則 | 一言で |
|---|---|---|
| P-01 | カラーは 3 色構成（背景・主役・差し色） | 古紙オフホワイト 70% / 苔緑 20% / 朱 10% |
| P-02 | 8px ベースのスペーシングトークン | 4/8/12/16/24/32/48/64/80/96/120 の固定スケール |
| P-03 | セクション間余白は desktop 96-120px / mobile 56-72px | 「沈黙の余白」が信頼を作る |
| P-04 | サンセリフ一本（Inter + Noto Sans JP）、明朝禁止 | 「厳か too much」を再発させない |
| P-05 | タイポは clamp() レスポンシブ、本文 16-17px 下限 | 50-60代男性可読性 |
| P-06 | 日本語改行は見出しと本文で出し分け | 見出し keep-all / 本文 anywhere |
| P-07 | ボタンは near-zero radius（4-6px）、ピル禁止 | Vercel/Linear/Stripe 系の硬質感 |
| P-08 | グラデーション・シャドウは原則禁止、フラット運用 | B2C の煽り感を排除 |
| P-09 | コンテンツ最大幅は 1120px、内 padding 24px | 文字 1行 70-80字に収まる読みやすい幅 |
| P-10 | アイコンは Lucide 一本（line, 1.5-2px stroke） | テイストの混在を防ぐ |
| P-11 | データの強調は色ではなく字サイズと weight で | 朱は CTA とハイライト数字のみ |
| P-12 | Pricing 3列は「左列（ファウンダーズ）強調」の変則型 | center-stage 効果を反転利用 |
| P-13 | FAQ は `<details><summary>` ネイティブで素直に開閉 | JS なし、派手なアニメ NG |
| P-14 | フッターは 4 列・法人取引仕様、独自ドメインメール必須 | FB-09 を design-system に格上げ |

---

## P-01. カラーは 3 色構成（背景・主役・差し色）+ 中性 4 色

### Why
brand-strategist 確定の **苔緑 #2C4A3B / 古紙オフホワイト #F5F0E6 / 朱 #B83A2E** の三本柱。Vercel が純黒 #000 + 純白 #FFF + 単一アクセントで成立しているように、**3 色＋中性＋状態色だけ**で 1 枚 LP は完全に成立する。色を増やすと「ガチャガチャした個人プロジェクト感」が出る（FB-13 連動）。

### 実装パターン
```css
:root {
  /* 主役 3 色 */
  --color-bg: #F5F0E6;            /* 古紙オフホワイト（ページ背景） */
  --color-primary: #2C4A3B;       /* 苔緑（H1/H2/CTA背景/ロゴ） */
  --color-accent: #B83A2E;        /* 朱（CTA primary/ハイライト数字） */

  /* 中性 5 色 */
  --color-ink: #1A1A1A;           /* 墨（本文文字） */
  --color-ink-sub: #5C5C5C;       /* 薄墨（キャプション） */
  --color-ink-mute: #8A8A8A;      /* 注釈・プレースホルダ */
  --color-border: #E8E2D5;        /* 生成（区切り線・カードボーダー） */
  --color-surface: #FFFFFF;       /* 純白（カード背景・モーダル） */

  /* 補助・状態 */
  --color-primary-soft: #7A9A6E;  /* 若葉（成功・補助グリーン） */
  --color-primary-deep: #1F3D2B;  /* 苔緑ダーク（ホバー） */
  --color-accent-deep: #8B2C2C;   /* 朱ダーク（ホバー・危険） */
  --color-warn: #B89A4E;          /* 辛子（注意） */
  --color-info: #A88C5F;          /* 金茶（補助アクセント・小バッジ） */
}
```

### 配色比率（必須）
- 古紙オフホワイト（背景）: **70%**
- 苔緑（H1/H2/CTA背景/ロゴ）: **20%**
- 朱（CTA primary/ハイライト数字のみ）: **10%**
- 金茶 / 若葉は装飾上のスパイスとして 1-2 箇所のみ

---

## P-02. 8px ベースのスペーシングトークン

### Why
Notion を始め現代 SaaS の事実上の標準。「23px か 24px か」を毎回考えなくて済むためデザイン速度が上がり、CSS の不整合（既存サイトの `font-size: 150%` + 「約 2/3」のような重層）を構造的に防ぐ（FB-18 連動）。

### 実装パターン
```css
:root {
  --space-0: 0;
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 24px;
  --space-6: 32px;
  --space-7: 48px;
  --space-8: 64px;
  --space-9: 80px;
  --space-10: 96px;
  --space-11: 120px;
  --space-12: 160px;
}
```

カードの内 padding、ボタンの padding、要素間の gap、すべてこのトークンから選ぶ。トークン外の値（17px とか 23px）は原則禁止。

---

## P-03. セクション間余白は desktop 96-120px / mobile 56-72px

### Why
Vercel が「padding 24px ではなく 96px」と明言する規律。日本 B2B SaaS（SmartHR/freee/Sansan）も同等。brand-identity 原則5「沈黙」と完全整合。ターゲットの 50-60代男性は情報過密に弱く、**余白が「整理されている安心感」を作る**。

### 実装パターン
```css
.section { padding-block: var(--space-11); }        /* desktop 120px */
.section--compact { padding-block: var(--space-10); } /* desktop 96px */

@media (max-width: 767px) {
  .section { padding-block: var(--space-8); }       /* mobile 64px */
  .section--compact { padding-block: var(--space-7); } /* mobile 48px */
}
```

---

## P-04. サンセリフ一本（Inter + Noto Sans JP）、明朝禁止

### Why
brand-strategist 当初の明朝路線は user 判定「厳か too much」で破棄済。Inter は SaaS 業界の事実上の標準。Noto Sans JP は **デジタル庁デザインシステムが採用**する公的可読性標準。x-height が近く混植のズレが最小。

### 実装パターン
```css
:root {
  --font-sans: 'Inter', 'Noto Sans JP', -apple-system, BlinkMacSystemFont,
               'Hiragino Sans', 'Hiragino Kaku Gothic ProN', Meiryo, system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', 'SF Mono', Menlo, Consolas, monospace; /* 数字料金等で必要時 */
}

body {
  font-family: var(--font-sans);
  font-feature-settings: "palt"; /* 和文プロポーショナルメトリクスで字間最適化 */
}
```

`<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>` で Google Fonts を高速読み込み。

### 絶対禁止
- Cormorant Garamond / Playfair Display / Noto Serif JP / 游明朝
- 装飾フォント（手書き風・極太・スクリプト）

---

## P-05. タイポは clamp() レスポンシブ、本文 16-17px 下限

### Why
固定値（H1: 48px）で組むと、mobile で巨大すぎる／desktop で小さすぎる事故が起きる。clamp() で **最小・推奨・最大** を一行で書くのが 2026 年の標準。ターゲット 50-60代男性に本文 14px は読みづらすぎる（FB-18 連動）。

### 実装パターン
```css
:root {
  /* clamp(min, fluid, max) */
  --fs-display: clamp(2rem, 5.5vw, 3.5rem);       /* 32-56px H1 */
  --fs-h1:      clamp(1.75rem, 4vw, 2.5rem);       /* 28-40px セクションH1 */
  --fs-h2:      clamp(1.5rem, 3vw, 2rem);          /* 24-32px H2 */
  --fs-h3:      clamp(1.25rem, 2vw, 1.5rem);       /* 20-24px H3 */
  --fs-lead:    clamp(1.0625rem, 1.6vw, 1.25rem);  /* 17-20px リード */
  --fs-body:    clamp(1rem, 1.4vw, 1.0625rem);     /* 16-17px 本文 */
  --fs-small:   0.875rem;                          /* 14px キャプション */
  --fs-micro:   0.75rem;                           /* 12px 注釈 */

  /* line-height */
  --lh-tight: 1.2;    /* H1/H2 */
  --lh-snug: 1.4;     /* H3 / リード */
  --lh-normal: 1.75;  /* 本文（和文標準） */
  --lh-loose: 2.0;    /* 余韻を出す場合のみ */

  /* letter-spacing（和文中心なので控えめ） */
  --ls-tight: -0.02em;
  --ls-normal: -0.01em;
  --ls-wide: 0.02em;
}
```

---

## P-06. 日本語改行は見出しと本文で出し分け

### Why
ICS MEDIA 2024 解説のベストプラクティス。**見出しは句読点で改行候補を作りたい**（`keep-all`）、**本文は単語の途中でも自然に折り返したい**（`anywhere`）。両方に `keep-all` を当てると本文で長い英単語がはみ出す。

### 実装パターン
```css
.h1, .h2, .h3,
.hero-headline {
  word-break: keep-all;
  overflow-wrap: break-word;
  line-break: strict;
}

body, p, .body-text {
  word-break: normal;
  overflow-wrap: anywhere;
  line-break: strict;
}
```

加えて、ヒーロー H1 のような **意図的な 2 行構成**は `<br>` で明示。それ以外の本文の改行は CSS の max-width で制御。

---

## P-07. ボタンは near-zero radius（4-6px）、ピル禁止

### Why
Vercel/Linear/Stripe いずれも border-radius 0-6px。**ピル（999px）は B2C SaaS や消費者向けアプリ寄り**で、B2B の硬質感に合わない。

### 実装パターン
```css
:root {
  --radius-none: 0;
  --radius-sm: 4px;       /* ボタン・小バッジ */
  --radius-md: 6px;       /* カード・入力フィールド */
  --radius-lg: 8px;       /* 大きなパネル */
  --radius-pill: 999px;   /* 使うのは「残り◯枠」バッジ程度に限定 */
}

.btn {
  border-radius: var(--radius-sm);  /* 4px */
  padding: 14px 28px;
  font-weight: 600;
  letter-spacing: var(--ls-normal);
  transition: background-color 150ms ease-out, transform 100ms ease-out;
}
```

---

## P-08. グラデーション・シャドウは原則禁止、フラット運用

### Why
visual-assets-spec B-5 NG リスト遵守。グラデは AI 量産 LP の典型で、Caddygate が避けたい「個人プロジェクト感」を増幅する。シャドウも控えめ。

### 実装パターン
```css
:root {
  --shadow-none: none;
  --shadow-subtle: 0 1px 2px rgba(26, 26, 26, 0.04);  /* ほぼ感じない程度 */
  --shadow-card: 0 1px 3px rgba(26, 26, 26, 0.06), 0 1px 2px rgba(26, 26, 26, 0.04);
  /* これ以上は使わない */
}

/* カードは shadow ではなく border + bg で立体化 */
.card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-subtle);
}
```

---

## P-09. コンテンツ最大幅は 1120px、内 padding 24px

### Why
1 行 70-80 字（和文 35-40 字）が読みやすい上限。1280px や 1440px だと line が長くなりすぎる。1120px は SmartHR/freee も近い値。

### 実装パターン
```css
:root {
  --container-max: 1120px;
  --container-padding-x: 24px;
}

.container {
  max-width: var(--container-max);
  margin-inline: auto;
  padding-inline: var(--container-padding-x);
}

/* 本文ブロック（より狭く） */
.prose { max-width: 720px; }
```

---

## P-10. アイコンは Lucide 一本（line, 1.5-2px stroke）

### Why
visual-assets-spec A-11 で Lucide 採用推奨済。AI で生成したアイコンセットはテイストが揃わない（FB-13 既往問題）。Lucide は MIT で 1000+ 個揃い、線幅・サイズが完全に統一。

### 実装パターン
```html
<!-- Lucide CDN -->
<script src="https://unpkg.com/lucide@latest"></script>
<i data-lucide="check-circle" class="icon"></i>

<script>lucide.createIcons();</script>
```

```css
.icon {
  width: 24px; height: 24px;
  stroke-width: 1.75;
  color: var(--color-primary);
}
```

---

## P-11. データの強調は色ではなく字サイズと weight で

### Why
色（赤・黄）で強調すると煽り感が出る。Linear/Vercel は基本モノクロで、サイズ差と font-weight 差で階層を作る。Caddygate は朱 #B83A2E を CTA とハイライト数字（「600 万円」「¥2,500」）の **2 種類だけ**に絞る。

### 実装パターン
- 「600 万円」のような損失額: `font-size: var(--fs-display); color: var(--color-accent); font-weight: 700;`
- 通常の数字: `font-weight: 600; color: var(--color-ink);` で済ます
- 強調枠（苔緑塗りつぶし + 古紙文字）は 1 ページ 1-2 個まで

---

## P-12. Pricing 3 列は「左列（ファウンダーズ）強調」の変則型

### Why
Stripe Pricing 標準は中央列強調（center-stage 効果）だが、Caddygate の事業戦略では **「先着 100 社・永久無料」が主役**（sales-strategy §3-1）。center-stage を**反転して左列強調**にする。事業戦略との一致が最優先。

### 実装パターン
- 左列「ファウンダーズプラン」: 朱の枠線 2px + 「先着 100 社・残り ◯ 枠」バッジ（朱地・白文字）
- 中央列「通常プラン」: 通常枠線（生成色 1px）
- 右列「他社派遣単価（参考）」: 灰背景（#F9F7F2）+ 字色を薄墨に落とす（比較対照感）

---

## P-13. FAQ は `<details><summary>` ネイティブで素直に開閉

### Why
JavaScript なしで動く。スクリーンリーダー対応が標準で入る。**B2B では派手なアニメより素直な開閉**が信頼感（CloudSign も同方針）。max-height トランジションで 200ms ease-out。

### 実装パターン
```html
<details class="faq-item">
  <summary class="faq-q">ゴルフ経験のない学生で、本当に大丈夫ですか。</summary>
  <div class="faq-a">全員に研修制度をご用意しています...</div>
</details>
```

```css
.faq-item { border-bottom: 1px solid var(--color-border); }
.faq-q {
  padding: var(--space-5) 0;
  font-weight: 600; font-size: var(--fs-lead);
  cursor: pointer; list-style: none;
  display: flex; justify-content: space-between; align-items: center;
}
.faq-q::after { content: '+'; font-size: 1.5em; transition: transform 200ms; }
.faq-item[open] .faq-q::after { transform: rotate(45deg); }
.faq-a { padding: 0 0 var(--space-5) 0; color: var(--color-ink-sub); line-height: var(--lh-normal); }
```

---

## P-14. フッターは 4 列・法人取引仕様、独自ドメインメール必須

### Why
FB-09 を design-system に格上げ。**ここが空白だと、いくらデザインが整っていても法人取引候補から外れる**。50-60代支配人が最初に確認するのが「誰が運営しているか」。design-feedback FB-09 の指摘が design-system レベルで規定されることで、再発を構造的に防ぐ。

### 実装パターン（必須要素）
- **列 1**: ブランド（ロゴ + タグライン）
- **列 2**: サービス（サービス紹介・料金・導入の流れ・FAQ・資料請求）
- **列 3**: 運営会社（株式会社KAIROS / 住所 / 電話 / `info@caddygate.jp`）
- **列 4**: 法務情報（特商法・プラポリ・利用規約・募集情報等提供事業 届出番号）
- 下部: `© 2026 KAIROS Inc.`

`@gmail.com` は絶対禁止（design-system レベルでの禁則）。

---

## 補遺：原則の優先順位

複数の原則が衝突したときの優先順位：

1. **P-14 法人取引仕様**（取引が成立しないので最優先）
2. **P-04 サンセリフ一本**（user の最終トーン判定を破ると全件作り直し）
3. **P-05 本文 16-17px**（ターゲット可読性に直結）
4. **P-12 左列強調**（事業戦略と一致）
5. それ以外は美意識の問題なので、衝突時は実装の単純さ優先

---

作成完了: 2026-05-31
次工程: framework.css で実装、components.md / layouts.md で適用パターンを定義。
