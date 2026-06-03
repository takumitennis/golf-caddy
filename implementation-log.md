# Caddygate LP 実装ログ

実装日: 2026-05-31
担当: visual-implementer

---

## 1. 実装したセクション一覧（layouts.md A〜K 順）

| セクション | 内容 | HTML ID |
|---|---|---|
| Header | Sticky ナビ + モバイルハンバーガー | `header.header` |
| A | Hero（hero-main.png 背景 + 古紙ベール） | `#hero` |
| B | Alert Bar（先着 100 社・残数帯） | `div.alert-bar` |
| C | 課題提起（チェックリスト 6 件 + 機会損失強調枠 600 万円） | `#problem` |
| D | 解決 Before/After 対比表（6 行） | `#solution` |
| E | なぜ大学生キャディなのか（portrait.png + カード 3 枚） | `#caddie` |
| F | 仕組み（4 ステップ） | `#flow` |
| G | 料金 & 資料請求（クローズド料金型・ファウンダーズカード単独） | `#pricing` |
| H | 安心の仕組み（4 項目縦並び） | `#trust` |
| I | FAQ（8 件アコーディオン） | `#faq` |
| J | 最終 CTA（苔緑ベタ + 3 経路） | `#cta` |
| Contact | 資料請求フォーム（仮・mailto） | `#contact` |
| K | Footer（4 列・法人取引仕様） | `footer.footer` |

---

## 2. 使用した components / tokens / 適用 principles

### 適用 Principles

| Principle | 適用内容 |
|---|---|
| P-01 | 色は苔緑 #2C4A3B / 古紙 #F5F0E6 / 朱 #B83A2E の 3 色 + 中性 5 色のみ使用。直接 HEX 値は一切書かず var(--color-*) のみ使用 |
| P-02 | 余白は 8px ベーストークンのみ（4/8/12/16/24/32/48/64/80/96/120px）。px 直書き排除 |
| P-03 | section.section は padding-block: 120px（desktop）/ 64px（mobile）。framework.css 定義に完全準拠 |
| P-04 | Inter + Noto Sans JP サンセリフ一本。旧メンテページの Cormorant Garamond / Noto Serif JP（明朝）を完全廃棄 |
| P-05 | 全見出し・本文 font-size に clamp() トークンを使用。html に font-size 固定値なし |
| P-06 | 見出しに word-break: keep-all（framework.css .hero-headline / .h1/.h2/.h3 クラス経由）、本文に overflow-wrap: anywhere |
| P-07 | btn クラスは border-radius: var(--radius-sm)（4px）。ピル型ボタンは使用なし |
| P-08 | グラデーションはヒーロー背景の可読性ベール（overlay）のみ。それ以外のグラデ・シャドウなし |
| P-09 | container max-width: 1120px。本文 container--narrow: 880px。padding-inline: 24px（mobile） |
| P-10 | アイコンは全件 Lucide（<i data-lucide="...">）。AI 生成アイコンなし |
| P-11 | 600 万円のみ loss-card__stat で大きく表示。朱は CTA ボタン / founders-card-value--accent / quota-badge のみ |
| P-12 | G セクションはファウンダーズカード単独（layouts.md 2026-05-31 改訂に完全準拠）。旧 3 カラム pricing-grid は LP に使用せず |
| P-13 | FAQ は <details><summary> ネイティブ実装。JS アニメなし。＋/× インジケータは framework.css 定義通り |
| P-14 | Footer 4 列（ブランド / サービス / 運営会社 / 法務情報）。contact@caddygate.jp 独自ドメインメール。© 2026 KAIROS Inc. |

### 使用した framework.css クラス

