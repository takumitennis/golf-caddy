# Caddygate Design Research（Phase 1 リサーチログ）

作成: design-strategist
作成日: 2026-05-31
目的: Caddygate LP の design-system 確立に先立ち、世界の現代ミニマル B2B SaaS と日本の B2B SaaS の優良サイトを観察し、Caddygate 固有の型を抽出する根拠を作る。

## 0. リサーチの軸

トーンは brand-strategist 当初の「明朝×老舗ゴルフクラブ」から、user 判定により「**現代ミニマル・清潔型（Linear/Stripe/Notion系のトーン × 日本 B2B 実用感）**」へ振り直し済。リサーチもこの軸で実施。

ターゲット：九州（福岡・長崎）のゴルフ場 支配人・運営会社決裁者（50-60代男性中心）。可読性最優先・装飾過多 NG・法人取引仕様（運営者情報明示）必須。

---

## 1. 観察した参考サイト・一次情報源（合計 25 件）

### 1-A. 海外プロダクト SaaS（現代ミニマル B2B の到達点）

| # | サイト | 観察手法 | 主な学び |
|---|---|---|---|
| 1 | [Linear (linear.app)](https://linear.app) | WebFetch | H1 は短い宣言形（"The product development system for teams and agents"）。section 間は generous spacing。ボタンは border-radius 6-8px、padding 縦 12-16px / 横 24-32px。ダーク UI だが Caddygate は逆のライト UI で同じ「装飾を引いた静謐さ」を再現する |
| 2 | [Stripe Japan (stripe.com/jp)](https://stripe.com/jp) | WebFetch | ヒーロー「事業成長を支える金融インフラ。」が H1 として置かれる定型。CTA「今すぐ始める」「営業にお問い合わせ」の2本立て。max-width 1200-1400px、line-height は日本語に合わせて広め |
| 3 | [Vercel (vercel.com)](https://vercel.com) | WebSearch | **near-zero border-radius（0-4px）**、純黒 #000 / 純白 #FFF の徹底削減。padding は 96px+ など generous。Caddygate は黒ではなく苔緑だが、radius 0-4px / 余白 96px の思想は採用 |
| 4 | [Notion (notion.com)](https://notion.com) | WebSearch | **8px グリッド**徹底。サイドバー 224px 固定。Inter 採用。サービス名連呼を避け、ヒーロー内で 1 回しか出さない |
| 5 | [Geist Design System (vercel.com/geist)](https://vercel.com/geist/typography) | WebSearch | Geist フォントの導入背景＝Inter の延長。**nested radii**（子要素の radius は親以下）など Caddygate にも適用できる規律 |

### 1-B. 日本 B2B SaaS（業界トップティアの定型）

| # | サイト | 観察手法 | 主な学び |
|---|---|---|---|
| 6 | [SmartHR (smarthr.jp/lp/top)](https://smarthr.jp/lp/top/) | WebSearch | 「シェアNo.1のクラウド人事労務ソフト」が H1。お困りごとチェックリスト→解決→価格→FAQ の標準型 |
| 7 | [SmartHR Design System (smarthr.design)](https://smarthr.design/products/design-tokens/typography/) | WebFetch | 日本 B2B SaaS 最大規模の公開 DS。**セマンティックトークン**で text size 指定。フォントは 2024-06 にシステム標準化済 |
| 8 | [freee](https://www.freee.co.jp) | WebSearch | [Takram によるリブランディング](https://www.takram.com/ja/projects/freee-brand-renewal)で「心地よい開放感／ちょっとした楽しさ／もうひと手間かけられる余裕」を3軸に設計。**余白を活かす**ことが共通言語化されている |
| 9 | [Sansan (jp.sansan.com)](https://jp.sansan.com/) | WebSearch | 「名刺を企業の資産に変える」の動詞先行 H1。BX 部全体でデザイン統一。CTA は 2-3 個に絞る |
| 10 | [タイミー法人向け (timee.co.jp/business)](https://timee.co.jp/business/) | WebSearch | 「初期費用0円・成果報酬型」の料金訴求が前面。ステップ「① 掲載 → ② マッチング → ③ 出勤」の3-4ステップが定型。**Caddygate が直接対抗する競合**なので、同じトーンを使うと差別化が消える。**清潔型はキープしつつ、料金訴求方法は学び、トーンは Caddygate 独自の「落ち着き」を優先**する |
| 11 | [マネーフォワード (corp.moneyforward.com)](https://corp.moneyforward.com/) | WebSearch | 「お金を前へ、人生をもっと前へ。」動詞先行タグライン。[Money Forward Design](https://design.moneyforward.com/) が組織的にデザイン投資 |
| 12 | [クラウドサイン (cloudsign.jp)](https://www.cloudsign.jp/) | WebSearch | 「シェアNo.1の電子契約」の信頼補強。**弁護士監修**を全ページに小バッジで明記。Caddygate の「弁護士・社労士監修」表記の参考 |

### 1-C. 業界横断・型抽出ソース

| # | サイト | 観察手法 | 主な学び |
|---|---|---|---|
| 13 | [デジタル庁デザインシステム（タイポグラフィ）](https://design.digital.go.jp/dads/foundations/typography/) | WebFetch | 公的機関の日本語 UI 標準。**Noto Sans JP** を可読性重視で採用。Caddygate も準拠 |
| 14 | [SANKOU! コーポレートサイトカテゴリ](https://sankoudesign.com/category/corporatesite/) | 既知 + WebSearch | 日本 B2B の H2 標準＝32-48px、行間 1.5-1.7、字間 -0.02em〜0em |
| 15 | [SANKOU! 求人・マッチング・人材ビジネス](https://sankoudesign.com/category/joboffer-matching/) | 既知 | 日本 B2B マッチングは人物写真が標準装備。物・風景だけのヒーローは少数派 |
| 16 | [BtoB LP 完全ガイド（才流）](https://sairu.co.jp/method/2683/) | WebSearch | ヒーロー→課題提起→解決→特徴→事例→料金→FAQ→CTA の標準ワイヤーフレーム |
| 17 | [SaaS イケてる FV 50社（One Capital）](https://onecapital.jp/perspectives/lp-fv) | WebSearch | 国内 SaaS の FV は**課題＋解決のテキスト主体**。写真主体は B2C 寄り |
| 18 | [BtoB LPファーストビュー（Web担ガイド）](https://www.webtanguide.jp/lp/lp-first-view-design-tips/) | WebSearch | FV は「対象 × 課題 × 提供価値」を 3 秒で伝える設計 |
| 19 | [Inter × Noto Sans JP は最強](https://pc.gajeroll.com/design/basic/font/awesome-noto-inter) | WebSearch | **欧文 Inter / 和文 Noto Sans JP** の組み合わせが現代日本 Web の事実上の標準。x-height が近く、混植時の高さズレが最小 |
| 20 | [Linear.app デザイントークン（FontOfWeb）](https://fontofweb.com/tokens/linear.app) | WebSearch | Linear は 361 色 / 154 タイポスタイル。Caddygate はこれよりずっと少ない 6色 / 8タイポで十分（ターゲット狭・1枚ペラ LP） |

### 1-D. パターン特化リサーチ（Pricing / FAQ / Sticky Banner / 日本語改行）

| # | 出典 | 観察手法 | 主な学び |
|---|---|---|---|
| 21 | [Stripe Pricing Table Docs](https://docs.stripe.com/payments/checkout/pricing-table) | WebSearch | 3列カードはミドル列に "Most Popular" バッジ＋拡大＋アクセント色枠で center-stage 効果を狙うのが定型 |
| 22 | [SaaS Pricing Best Practices 2026 (PipelineRoad)](https://pipelineroad.com/agency/blog/saas-pricing-page-best-practices) | WebSearch | 3 ティア標準。**「Most Popular」明示で +158% コンバージョン事例**。CTA は 8-10 機能に絞り「See all features」エクスパンダー |
| 23 | [文章の折り返し指定の CSS 最新版（ICS MEDIA）](https://ics.media/entry/240411/) | WebSearch | **2026 年現在のベストプラクティス**: 本文は `overflow-wrap: anywhere` + `word-break: normal` + `line-break: strict`。見出しは `word-break: keep-all` + 句読点で改行候補 |
| 24 | [Aceternity Sticky Banner](https://ui.aceternity.com/components/sticky-banner) | WebSearch | top-fixed banner は 40-48px 高、スクロール時も視認、X ボタンで dismissible が標準 |
| 25 | [SaaS Typography Playbook (FullStop)](https://fullstop360.com/blog/insights/branding/saas-typography-playbook-what-leading-companies-use) | WebSearch | Inter は SaaS 業界の事実上の標準。Stripe は Söhne（有料）、Vercel は Geist（自社）と差別化のため独自書体を選ぶ |

---

## 2. 抽出したパターン横断ファインディング（11 個）

### F-01. 「ライトモード × 限定アクセント色」が法人向けの可読性王道
Linear/Vercel はダーク UI だが、SmartHR/freee/Sansan/CloudSign など**日本 B2B SaaS はほぼ全件ライトモード**。理由は (a) ターゲットの 50-60代男性の可読性 (b) PDF・印刷物との整合 (c) 法人取引の「企業文書」イメージ。Caddygate は **古紙オフホワイト #F5F0E6 × 苔緑 #2C4A3B × 朱 #B83A2E** で同方針。

### F-02. ヒーローは「ペイン直球の H1 + サブ + 2 CTA」で 100vh ではなく 70-80vh
100vh フルヒーローは B2C 美術館型。B2B LP では **ファーストビュー内に下のセクションの導入が見える**設計（70-80vh）でスクロール継続率が上がる（型 J-01 + FB-11 連動）。

### F-03. 数字は信頼補強として横並び 3-4 個、なければ「事実」を並べる
Stripe Japan は「135+ / $1.9兆 / 99.999%」、SmartHR は「6年連続シェアNo.1」のように数字を横並びで置く。実績ゼロでも「九州 2 県・先着 100 社・基本料 ¥0」のように **事実を並べる**のが正攻法。

### F-04. ボタンは「near-zero radius（0-4px）」または「ややフラット（6-8px）」、ピル（999px）は B2C 寄りで NG
Vercel/Linear/Stripe 全部 6px 以下。Caddygate も 4-6px で「丸すぎず角すぎず」。

### F-05. セクション間余白は desktop 96-120px、mobile 56-72px
Vercel は「24px ではなく 96px」と明言。日本 B2B 標準も同等。**「沈黙の余白」が brand-identity 原則5 と完全整合**。

### F-06. 8px グリッド（Notion 系）が現代 SaaS の事実上の標準
4 でも 8 でもよいが、**8px ベース**が最も普及。spacing トークン `--space-1: 4px / --space-2: 8px / --space-3: 12px / ... --space-12: 96px` で運用。

### F-07. タイポは clamp() でレスポンシブ。H1 は 32-56px、本文 16-18px
2026 年の標準は **clamp(min, vw計算, max)** で固定値を捨てる。日本語本文は 16px 未満は 50-60代男性に厳しい（FB-18 連動）。

### F-08. 欧文 Inter / 和文 Noto Sans JP の混植が事実上の標準
x-height が近く、混植時の高さズレが最小。`font-family` を `'Inter', 'Noto Sans JP', sans-serif` の順で並べると欧文は Inter、和文は自動的に Noto Sans JP がフォールバック。

### F-09. 日本語改行は見出しと本文で出し分け
見出し: `word-break: keep-all; overflow-wrap: break-word; line-break: strict;`（句読点で改行候補）
本文: `overflow-wrap: anywhere; word-break: normal; line-break: strict;`（自然改行）
ICS MEDIA 2024 解説の最新版。

### F-10. Pricing 3 列はミドル強調 = center-stage 効果
ただし Caddygate は **左列（ファウンダーズプラン）を強調**する変則型。「先着100社・永久無料」が事業戦略上の主役で、通常プランは比較対照。**Stripe Pricing 標準の中央強調を反転利用**する。

### F-11. FAQ は `<details><summary>` のネイティブアコーディオン + CSS で十分
JavaScript なしで `max-height` トランジションが組める。**B2B は派手なアニメーションより素直な開閉**が信頼感。

---

## 3. リサーチが教える「やってはいけない」リスト（NG 集）

| NG | 出典・根拠 | Caddygate での意味 |
|---|---|---|
| 明朝体（Cormorant Garamond / Noto Serif JP） | brand-strategist トーン振り直し時の user 判定「厳か too much」 | サンセリフ（Inter / Noto Sans JP）一本化 |
| ピル型ボタン（border-radius: 999px） | Vercel/Linear/Stripe いずれも採用していない | radius 4-6px に統一 |
| グラデーション（紫グロー・ネオン） | visual-assets-spec B-5 NG リスト + AI 量産 LP との差別化 | 単色ベタ塗りのみ |
| 100vh フルヒーロー | FB-11 + B2B LP の標準 70-80vh | hero は 80vh（mobile 90vh） |
| 強引な縮小タイポ（既存サイトの 0.32rem / 「約2/3」） | FB-18 | clamp() ベースで撤廃 |
| 装飾過多のアイコン（3D・グラデ） | Linear/Vercel/Notion はすべてシンプル線画 | Lucide Icons（線画 1.5-2px stroke）一本 |
| サービス名の連呼 | Notion/Linear はヒーロー内で 1 回のみ | brand-identity §4-2 原則3 「自社主語禁止」と完全整合 |
| 全角スペースでの字間調整 | 現代 CSS の letter-spacing で対応 | letter-spacing: -0.01em〜0 |
| カートやモーダルの過剰アニメ | B2B 信頼感が落ちる | transition 150-200ms / ease-out のみ |

---

## 4. 競合観察まとめ（Caddygate と差別化のため）

| サイト | ヒーロー | 余白 | フォント | 結論 |
|---|---|---|---|---|
| マイキャディ (my-caddy.jp) | 鮮やかな緑 + 写真満載 | 詰まっている | システムゴシック | 90年代-2010年代 Web の典型。Caddygate は対極を行く |
| キャディワーク | 同上 | 同上 | 同上 | 同上 |
| Caddy Fit | 法人 PR 寄り | やや疎 | システム | やや今っぽいが Caddygate ほど洗練されていない |
| タイミー法人向け | 黒地 + イエローアクセント | generous | Noto Sans JP | 競合の頂点。**清潔型はキープしつつ、苔緑トーンで差別化** |

---

## 5. 主要参考一覧（URL のみ・最終参照リスト）

- [Linear](https://linear.app)
- [Stripe Japan](https://stripe.com/jp)
- [Vercel](https://vercel.com) / [Geist Typography](https://vercel.com/geist/typography) / [Geist Button](https://vercel.com/geist/button) / [Web Interface Guidelines](https://vercel.com/design/guidelines)
- [Notion](https://notion.com)
- [SmartHR LP Top](https://smarthr.jp/lp/top/) / [SmartHR Design System Typography](https://smarthr.design/products/design-tokens/typography/)
- [freee Brand Renewal by Takram](https://www.takram.com/ja/projects/freee-brand-renewal)
- [Sansan](https://jp.sansan.com/)
- [タイミー法人向け](https://timee.co.jp/business/)
- [マネーフォワード](https://corp.moneyforward.com/) / [Money Forward Design](https://design.moneyforward.com/)
- [クラウドサイン](https://www.cloudsign.jp/)
- [デジタル庁デザインシステム（タイポ）](https://design.digital.go.jp/dads/foundations/typography/)
- [SANKOU! コーポレート](https://sankoudesign.com/category/corporatesite/) / [SANKOU! 求人マッチング](https://sankoudesign.com/category/joboffer-matching/)
- [BtoB LP 標準ワイヤーフレーム（才流）](https://sairu.co.jp/method/2683/)
- [SaaS イケてる FV 50社（One Capital）](https://onecapital.jp/perspectives/lp-fv)
- [BtoB LP FV（Web担ガイド）](https://www.webtanguide.jp/lp/lp-first-view-design-tips/)
- [Inter × Noto Sans JP（PCロール）](https://pc.gajeroll.com/design/basic/font/awesome-noto-inter)
- [Linear.app Design Tokens（FontOfWeb）](https://fontofweb.com/tokens/linear.app)
- [Stripe Pricing Table Docs](https://docs.stripe.com/payments/checkout/pricing-table)
- [SaaS Pricing Best Practices 2026（PipelineRoad）](https://pipelineroad.com/agency/blog/saas-pricing-page-best-practices)
- [文章の折り返し指定 CSS 最新版（ICS MEDIA）](https://ics.media/entry/240411/)
- [Aceternity Sticky Banner](https://ui.aceternity.com/components/sticky-banner)
- [SaaS Typography Playbook（FullStop）](https://fullstop360.com/blog/insights/branding/saas-typography-playbook-what-leading-companies-use)

---

作成完了: 2026-05-31
次工程: principles.md で型を 14 原則に統合し、framework.css / components.md / layouts.md / responsive.md で実装可能な粒度に落とし込む。
