# Caddygate Typography

作成: design-strategist
作成日: 2026-05-31
位置付け: タイポグラフィ専用ガイド。フォントスタック、サイズスケール、行間、文字間、日本語改行ルール、数字の見せ方を網羅。tokens.md / principles.md と内容が一部重複するが、**タイポを触るときは本ファイル一冊で完結**するように整備。

---

## 1. フォントスタック

### 1-A. 基本方針：欧文 Inter / 和文 Noto Sans JP の混植

| 種別 | 第一候補 | フォールバック |
|---|---|---|
| 欧文 | **Inter** | -apple-system, BlinkMacSystemFont |
| 和文 | **Noto Sans JP** | Hiragino Sans, Hiragino Kaku Gothic ProN, Meiryo, system-ui |
| 等幅（必要時） | JetBrains Mono | SF Mono, Menlo, Consolas |

CSS 変数定義：
```css
:root {
  --font-sans: 'Inter', 'Noto Sans JP', -apple-system, BlinkMacSystemFont,
               'Hiragino Sans', 'Hiragino Kaku Gothic ProN', Meiryo, system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', 'SF Mono', Menlo, Consolas, monospace;
}
```

### 1-B. なぜ Inter + Noto Sans JP か

| 理由 | 根拠 |
|---|---|
| **欧文 SaaS の事実上の標準** | Linear / Notion / Shopify など主要 SaaS が採用（research.md §1-A） |
| **和文 公的可読性標準** | デジタル庁デザインシステムが採用（research.md F-08） |
| **x-height が近く混植が綺麗** | 並べたときの高さズレが最小 |
| **無料・商用可** | Google Fonts 経由で SIL Open Font License |
| **可変フォント対応** | 100-900 まで任意のウェイト |

### 1-C. なぜ明朝（Cormorant Garamond / Noto Serif JP）を捨てたか

- brand-strategist 当初案だが、user 判定で「厳か too much」と破棄
- 50-60代男性ターゲットでも「現代的清潔感」を選んだ
- 明朝は古風・格式・荘厳の方向に振れすぎ、IT サービスの実用感が弱まる
- **再採用は禁止**（principles.md P-04）

### 1-D. Google Fonts 読み込み

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
  href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
  rel="stylesheet"
