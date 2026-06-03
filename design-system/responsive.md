# Caddygate Responsive Rules

作成: design-strategist
作成日: 2026-05-31
位置付け: ブレイクポイント定義と、各画面幅での挙動を網羅。framework.css と layouts.md と組み合わせて使う。

---

## 1. ブレイクポイント定義

```css
/* CSS media query で使う実数値（変数ではなく直接書く） */
/* Mobile First 思想：mobile が default、上書きで tablet/desktop に拡張 */

@media (min-width: 768px)  { /* Tablet 以上 */ }
@media (min-width: 1024px) { /* Desktop 以上 */ }
@media (min-width: 1440px) { /* Wide（オプション） */ }

/* 逆方向（モバイル限定スタイル）を書くとき */
@media (max-width: 767px)  { /* Mobile only */ }
@media (max-width: 1023px) { /* Tablet 以下 */ }
```

### ブレイクポイント定義表

| 名称 | 範囲 | 想定デバイス | 主な対応 |
|---|---|---|---|
| **Mobile** | 〜 767px | iPhone / Android | 1 列、CTA 100% 幅、テーブル縦積み、フォントサイズは clamp の min |
| **Tablet** | 768px 〜 1023px | iPad / 横長 Android | 一部 2 列（4 ステップなど）、container_padding 32px |
| **Desktop** | 1024px 〜 1439px | ノート PC・社員向け PC | 全カラム展開、container max 1120px |
| **Wide** | 1440px 以上 | 大型外部モニタ・社内会議用 TV | container は 1120px のまま中央寄せ、margin が広がる |

---

## 2. Mobile First 思想

- デフォルト（メディアクエリ外）は Mobile スタイル
- 上書きする方向は **「狭い → 広い」**（min-width で拡張）
- ターゲット 50-60代男性の半数以上が「会社の PC で開く」ことが想定されるが、**外回りの支配人がスマホで見る瞬間こそ第一印象**。モバイル品質が営業の成否を分ける

---

## 3. タイポグラフィの clamp() 設計

framework.css で定義済の clamp はすべて以下の構造：

```
clamp(min, vw計算, max)
```

| トークン | min（mobile） | max（desktop） |
|---|---|---|
| --fs-display | 32px | 56px |
| --fs-h1 | 28px | 40px |
| --fs-h2 | 24px | 32px |
| --fs-h3 | 20px | 24px |
| --fs-lead | 17px | 20px |
| --fs-body | 16px | 17px |

→ **media query なしでも自動的に画面幅に追従**。固定値の上書きが激減してメンテ性が上がる。

---

## 4. レイアウト変換ルール

### 4-1. Grid の自動切替

framework.css の `.grid--2`, `.grid--3`, `.grid--4` は **mobile（〜767px）で自動的に 1 列**。

```css
.grid--2, .grid--3, .grid--4 { grid-template-columns: repeat(N, 1fr); }
@media (max-width: 767px) {
  .grid--2, .grid--3, .grid--4 { grid-template-columns: 1fr; }
}
```

### 4-2. Hero 切替

| 項目 | Desktop | Mobile |
|---|---|---|
| 最低高さ | 80vh | 90vh |
| 背景グラデ方向 | 左→右（横方向） | 上→下（縦方向） |
| H1 改行位置 | 「キャディが、開く。」/「九州のゴルフ場の朝を…」 | 同じ（`<br>` で固定） |
| CTA | 横並び | 縦積み、flex: 1 1 100% で幅 100% |
| padding | 上 80px / 下 96px | 上 48px / 下 64px |

### 4-3. Pricing 3列 → 1列

```
[Featured] [Normal] [Reference]    ← desktop
       ↓
[Featured]                          ← mobile（順序維持）
[Normal]
[Reference]
```

featured を最上段に置くため、HTML 上の DOM 順序を変えない。

### 4-4. 対比表（D. 解決）

framework.css 12 章で定義済：
- desktop: 2 列テーブル
- mobile: 各行が縦積みになり、`従来：` / `Caddygate：` のラベルが擬似要素で付与される

### 4-5. 4 ステップ（F）

- desktop: 4 列横並び
- tablet（768-1023px）: 2 列 × 2 行
- mobile: 1 列縦積み

### 4-6. Footer

- desktop: 4 列（1.4fr 1fr 1.3fr 1.3fr）
- tablet: 2 列
- mobile: 1 列

---

## 5. コンテナ padding 調整