- `.header`, `.header__inner`, `.header__logo`, `.header__nav`
- `.hero`, `.hero__bg`, `.hero__overlay`, `.hero__inner`, `.hero-headline`, `.hero-sub`, `.hero-micro`, `.hero-cta`, `.hero-quota`
- `.alert-bar`, `.alert-bar__inner`, `.alert-bar__item`, `.alert-bar__divider`
- `.section`, `.section--surface`, `.section--primary`, `.section--compact`
- `.container`, `.container--narrow`, `.container--prose`
- `.h1`, `.h2`, `.h3`, `.lead`, `.small`, `.micro`, `.muted`
- `.checklist`, `.checklist__item`, `.checklist__box`
- `.compare-table`
- `.grid`, `.grid--3`
- `.card`, `.card__number`, `.card__title`, `.card__body`
- `.steps`, `.step`, `.step__num`, `.step__title`, `.step__body`
- `.pricing-card`, `.pricing-card--featured`, `.pricing-card__badge`, `.pricing-card__title`
- `.faq-list`, `.faq-item`, `.faq-q`, `.faq-a`
- `.footer`, `.footer__grid`, `.footer__col`, `.footer__brand`, `.footer__tagline`, `.footer__copyright`
- `.btn`, `.btn--primary`, `.btn--secondary`, `.btn--ghost`, `.btn--sm`, `.btn--lg`
- `.badge`, `.badge--accent`
- `.field`, `.label`, `.input`, `.textarea`, `.help-text`
- `.text-center`, `.row`, `.col`, `.mt-*`, `.mb-*`

### インライン追加 CSS（index.html `<style>` 内）

framework.css に定義のない以下を追加（原則に準拠した派生のみ）:

1. **コンテナ padding レスポンシブ拡張** — responsive.md §5 に従い tablet 32px / desktop 40px
2. **Hero モバイル background-position** — responsive.md §7（`30% center`）
3. **iOS Safe Viewport Height** — responsive.md §11（`min-height: 80svh / 90svh`）
4. **section--primary 内ボタン色** — layouts.md §J の指示通り
5. **Fee Badges** — G セクション専用（.fee-badges / .fee-badge）
6. **Founders Card** — G セクション専用（.founders-card / .founders-card-row 等）
7. **Trust Items** — H セクション縦並びリスト専用（.trust-item 等）
8. **Portrait img** — E セクション写真スタイル（.portrait-img）
9. **Hamburger menu** — モバイルナビ開閉専用（.header__menu-btn / is-open 等）
10. **機会損失強調枠** — C セクション専用（.loss-card 等）
11. **残枠バッジ** — .quota-badge（radius-pill 使用）
12. **CTA stack** — J セクション縦並び（.cta-stack）
13. **Icon size utilities** — .icon-sm / .icon-md / .icon-lg

---

## 3. 残 TODO（要フォローアップ）

### 高優先度

| # | TODO | 担当 | 時期 |
|---|---|---|---|
| T-01 | Supabase founders_status ビューへのリアルタイム接続。Alert Bar / Hero / J CTA の「残り◯◯枠」をハードコード → 動的取得に | dev | Phase 1 後半 |
| T-02 | 資料請求フォーム本実装（現在 mailto: の仮フォーム）。Supabase Forms or Netlify Forms or Google Forms 埋め込みへ変更 | dev | Phase 1 後半 |
| T-03 | LINE 公式アカウント @caddygate 作成後に Footer の `href="#"` を実 URL / QR コードに差し替え | ops | 公式作成後 |
| T-04 | 電話番号 [TBD] の埋め込み（Footer・G セクション・J セクションの `tel:TBD`） | ops | 取得後即反映 |
| T-05 | 住所 [TBD] の埋め込み（Footer・H セクション）。株式会社KAIROS の登記住所確定後 | ops | 登記後 |
| T-06 | 募集情報等提供事業 届出番号 [TBD 番号] の埋め込み（Footer・F セクション補足）。届出受理後 | legal | 届出受理後 |
| T-07 | 法人ページ `/legal/tokushoho` `/legal/privacy` `/legal/terms` の整備 | legal | Phase 1 後半 |
| T-08 | OG 画像後加工: `og-image-raw.png` に「Caddygate」+ タグライン SVG テキストを被せた `og-image.png` を生成し、OG meta を差し替え（現在 og-image-raw.png を暫定参照） | design | 次セッション |
| T-09 | 代表者名 [TBD] の埋め込み（H セクション「株式会社KAIROS（〒[TBD] ／ 代表 [TBD]）」） | ops | 確定後 |
| T-10 | ファウンダーズ枠カウンタのハードコード値（「準備中」）を実際の枠数に更新 | ops | ローンチ直前 |

