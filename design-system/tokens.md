# Caddygate Design Tokens

作成: design-strategist
作成日: 2026-05-31
位置付け: framework.css の `:root` 変数を一覧化したリファレンス。実装中に「あの変数名なんだっけ」を解消する。

---

## 1. Color Tokens

### 主役 3 色

| トークン | HEX | 用途 |
|---|---|---|
| `--color-bg` | `#F5F0E6` | 古紙オフホワイト（ページ全体の地） |
| `--color-primary` | `#2f8f2f` | 鮮緑（H1/H2/CTA背景/ロゴ）※2026-05-31 旧 UI の鮮緑に戻し |
| `--color-accent` | `#B83A2E` | 朱（Primary CTA / ハイライト数字 / 限定バッジ） |

### 中性 5 色

| トークン | HEX | 用途 |
|---|---|---|
| `--color-ink` | `#1A1A1A` | 墨（本文文字） |
| `--color-ink-sub` | `#5C5C5C` | 薄墨（キャプション・補助文） |
| `--color-ink-mute` | `#8A8A8A` | 注釈・プレースホルダ |
| `--color-border` | `#E8E2D5` | 生成（区切り線・カードボーダー） |
| `--color-surface` | `#FFFFFF` | 純白（カード背景・モーダル） |

### 補助・状態

| トークン | HEX | 用途 |
|---|---|---|
| `--color-primary-soft` | `#4caf50` | マテリアル緑（補助グリーン）※旧 UI 復元 |
| `--color-primary-deep` | `#1e5f1e` | 深緑（CTA ホバー）※旧 UI 復元 |
| `--color-accent-deep` | `#8B2C2C` | 朱ダーク（ホバー・危険） |
| `--color-warn` | `#B89A4E` | 辛子（注意） |
| `--color-info` | `#A88C5F` | 金茶（補助アクセント・小バッジ） |
| `--color-surface-alt` | `#FAF7F0` | 比較表の灰列など |
| `--color-success` | `#2E5A40` | フォーム送信成功 |
| `--color-error` | `#8B2C2C` | エラー |

### コントラスト確認（WCAG AA 達成）

| 組み合わせ | 比率 | AA Pass |
|---|---|---|
| ink #1A1A1A / bg #F5F0E6 | 14.8:1 | ◎ |
| primary #2f8f2f / bg #F5F0E6 | 約 3.4:1 | △（見出しの大文字は OK・本文不可） |
| accent #B83A2E / surface #FFFFFF | 5.4:1 | ◎ |
| bg #F5F0E6 / primary #2f8f2f | 約 3.4:1 | △（Footer は文字サイズ大きめ・色は #FFFFFF 推奨） |

---

## 2. Spacing Tokens（8px ベース）

| トークン | 値 | 主な用途 |
|---|---|---|
| `--space-0` | 0 | リセット |
| `--space-1` | 4px | 極小ギャップ（アイコン横） |
| `--space-2` | 8px | 小ギャップ（バッジ内） |
| `--space-3` | 12px | 標準ギャップ（ボタン内 row） |
| `--space-4` | 16px | 段落間・グリッド gap |
| `--space-5` | 24px | カード内 padding（mobile）、container padding |
| `--space-6` | 32px | カード内 padding（desktop）、card 間 gap |
| `--space-7` | 48px | feature card padding、セクション内副要素間 |
| `--space-8` | 64px | mobile セクション padding |
| `--space-9` | 80px | hero 上下 padding |
| `--space-10` | 96px | section--compact padding-block |
| `--space-11` | 120px | section padding-block（標準） |
| `--space-12` | 160px | 強調セクション間 |

---

## 3. Typography Tokens

### Font Family

| トークン | 値 |
|---|---|
| `--font-sans` | `'Inter', 'Noto Sans JP', -apple-system, BlinkMacSystemFont, 'Hiragino Sans', 'Hiragino Kaku Gothic ProN', Meiryo, system-ui, sans-serif` |
| `--font-mono` | `'JetBrains Mono', 'SF Mono', Menlo, Consolas, monospace` |

### Font Size（clamp 関数）

| トークン | 値 | 適用要素 |
|---|---|---|
| `--fs-display` | `clamp(2rem, 5.5vw, 3.5rem)` | 32-56px ヒーロー H1 |
| `--fs-h1` | `clamp(1.75rem, 4vw, 2.5rem)` | 28-40px セクション見出し |
| `--fs-h2` | `clamp(1.5rem, 3vw, 2rem)` | 24-32px H2 |
| `--fs-h3` | `clamp(1.25rem, 2vw, 1.5rem)` | 20-24px H3 |
| `--fs-lead` | `clamp(1.0625rem, 1.6vw, 1.25rem)` | 17-20px リード |
| `--fs-body` | `clamp(1rem, 1.4vw, 1.0625rem)` | 16-17px 本文 |
| `--fs-small` | `0.875rem` | 14px キャプション |
| `--fs-micro` | `0.75rem` | 12px 注釈 |
| `--fs-stat-lg` | `clamp(2.5rem, 7vw, 4.5rem)` | 40-72px 数字大 |
| `--fs-stat-md` | `clamp(1.5rem, 3.5vw, 2.25rem)` | 24-36px 数字中 |

