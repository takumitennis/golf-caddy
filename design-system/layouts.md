# Caddygate Layouts（A〜K セクション組み立て）

作成: design-strategist
作成日: 2026-05-31
位置付け: copywriter の確定コピー（lp-copy-2026-05.md セクション A〜K）に対応する LP 各セクションのレイアウト型。components.md と framework.css を組み合わせて使う。

---

## 全体スケルトン（順序）

```
1.  Header（sticky / 64px）
2.  A. Hero（80vh / 背景 hero-main.png）
3.  B. Alert Bar（先着 100 社・残数）
4.  C. 課題提起（チェックリスト + 機会損失強調枠）
5.  D. 解決（Before/After 対比表）
6.  E. 大学生キャディ（3 カード + caddies-portrait.png）
7.  F. 仕組み（4 ステップ）
8.  G. 料金（3 カラム・左列強調）
9.  H. 安心の仕組み（4 項目縦並び）
10. I. FAQ（8 件アコーディオン）
11. J. 最終 CTA（背景強調 + 3 経路）
12. K. Footer（4 列・法人取引仕様）
```

セクション間は **`.section`（120px desktop / 64px mobile）** がデフォルト。
背景の切り替えは `.section--surface`（白）と地のオフホワイトを交互に当てて視覚的リズムを作る。

---

## A. Hero

### レイアウト構造

```
┌─────────────────────────────────────────┐
│ [背景: hero-main.png + 古紙ベール 92%]   │
│                                         │
│   [H1: キャディが、開く。]               │
│   [H1: 九州のゴルフ場の朝を、断らない…]  │
│                                         │
│   [サブ: 福岡・長崎の名門コースと…]     │
│                                         │
│   [マイクロ: 先着 100 社限定…]           │
│                                         │
│   [Primary CTA] [Secondary CTA]         │
│                                         │
│   [残数: 残り 89 枠]                     │
│                                         │
└─────────────────────────────────────────┘
   min-height: 80vh （mobile: 90vh）
```

### 要素詳細
- 背景: `/assets/hero-main.png` を cover で全面、その上に古紙オフホワイトの **左→右のグラデーション** (92% → 20%) で被せ、左側のコピー領域に可読性を確保
- コンテンツ幅: max-width 720px、左寄せ
- H1: Noto Sans JP 900 / clamp(32-56px) / line-height 1.18 / 苔緑 #2C4A3B / 2 行構成（`<br>` で明示）
- CTA: Primary（朱）+ Secondary（苔緑アウトライン）、横並び（mobile では縦積み + flex:1）
- 残数: 朱 #B83A2E のテキスト、Primary CTA の下

### モバイル時
- 背景グラデは左→右 → 上→下（同様のオフホワイト → 透明）に切替
- CTA は縦積み、幅 100%
- H1 サイズは clamp() が自動調整

### 関連コピー
lp-copy-2026-05.md セクション A 完全踏襲

---

## B. Alert Bar（枠の残り）

### レイアウト構造

```
┌─────────────────────────────────────────┐
│ [苔緑バンド・横並び 3 項目 + 区切り |]   │
│  プラン名｜残り◯枠｜地域メッセージ      │
└─────────────────────────────────────────┘
   padding-block: 12px、フォント 14px
```

### 要素詳細
- 高さ: 約 40-48px
- 背景: `--color-primary` 苔緑
- 文字: 古紙オフホワイト #F5F0E6
- 区切り: 「|」を薄く（opacity 0.4）
- モバイル: flex-wrap で折り返し、divider 非表示
- **sticky にはしない**（ヒーロー下のフローに置く。スクロールしても下のコンテンツの邪魔をしない）

### 関連コピー
lp-copy-2026-05.md セクション B 完全踏襲。「補足コピー（帯の下に1文）」は本セクションの下、container 内に `<p class="small">` で配置。

---

## C. 課題提起（Before）

### レイアウト構造