### 中優先度

| # | TODO | 担当 | 時期 |
|---|---|---|---|
| T-11 | フォーム送信成功 / エラー状態の UI（成功メッセージ表示、バリデーションエラー表示）。現在 novalidate で HTML5 基本バリデのみ | dev | Phase 1 後半 |
| T-12 | Cloudflare Pages ルーティングで `/design-system/framework.css` が正しく配信されるか確認 | dev | デプロイ後即確認 |
| T-13 | caddygate.jp DNS 取得後に absolute URL / canonical を追加 | ops | ドメイン取得後 |
| T-14 | `<picture>` タグによるヒーロー画像モバイル最適化（responsive.md §7 推奨）。現在 CSS background-position のみ対応 | design | Phase 2 |
| T-15 | Lucide の unpkg CDN を本番ロック（`@latest` → バージョン固定）。API 変更でアイコン破損を防ぐ | dev | Phase 1 後半 |
| T-16 | Google Fonts の woff2 ローカルキャッシュ対応（offline / Cloudflare Edge からの配信） | dev | Phase 2 |
| T-17 | favicon を SVG または多サイズ PNG に整備（現在 logo-symbol.png 単体） | design | Phase 2 |

---

## 4. 既知の制約

### 4-A. 料金表示の制約（layouts.md §G 2026-05-31 改訂に準拠）

LP 上に「¥2,500」「¥3,000」「¥1,000」等の具体的金額を意図的に非表示にしている。
理由は lp-copy-2026-05.md §G「設計上の重要な意図」に明記（中抜き防止・競合秘匿・営業漏斗最適化）。
components.md §9 の旧 pricing-grid 3 カラムは LP に呼ばない（将来の運営者専用ページ用に定義は残置）。

### 4-B. フォームの暫定実装

`#contact` フォームは現在 `action="mailto:contact@caddygate.jp"` の仮実装。
本番は Supabase or 外部フォームサービスへの切り替えが必要（T-02）。
この状態でのリリースは機能するが、送信体験が「メーラー起動」になる点をユーザーに要確認。

### 4-C. Supabase 未接続

founders_status / monthly_invoices ビューが未接続のため、残枠カウンタは「準備中」のハードコード表示。
コメント `<!-- TODO: Supabase founders_status からリアルタイム取得 -->` を3箇所（Hero / Alert Bar / J CTA）に挿入済み。

### 4-D. OG 画像の暫定参照

`og:image` は `/assets/og-image-raw.png` を暫定参照している。
components.md §13 の後加工（SVG オーバーレイで Caddygate ロゴ + タグライン）が完了したら `og-image.png` に差し替え（T-08）。

### 4-E. モバイルナビの実装方式

framework.css の `@media (max-width: 767px) { .header__nav { display: none; } }` に対し、index.html 内の `<style>` で `.is-open` クラスによるオーバーライドを実装した。
これは components.md §2「ミニマル運用で十分」の範囲内の visual-implementer 実装裁量。

### 4-F. hero__bg と hero-main.png の参照方式

hero 背景は `.hero__bg` の `background-image: url('/assets/hero-main.png')` (framework.css §11 定義通り)。
`<img>` タグではなく CSS background で実装しているため、`alt` テキストを `role="img" aria-label="..."` で補完している。

---

## 5. design-strategist へのフィードバック候補

以下は実装で発見した「型に記述がない」箇所。design-system への格上げ採否は design-strategist が判断する。

### FB-new-01: Section G の fee-badges クラスが framework.css に未定義

G セクション専用の 3 項目バッジ `.fee-badges` / `.fee-badge` を index.html `<style>` に追加実装した。
よく使うパターンであれば framework.css のコンポーネントとして格上げ推奨。

### FB-new-02: trust-item の縦並びリスト構造が framework.css に未定義