### Line Height

| トークン | 値 | 用途 |
|---|---|---|
| `--lh-tight` | 1.2 | H1/H2 |
| `--lh-snug` | 1.4 | H3、リード |
| `--lh-normal` | 1.75 | 本文（和文標準） |
| `--lh-loose` | 2.0 | 余韻演出 |

### Letter Spacing

| トークン | 値 | 用途 |
|---|---|---|
| `--ls-tight` | `-0.02em` | H1/H2（締める） |
| `--ls-normal` | `-0.01em` | 本文・ボタン |
| `--ls-zero` | 0 | リセット |
| `--ls-wide` | `0.02em` | Footer 列タイトル（uppercase） |

### Font Weight 使用ルール

| ウェイト | 使う場面 |
|---|---|
| 400 (Regular) | 本文・キャプション |
| 500 (Medium) | ナビリンク |
| 600 (Semi Bold) | H3・ボタン・カードタイトル |
| 700 (Bold) | H1・H2・stat-md |
| 900 (Black) | ヒーロー H1（Noto Sans JP のみ） |

---

## 4. Radius Tokens

| トークン | 値 | 用途 |
|---|---|---|
| `--radius-none` | 0 | 区切り線・矩形 |
| `--radius-sm` | 4px | ボタン・小バッジ |
| `--radius-md` | 6px | カード・入力フィールド |
| `--radius-lg` | 8px | 大きなパネル・画像 |
| `--radius-pill` | 999px | ステップ番号バッジ・残数バッジ |

---

## 5. Shadow Tokens（極控えめ）

| トークン | 値 | 用途 |
|---|---|---|
| `--shadow-none` | `none` | リセット |
| `--shadow-subtle` | `0 1px 2px rgba(26,26,26,0.04)` | カード基本 |
| `--shadow-card` | `0 1px 3px rgba(26,26,26,0.06), 0 1px 2px rgba(26,26,26,0.04)` | カード強め |

これ以上の影は使わない。

---

## 6. Layout Tokens

| トークン | 値 | 用途 |
|---|---|---|
| `--container-max` | `1120px` | 標準コンテナ最大幅 |
| `--container-narrow` | `880px` | 課題提起・FAQ |
| `--container-prose` | `720px` | 本文ブロック |
| `--container-padding-x` | `24px` | 左右 padding（mobile） |

---

## 7. Breakpoints（参照値）

| トークン | 値 | 名称 |
|---|---|---|
| `--bp-mobile` | `767px` | Mobile 上限 |
| `--bp-tablet` | `1024px` | Tablet 上限 |
| `--bp-desktop` | `1120px` | Desktop 標準 |

**注**: CSS media query では変数を使えないので、直接 `768px` `1024px` を書く。これらの変数は JS から参照する場合や、文書上の確認用。

---

## 8. Transition Tokens

| トークン | 値 | 用途 |
|---|---|---|
| `--t-fast` | `100ms ease-out` | ボタン active |
| `--t-base` | `150ms ease-out` | ボタン hover、リンク色変化 |
| `--t-slow` | `250ms var(--ease)` | アコーディオン、モーダル |
| `--ease` | `cubic-bezier(0.16, 1, 0.3, 1)` | ease-out-expo（参考） |

---

## 9. Z-index Tokens

| トークン | 値 | 用途 |
|---|---|---|
| `--z-base` | 1 | ベース |
| `--z-sticky` | 50 | スティッキー要素 |
| `--z-header` | 100 | ヘッダー |
| `--z-modal` | 1000 | モーダル |

---

## 10. 命名規則

- 全トークンは **kebab-case** + `--` プレフィックス
- カラーは `--color-<役割>`、サイズは `--fs-<階層>`、余白は `--space-<番号>`、半径は `--radius-<サイズ>`
- 番号は **小さい数字 = 小さい値** の規則
- 色の濃淡は `-deep` / `-soft` / `-alt` のサフィックスで表現（数字サフィックス避ける、視認性のため）

---

## 11. トークン追加時のルール

新規トークン追加は **principles.md の更新を伴う場合のみ**。Ad-hoc に追加すると tokens が肥大化して保守不能になる（Linear は 361 色だが Caddygate は 16 色で十分）。

追加するとき：
1. principles.md にどの原則の派生か明記
2. tokens.md と framework.css の両方を更新
3. components.md / layouts.md で使用例を 1 つ以上提示

---

作成完了: 2026-05-31