```
┌──── container--narrow（880px）────┐
│ H1: 土曜の朝、断った予約は…       │
│ Lead: 全国のゴルフ場の9割が…       │
│                                  │
│ [Checklist 6 項目・縦並び]        │
│                                  │
│ [機会損失強調枠：苔緑塗・600 万円] │
│                                  │
│ 注釈（薄墨）                       │
└──────────────────────────────────┘
```

### 要素詳細
- container--narrow（880px）で中央寄せ
- 見出し: `<h2 class="h1">`
- Lead: `<p class="lead">` 行間広めで詩的に
- Checklist: `.checklist` + `.checklist__item` 6 件
- **機会損失強調枠**: `<div class="card">` + inline style で苔緑背景 + 古紙文字、中央寄せ
  - 中の「600 万円」は `<p class="stat-lg" style="color:var(--color-bg)">`
- 末尾の数字出典は `<p class="micro">`

### 関連コピー
lp-copy-2026-05.md セクション C 完全踏襲

---

## D. 解決（After / Before/After 対比）

### レイアウト構造

```
┌──── container（1120px）─────────────────┐
│ H1: 予約が決まった時だけ、¥2,500。       │
│ Lead: キャディゲートは、貴クラブの…     │
│                                        │
│ ┌──────────┬─────────────────┐         │
│ │これまで   │キャディゲートで │         │
│ ├──────────┼─────────────────┤         │
│ │（6 行）  │                 │         │
│ └──────────┴─────────────────┘         │
└────────────────────────────────────────┘
   背景: section--surface（純白）
```

### 要素詳細
- `<section class="section section--surface">` でセクション C のオフホワイトから白に切り替え（リズム）
- 見出しの「¥2,500」は `<span style="color:var(--color-accent)">` で朱に
- 対比表は `.compare-table` 6 行
- モバイル: テーブルが縦積みに自動変換（framework.css 12 章で定義済）

### 関連コピー
lp-copy-2026-05.md セクション D 完全踏襲

---

## E. なぜ大学生キャディなのか

### レイアウト構造

```
┌──── container（1120px）─────────────────┐
│ H1（中央）: キャディは、九州の大学生です。│
│ Lead（中央）: 最初の登録は…              │
│                                        │
│ [人物写真 caddies-portrait.png]         │
│  ← 横長 1200×800、border-radius 8px      │
│                                        │
│ ┌─────┬─────┬─────┐                    │
│ │Card1│Card2│Card3│                    │
│ └─────┴─────┴─────┘                    │
│                                        │
│ 補足の1文（小さく・余白）                │
└────────────────────────────────────────┘
```

### 要素詳細
- 見出しとリードは中央寄せ
- 写真は max-width 1120px、`border-radius: var(--radius-lg)`、可能なら `object-fit: cover; aspect-ratio: 16/9`
- 写真の下に 3 カード（`.grid--3` + `.card`）
- カード内は `.card__number` 1/2/3 + `.card__title` + `.card__body`
- 補足の1文は `<p class="small mt-7" style="max-width:720px;">`

### モバイル時
- カード 3 → 1 列縦並び（framework.css の grid 自動切替）
- 写真は同様に full-width

### 関連コピー
lp-copy-2026-05.md セクション E 完全踏襲

---

## F. 仕組み（4 ステップ）

### レイアウト構造

```
┌──── container（1120px）─────────────────┐
│ H1（中央）: 4 ステップで、始められます。 │
│                                        │
│ ┌──┬──┬──┬──┐                          │
│ │①│②│③│④│  ステップカード横並び       │
│ └──┴──┴──┴──┘                          │
│                                        │
│ 補足の1文（薄墨・規制対応文言）          │
└────────────────────────────────────────┘
```

### 要素詳細
- `.steps` (grid 4列) を使用
- 各 step は `.step` + `.step__num`（円形バッジ 32px）+ `.step__title` + `.step__body`
- desktop で 4 列、tablet で 2 列、mobile で 1 列（framework.css で対応済）
- 補足の1文（「キャディゲートは、貴クラブとキャディの間に立つ『予約システム』です」）は `<p class="small mt-7">` で薄墨

### 関連コピー
lp-copy-2026-05.md セクション F 完全踏襲