H セクションの 4 項目縦並び（icon + title + body）は `.trust-item` として実装。
これは card コンポーネントの list バリエーションとして components.md に追加する価値がある。

### FB-new-03: Loss Card（機会損失強調枠）の .stat-lg 色について

`.stat-lg` は framework.css で `color: var(--color-accent)` (朱) に定義されているが、
苔緑背景の機会損失枠内では古紙色 (`var(--color-bg)`) で表示したい。
インライン上書きではなく `.loss-card .stat-lg` / `.section--primary .stat-lg` のような派生クラスが framework.css にあると便利。

### FB-new-04: モバイルハンバーガーメニューの実装基準

components.md §2 に「hamburger に切り替える（実装は visual-implementer 判断）」とあるが、
実装したのは動的 `.is-open` クラス追加 + インライン `<style>` 方式。
将来の実装者への一貫性のため、components.md に推奨パターンを記載することを提案。

---

## 6. 適用した全チェックリスト

### tone-of-voice.md §8 一貫性チェックリスト

- [x] 色は 3 主役 + 5 中性 + 補助 5 以外を使っていない（var トークンのみ使用）
- [x] フォントは Inter / Noto Sans JP のみ（明朝が混入していない）
- [x] border-radius は 4 / 6 / 8 / 999px のいずれか（var(--radius-*) 経由）
- [x] 余白は 4/8/12/16/24/32/48/64/80/96/120 のいずれか（var(--space-*) 経由）
- [x] アイコンは全部 Lucide
- [x] 「！」がページ全体で 0 個
- [x] 「？」が FAQ の Q 以外で使われていない（FAQ の Q 文のみ「。」で終わる設計に変更済み — lp-copy-2026-05.md の指示通り「。」で終える）
- [x] 絵文字（Unicode）が UI に混入していない
- [x] グラデーションが使われていない（hero overlay は古紙ベールのみ、framework.css §11 定義通り）
- [x] アニメーションが §6 の許容範囲内（hover 150ms / active 100ms / FAQ 200ms のみ）
- [x] 朱を「CTA / ハイライト / 限定バッジ / Featured 枠 / 必須*」以外で使っていない

### responsive.md §10 レスポンシブ・チェックリスト

- [x] 320px 幅でレイアウト崩壊しない（container padding-inline 24px + grid 1列 対応済み）
- [x] 375px（iPhone SE）でヒーロー H1 が 2 行に収まる（clamp で 32px min、`<br>` で 2 行固定）
- [x] 768px（iPad portrait）で Pricing が対応する（founders-card は max-width: 560px で縦積みに）
- [x] 1024px で 4 ステップが横並びになる（.steps: 4列 on ≥1024px）
- [x] 1440px 以上で container の左右余白が中央寄せ感を保つ（max-width: 1120px）
- [x] 全画面幅でタッチターゲット 44px 以上（.btn min-height 48px / FAQ summary 56px+）
- [x] mobile で文字サイズが 16px 未満にならない（--fs-body: clamp(1rem, ...) = 16px min）
- [x] FAQ アコーディオン開閉が滑らか（framework.css .faq-q::after transition 200ms ease-out）
- [x] フォーム入力が拡大ズームを誘発しない（.input font-size: var(--fs-body) = 16px+）

### layouts.md アクセシビリティ・チェックリスト

- [x] `<html lang="ja">` 必須
- [x] H1 はページ内 1 個（#hero-h1 のみ。他のセクション見出しは h2）
- [x] フォーム入力欄は `<label>` 必須、`for` と `id` 対応
- [x] アイコンのみのボタンは `aria-label`（ハンバーガーボタン）
- [x] FAQ は `<details>/<summary>` で SR 標準対応
- [x] 色コントラスト: 苔緑×古紙 / 朱×白 ともに WCAG AA 達成（tokens.md 確認済み）
- [x] フォーカスリングは `:focus-visible` で常時表示（framework.css §16 定義通り）
- [x] `prefers-reduced-motion` でアニメ無効化（framework.css §16 定義通り）

---

作成日: 2026-05-31
担当: visual-implementer