>
```

**読み込むウェイトは必要分のみ**：
- Inter: 400 / 500 / 600 / 700
- Noto Sans JP: 400 / 500 / 700 / 900

全ウェイトを読み込むとファイルサイズが肥大化し、LCP が遅れる。

---

## 2. タイポスケール（clamp() ベース）

### 2-A. ヒエラルキー

| 階層 | トークン | サイズ | 用途 |
|---|---|---|---|
| Display | `--fs-display` | clamp(32-56px) | ヒーロー H1 |
| H1 | `--fs-h1` | clamp(28-40px) | セクション最上位見出し |
| H2 | `--fs-h2` | clamp(24-32px) | サブセクション見出し |
| H3 | `--fs-h3` | clamp(20-24px) | カード・ステップタイトル |
| Lead | `--fs-lead` | clamp(17-20px) | ヒーロー下のリード文 |
| Body | `--fs-body` | clamp(16-17px) | 本文（**下限 16px 厳守**） |
| Small | `--fs-small` | 14px | キャプション |
| Micro | `--fs-micro` | 12px | 注釈・出典 |
| Stat Lg | `--fs-stat-lg` | clamp(40-72px) | 損失額・大きな数字 |
| Stat Md | `--fs-stat-md` | clamp(24-36px) | 料金 |

### 2-B. なぜ clamp() か

固定値（H1: 48px）で組むと mobile で巨大すぎ、desktop で小さすぎる事故が起きる。

```css
font-size: clamp(min, fluid, max);
```

- min: モバイルでの下限
- fluid: 画面幅に応じた中間値（vw を使う）
- max: デスクトップでの上限

→ media query なしで自動追従。固定値の上書きが激減してメンテ性が上がる。

### 2-C. 数式の意味

例：`--fs-display: clamp(2rem, 5.5vw, 3.5rem);`

- 32px（モバイル）〜 56px（デスクトップ）
- ビューポート幅 1000px のとき = 55px、500px のとき = 32px（下限張り付き）
- 全ステップが滑らかに伸縮

### 2-D. 数値の根拠

| サイズ | 根拠 |
|---|---|
| 56px Display max | Linear / Vercel のヒーロー H1 が 48-64px |
| 32px Display min | iPhone 標準（375px）で 2 行構成が破綻しない |
| 17px Body max | 50-60代男性可読性（design-feedback FB-18 と整合） |
| 16px Body min | iOS Safari の input 自動ズーム回避閾値 |
| 12px Micro | 法的開示・注釈の限界（WCAG 推奨下限） |

---

## 3. 行間（line-height）

### 3-A. トークン

| トークン | 値 | 適用 |
|---|---|---|
| `--lh-tight` | 1.2 | H1 / H2 / Stat（詰める） |
| `--lh-snug` | 1.4 | H3 / リード / カードタイトル |
| `--lh-normal` | 1.75 | 本文（**和文標準**） |
| `--lh-loose` | 2.0 | 余韻が欲しいリード（限定使用） |

### 3-B. なぜ和文本文は 1.75 か

- 欧文標準は 1.5、和文は 1.7-1.8 が一般的
- 漢字の上下密度が高く、欧文より広めの行間が必要
- デジタル庁デザインシステムも本文 1.75 採用
- ターゲット 50-60代男性の眼精疲労を考えると 1.75 が下限

---

## 4. 字間（letter-spacing）

### 4-A. トークン

| トークン | 値 | 適用 |
|---|---|---|
| `--ls-tight` | -0.02em | H1 / H2（締める） |
| `--ls-normal` | -0.01em | 本文・ボタン |
| `--ls-zero` | 0 | リセット |
| `--ls-wide` | 0.02em | Footer 列タイトル（uppercase 用） |

### 4-B. なぜマイナス字間が基本か

- Inter / Noto Sans JP のデフォルト字間は Web で「やや空きすぎ」に見える
- -0.01em〜-0.02em で締めると「整っている」印象が増す
- ただし**和文中心では強く詰めない**（-0.02em 以下にしない）

### 4-C. 全角スペースで字間を取るのは禁止

```html
<!-- NG -->
<h2>キ ャ デ ィ が 、 開 く 。</h2>

<!-- OK -->
<h2 style="letter-spacing: 0.05em">キャディが、開く。</h2>
```

---

## 5. font-feature-settings: "palt"

```css
body { font-feature-settings: "palt"; }
```

- 和文プロポーショナルメトリクスを有効化
- 句読点（、。）の前後の不自然な空きが詰まる
- Noto Sans JP は palt をサポート
- **必須設定**

---

## 6. 日本語改行ルール（最重要）

### 6-A. 見出し用

```css
.h-display, .h1, .h2, .h3, .hero-headline {
  word-break: keep-all;
  overflow-wrap: break-word;
  line-break: strict;
}
```

- `keep-all`: 単語の途中で改行しない（日本語の場合は句読点や助詞で改行候補）
- `overflow-wrap: break-word`: それでもはみ出すなら強制改行
- `line-break: strict`: 禁則処理を厳密に（句読点が行頭に来ない）

### 6-B. 本文用

```css
body, p, .body-text {
  word-break: normal;
  overflow-wrap: anywhere;
  line-break: strict;
}
```

- `normal`: 日本語は自然改行、英単語は単語境界
- `anywhere`: それでも長い英単語等ははみ出さない
- `line-break: strict`: 禁則処理

### 6-C. 根拠

[ICS MEDIA 2024 解説](https://ics.media/entry/240411/)で確立された 2026 年現在のベストプラクティス。

### 6-D. 意図的な改行は `<br>` のみ

```html
<!-- ヒーロー H1（必須 2 行構成） -->
<h1 class="hero-headline">
  キャディが、開く。<br>
  九州のゴルフ場の朝を、断らない経営へ。
</h1>

<!-- 改行候補だが強制ではないとき -->
<p>福岡・長崎の名門コースと、<wbr>九州の大学生キャディを、<br>予約手数料だけで結びます。</p>
```

- `<br>`: 強制改行（ヒーロー H1 / 最終 CTA H1 のみ）
- `<wbr>`: 改行候補ヒント（あってもなくても良い場所）
- 本文は CSS の max-width で改行を制御し、`<br>` を本文中に書かない

---

## 7. 数字の見せ方

### 7-A. 通貨・単位

```html
<!-- OK -->
¥2,500
100 社
89 枠