---

## G. 料金 ＆ 資料請求（クローズド料金型）

### 設計の根本意図

**LP上で具体的金額（¥2,500 等）を一切表示しない**。中抜き防止（キャディが料金を知ると直接取引誘発）・競合戦略秘匿・営業漏斗最適化のため。Salesforce / HubSpot Enterprise / Sansan と同じ B2B エンタープライズ標準モデル。

### レイアウト構造

```
┌──── container（1120px）─────────────────────┐
│ H1（中央）: 料金は、シンプルに。              │
│ サブ（中央薄墨）: 詳細は資料請求にて。         │
│                                              │
│ ┌─ 3項目バッジ（横並び） ───────────────┐   │
│ │ 初期費用ゼロ │ 月額固定費ゼロ │ ご利用時のみ│   │
│ └────────────────────────────────────────┘   │
│                                              │
│ ┌─ ファウンダーズカード（中央・朱枠2px）─┐  │
│ │  「ファウンダーズプラン」               │  │
│ │  「先着 100 社限定」                    │  │
│ │                                        │  │
│ │  基本料金     永久無料                  │  │
│ │  求人掲載料   永久無料                  │  │
│ │  予約システム手数料   詳細は資料請求にて │  │
│ │  最低契約期間 なし                      │  │
│ │  ─────                                  │  │
│ │  101社目以降は通常プランへ自動移行       │  │
│ └────────────────────────────────────────┘  │
│                                              │
│ 補足の1段（中央 max-w 720px・薄墨スモール）   │
│                                              │
│ ┌─ Primary CTA（朱・大）────────────────┐  │
│ │  無料で詳細資料を受け取る  →            │  │
│ └────────────────────────────────────────┘  │
│   Secondary CTA（テキスト・小）              │
│   お電話でのご相談はこちら ▶                 │
│   マイクロコピー（薄墨）                      │
└──────────────────────────────────────────┘
   背景: section--surface（純白）
```

### 要素詳細
- `<section class="section section--surface" id="pricing">` で白背景
- 見出し H1 と サブ見出し は中央寄せ
- **3項目バッジ**：横並び3つの簡素なバッジ
  - 各バッジ：苔緑文字、生成色（#E8E2D5）の細い枠線、padding 12px 24px、サンセリフ 17px
  - クラス案：`.fee-badges` + 子に `.fee-badge`
- **ファウンダーズカード**：中央、max-width 560px、`.pricing-card.pricing-card--featured`（朱 2px 枠 + 「先着 100 社」バッジ）
  - 価格行はラベル左 / 値右の対句構成
  - 「永久無料」「詳細は資料請求にて」は朱（#B83A2E）で強調
  - カード末尾に「101社目以降は通常プラン」の脚注（薄墨・スモール、生成色の区切り線で分離）
- **補足**：1段組（max-width 720px、中央寄せ、薄墨スモール）
- **Primary CTA**：朱ボタン、大きめ（padding 16px 48px、font-size 18px）、矢印 →
- **Secondary CTA**：プレーンテキストリンク、小、薄墨
- **マイクロコピー**：CTA下、center、`.small.text-mute`

### モバイル時
- 3項目バッジ：3列 → 縦並び（gap 12px）
- ファウンダーズカード：max-width 100%、padding 24px に縮小
- CTA：full-width

### 旧 Pricing 3カラムは使用禁止（重要・2026-05-31 変更）
- 旧 `.pricing-grid` 3カラム（ファウンダーズ／通常／参考）構造は廃止
- components.md の `.pricing-grid` コンポーネントは将来運営者専用ページ用に temp で残置可、ただし LP では呼ばない
- 戦略変更理由：LP に具体的金額を出すと中抜きリスクが上がるため、クローズド料金型に統一

### 関連コピー
lp-copy-2026-05.md セクション G 完全踏襲（資料請求型に書き換え済 2026-05-31）

---

## H. 安心の仕組み

### レイアウト構造