```css
.container { padding-inline: 24px; }            /* default = mobile */

@media (min-width: 768px) {
  .container { padding-inline: 32px; }          /* tablet */
}

@media (min-width: 1024px) {
  .container { padding-inline: 40px; }          /* desktop */
}
```

framework.css のデフォルトは 24px 固定だが、上記をフォロー実装することで desktop での「左右の引きすぎ感」を解消できる。

---

## 6. タッチターゲット最低サイズ

すべてのインタラクティブ要素は **最低 44×44px** を確保（Apple HIG / WCAG 2.5.5）。

| 要素 | 最低サイズ | 実装 |
|---|---|---|
| ボタン | 48px 高 | `.btn` の min-height: 48px |
| FAQ summary | 56-60px 高 | padding 上下 24px が標準 |
| ナビリンク | 44px 高 | header__inner の高さ 64px、リンクは padding 確保 |
| フォーム入力 | 48px 高 | `.input` の min-height: 48px |
| 小バッジ（タップしないもの） | 制約なし | デザイン優先 |

---

## 7. ヒーロー画像のモバイル時クロップ指示

`hero-main.png` は横長 16:9 のため、モバイルでは中央クロップだとキャディの後ろ姿が左に寄りすぎる可能性。

### 推奨対応：CSS で背景位置を切替

```css
.hero__bg {
  background-image: url('/assets/hero-main.png');
  background-size: cover;
  background-position: center;
}

@media (max-width: 767px) {
  .hero__bg {
    /* モバイル時は中央左寄りでキャディを画面内に */
    background-position: 30% center;
  }
}
```

### 余裕があれば：`<picture>` で別画像配信

mobile 用に縦長クロップ版（750×1334 程度）を別途用意できれば理想：

```html
<picture>
  <source media="(max-width: 767px)" srcset="/assets/hero-main-mobile.jpg">
  <img src="/assets/hero-main.png" alt="">
</picture>
```

ただしこれは Phase 2 の最適化案件。Phase 1 は CSS の background-position だけで OK。

---

## 8. 画像最適化指針

| 用途 | 形式 | 推奨サイズ | 圧縮 |
|---|---|---|---|
| hero-main | JPG または WebP | 1920×1080 + 750×1334 mobile | Squoosh 80% |
| caddies-portrait | JPG または WebP | 1600×1067 | Squoosh 80% |
| logo-wordmark | PNG or SVG | 1000×240 | PNG-8 |
| logo-symbol | PNG or SVG | 512×512 | PNG-8 |
| og-image | JPG | 1200×630 | Squoosh 85% |

`<img>` には必ず `loading="lazy"`（ヒーロー以外）、`width` `height` 属性で aspect-ratio を予約してレイアウトシフト防止。

---

## 9. パフォーマンス指針

| 項目 | 目標 |
|---|---|
| LCP (Largest Contentful Paint) | < 2.5s |
| CLS (Cumulative Layout Shift) | < 0.1 |
| INP | < 200ms |
| 画像合計 | < 1.5MB（hero + caddies-portrait で 1MB 以内） |
| フォント | preconnect + display=swap |

### 具体対策
1. ヒーロー画像のみ `<link rel="preload" as="image">` で先読み
2. その他画像は `loading="lazy"`
3. Lucide はページ最下部で読み込み
4. Google Fonts は wght を必要なものだけ指定（Inter は 400/500/600/700、Noto Sans JP は 400/500/700/900 のみ）

---

## 10. レスポンシブ・チェックリスト

visual-implementer 実装後にチェック：

- [ ] 320px 幅でレイアウト崩壊しない
- [ ] 375px（iPhone SE）でヒーロー H1 が 2 行に収まる
- [ ] 768px（iPad portrait）で Pricing が 1 列に切り替わる位置が自然
- [ ] 1024px で 4 ステップが横並びになる
- [ ] 1440px 以上で container の左右余白が「中央寄せ感」を保つ
- [ ] 全画面幅でタッチターゲット 44px 以上
- [ ] mobile で 文字サイズが 16px 未満にならない（本文）
- [ ] FAQ アコーディオン開閉が滑らか（200ms）
- [ ] フォーム入力が拡大ズームを誘発しない（input の font-size 16px+）

---

## 11. iOS Safari 特有の注意

- `100vh` は Safari のアドレスバー伸縮で挙動が変。`min-height: 100svh` （Safe Viewport Height）に置き換え推奨：

```css
.hero { min-height: 80vh; min-height: 80svh; }
```

- input の font-size が 16px 未満だと、フォーカス時に自動拡大ズームが発生。Caddygate は 16-17px なので問題なし。

---

作成完了: 2026-05-31