<!-- NG -->
¥ 2,500           ← ¥と数字の間にスペース禁止
２，５００       ← 全角数字禁止
２，５００円      ← 全角数字 + 「円」混在禁止
```

ルール：
- 通貨記号と数字の間にスペース入れない
- カンマ区切りは半角 `,`
- 単位の前にスペース 1 個
- 通貨記号は ¥（U+00A5）を使用

### 7-B. 大きな数字の強調

```html
<!-- 単位は同サイズ・数字のみ大 -->
<p>
  月 20 営業日で
  <span class="stat-lg">600</span>
  万円。
</p>
```

```css
.stat-lg {
  font-size: var(--fs-stat-lg);
  font-weight: 700;
  line-height: 1.1;
  letter-spacing: var(--ls-tight);
  color: var(--color-accent);
}
```

### 7-C. 数字の色

- ハイライト数字（損失額・料金）: 朱 `--color-accent`
- 通常の数字: 本文と同じ墨 `--color-ink`
- カウンタ・残数: 朱 + 太字（`<strong>89</strong> 枠`）

---

## 8. ヒエラルキー実装例（コピペ用）

### 8-A. ヒーロー H1

```html
<h1 class="hero-headline">
  キャディが、開く。<br>
  九州のゴルフ場の朝を、断らない経営へ。
</h1>
```

```css
.hero-headline {
  font-family: var(--font-sans);
  font-size: var(--fs-display);
  font-weight: 900;
  line-height: 1.18;
  letter-spacing: var(--ls-tight);
  color: var(--color-primary);
  word-break: keep-all;
  overflow-wrap: break-word;
  line-break: strict;
}
```

### 8-B. セクション H1

```html
<h2 class="h1">予約が決まった時だけ、<span style="color:var(--color-accent)">¥2,500</span>。</h2>
```

### 8-C. リード文

```html
<p class="lead">
  キャディゲートは、貴クラブの求人を九州の登録キャディに届け、
  応募が来た時だけ、予約システム手数料 ¥2,500 を月末にまとめて精算します。
</p>
```

### 8-D. 本文

```html
<p>
  全国のゴルフ場の9割がセルフプレーに進む中で、
  「キャディ付き堅持」を選ぶコースほど、ひとつの欠員が経営に響いています。
</p>
```

### 8-E. 注釈

```html
<p class="micro">
  ※ 全国セルフプレー比率 約9割（dstar101 / 2024年）
</p>
```

---

## 9. アクセシビリティ確認

| 項目 | 基準 | Caddygate |
|---|---|---|
| 本文最小サイズ | 16px 以上推奨 | 16-17px clamp |
| 行間 | 1.5 以上推奨 | 本文 1.75 |
| 段落間 | 1.5 段以上推奨 | margin-bottom var(--space-4) |
| ユーザーズームを禁止しない | viewport で maximum-scale 制限禁止 | ✅（components.md §1）|
| `<h1>` はページ 1 個 | アウトライン明確化 | ✅（ヒーローのみ） |
| コントラスト | AA 4.5:1 以上 | ✅（tokens.md §1 で確認済） |

---

## 10. NG パターン（再発防止）

| NG | 理由 |
|---|---|
| `font-size: 0.32rem` | 旧サイトの強引縮小（FB-18） |
| `html { font-size: 150%; }` | 全体スケール上書き（FB-18） |
| 本文 14px | ターゲット 50-60代男性に厳しい |
| 明朝体（Cormorant / Noto Serif JP） | user 判定「厳か too much」 |
| 全角スペース字間調整 | letter-spacing で対応 |
| 装飾フォント | 信頼感が下がる |
| line-height: 1（無設定）| 行が詰まりすぎ可読性低下 |
| 本文に `word-break: keep-all` | 長い英単語ではみ出す |
| 見出しに `overflow-wrap: anywhere` | 句読点以外で改行が起きる |

---

作成完了: 2026-05-31
本ガイドに従えば、Caddygate のタイポは全媒体で一貫した品格を保つ。