```
┌──── container（1120px）─────────────────┐
│ H1: 法人取引で必要な備えを、揃えています。│
│                                        │
│ ┌─────────────────┐                    │
│ │[icon] 運営       │                    │
│ │  株式会社KAIROS…│                    │
│ ├─────────────────┤                    │
│ │[icon] 法務監修   │                    │
│ │  弁護士・社労士… │                    │
│ ├─────────────────┤                    │
│ │[icon] キャディ保険│                   │
│ ├─────────────────┤                    │
│ │[icon] 中抜き防止 │                    │
│ └─────────────────┘                    │
│                                        │
│ 補足の1文                                │
└────────────────────────────────────────┘
```

### 要素詳細
- 4 項目を**縦並び**（横並びカード×4 ではなく、説明文が長いので 1 列の card-list が読みやすい）
- 各項目は `<div class="card">` + 中に `<div class="row">` で `<i data-lucide="...">` + `.card__title` + `.card__body`
- 推奨アイコン:
  - 運営: `building-2`
  - 法務監修: `shield-check`
  - キャディ保険: `umbrella`
  - 中抜き防止: `lock`
- アイコンサイズ: 32px（icon-lg）、苔緑
- 補足の1文「ご契約前に、契約書ドラフト…」は `<p class="small mt-6">`

### モバイル時
- そのまま縦並び（変化なし）

### 関連コピー
lp-copy-2026-05.md セクション H 完全踏襲

---

## I. FAQ（8 件アコーディオン）

### レイアウト構造

```
┌──── container（1120px）─────────────────┐
│ H1（中央）: よくあるご質問               │
│                                        │
│ ┌──── 880px 中央 ────┐                  │
│ │ ▸ Q1                │                  │
│ │ ─────────           │                  │
│ │ ▸ Q2                │                  │
│ │ ─────────           │                  │
│ │ ...8 件             │                  │
│ └──────────────────┘                    │
└────────────────────────────────────────┘
   背景: section--surface（純白）
```

### 要素詳細
- `<section class="section section--surface">` で白背景
- `.faq-list`（max-width 880px / 中央寄せ）
- `<details class="faq-item">` × 8
- アコーディオンのインジケータは `＋ → ×（45deg 回転）` で 200ms
- 初期状態は全部 closed

### 関連コピー
lp-copy-2026-05.md セクション I 完全踏襲（8 問）

---

## J. 最終 CTA

### レイアウト構造

```
┌──────────────────────────────────────────┐
│ [背景: 苔緑 ベタ塗り]                    │
│                                          │
│   H1（中央・古紙文字）:                  │
│     キャディが、開く。                   │
│     その朝を、ご一緒しませんか。         │
│                                          │
│   サブ（古紙文字・opacity 0.85）:        │
│     ファウンダーズプランは、先着 100…    │
│                                          │
│   [残数バッジ]                           │
│                                          │
│   [Primary CTA]                          │
│   [Secondary CTA]                        │
│   [Ghost: お電話でのご相談]              │
│                                          │
│   最後の1文（小・古紙・opacity 0.6）     │
│                                          │
└──────────────────────────────────────────┘
   padding-block: 120px、テキスト中央寄せ
```

### 要素詳細
- `<section class="section section--primary">` で苔緑ベタ塗り
- H1, サブ, バッジ, CTA, 注記すべて中央寄せ
- H1 は `color: var(--color-bg)`（古紙）に inline override
- CTA は 3 つ縦並び（Primary / Secondary / Ghost）
  - Primary（朱）: 「無料で始める」
  - Secondary（古紙アウトライン）: 「事業内容資料（PDF）をダウンロード」  
    ※ section--primary 内では secondary を見直し（border は古紙 #F5F0E6、文字も古紙）
  - Ghost: 「お電話でのご相談はこちら [TBD]」
- 中央寄せのため `<div class="col" style="align-items:center; gap:var(--space-3); max-width:480px; margin:auto;">`

### モバイル時
- そのまま縦並び
- CTA は幅 100%

### 関連コピー
lp-copy-2026-05.md セクション J 完全踏襲

### section--primary 内のボタン色調整（追加 CSS）

framework.css に以下を追記するか、HTML inline で：

```css
.section--primary .btn--secondary {
  color: var(--color-bg);
  border-color: var(--color-bg);
}
.section--primary .btn--secondary:hover {
  background: var(--color-bg);
  color: var(--color-primary);
}
.section--primary .btn--ghost {
  color: var(--color-bg);
}
```

---

## K. Footer（法人取引仕様）

components.md §12 の HTML をそのまま使用。

### 要素詳細
- 4 列構成（desktop） / 2 列（tablet） / 1 列（mobile）
- 苔緑ベタ塗り背景
- 各列のタイトル（h4）は uppercase + letter-spacing wide + opacity 0.7 で SaaS フッターの定番感
- copyright は中央寄せ・極小・opacity 0.5

### 関連コピー
lp-copy-2026-05.md セクション K 完全踏襲（住所・電話は [TBD] のまま）

---

## セクションリズム（背景の交互配置）

視覚的疲労を避けるため、背景を交互に切り替える：

| セクション | 背景 |
|---|---|
| Header | rgba(245,240,230,0.92) + backdrop-blur |
| A. Hero | bg画像 + 古紙ベール |
| B. Alert Bar | 苔緑 |
| C. 課題 | 古紙オフホワイト（地のまま） |
| **D. 解決** | **白（section--surface）** |
| E. 大学生キャディ | 古紙オフホワイト |
| F. 仕組み | **白（section--surface）** |
| **G. 料金** | **白（section--surface）** ※ E から続けて白の場合は E を白に変更 OR G を地のままに |
| H. 安心 | 古紙オフホワイト |
| **I. FAQ** | **白（section--surface）** |
| J. 最終 CTA | 苔緑（section--primary） |
| K. Footer | 苔緑 |

リズム調整は visual-implementer 判断。基本は **「2 セクションごとに地と白を入れ替え」**＋「Alert Bar / 最終 CTA / Footer は苔緑」の規則。

---

## アセット配置と参照パス

| アセット | 配置 | 用途 |
|---|---|---|
| `/assets/hero-main.png` | A. Hero | 背景全面 |
| `/assets/caddies-portrait.png` | E. 大学生キャディ | セクション中央の人物写真 |
| `/assets/logo-wordmark.png` | Header / Footer | 28px 高（header） / 自然サイズ（footer は文字ロゴ） |
| `/assets/logo-symbol.png` | favicon | `<link rel="icon">` |
| `/assets/og-image.png` | OG タグ | SNS シェア |
| `/assets/og-image-raw.png` | 元データ | visual-implementer が後加工して og-image.png を生成 |

---

## モバイル時の特別な配慮

| セクション | desktop | mobile |
|---|---|---|
| A. Hero | 80vh, 左寄せ | 90vh, グラデ縦方向 |
| B. Alert | 横並び 3 項目 | flex-wrap、divider 消す |
| D. 対比表 | 2 列テーブル | 縦積み、`従来：` / `Caddygate：` ラベル付与 |
| E. カード | 3 列 | 1 列 |
| F. ステップ | 4 列 | 1 列 |
| G. Pricing | 3 列 | 1 列、ファウンダーズが最上段 |
| J. CTA | 中央 | 中央、CTA 幅 100% |
| K. Footer | 4 列 | 1 列 |

詳細は responsive.md 参照。

---

## アクセシビリティ・チェックリスト

- [ ] `<html lang="ja">` 必須
- [ ] H1 はページ内 1 個（ヒーローのみ）
- [ ] フォーム入力欄は `<label>` 必須、`for` と `id` 対応
- [ ] アイコンのみのボタンは `aria-label`
- [ ] FAQ は `<details>/<summary>` で SR 標準対応
- [ ] 色コントラスト: 苔緑×古紙 / 朱×白 ともに WCAG AA 達成
- [ ] フォーカスリングは `:focus-visible` で常時表示
- [ ] `prefers-reduced-motion` でアニメ無効化

---

作成完了: 2026-05-31
次工程: responsive.md でブレイクポイントごとの調整詳細を補完。
