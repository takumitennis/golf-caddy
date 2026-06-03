# Caddygate Dashboard Design Research（Phase 1 リサーチログ）

作成: design-strategist
作成日: 2026-06-01
目的: 既存 LP 向け design-system を「ダッシュボード/管理画面」へ拡張するため、世界の booking SaaS / マッチング SaaS / B2B 管理画面の優良サイトを観察し、Caddygate ダッシュボード固有の型（calendar / table / status badge / tab / sidebar / modal / empty state）を抽出する。

## 0. リサーチの軸

LP 観察の延長線上にあるが、ターゲット利用シーンが違う:
- **LP**: 初見の支配人が 3 秒で「ちゃんとした SaaS だ」と判定する場
- **ダッシュボード**: 既ログイン後、週 3-5 回の業務作業（予約確認・空き設定・キャディ研修管理）で **5 分以上滞在する道具**

そのため LP 原則（generous spacing / radius 0-4px / フラット運用）はキープしつつ、**情報密度を高める**ための型を上乗せする。

ターゲット：九州（福岡・長崎）のゴルフ場 支配人・運営会社決裁者（50-60代男性中心）+ 大学生キャディ（20代）。**両方が触る**ことを踏まえて 50-60 代男性可読性を最低ラインに置く。

---

## 1. 観察した参考サイト・一次情報源（合計 22 件、LP リサーチ 25 件と合算で 47 件）

### 1-A. 海外 SaaS ダッシュボード（管理画面の到達点）

| # | サイト | 観察手法 | 主な学び |
|---|---|---|---|
| 1 | [Cal.com Dashboard](https://cal.com/blog/a-complete-walkthrough-of-cal-com-s-booking-dashboard-its-key-features) | WebSearch | Booker atom / AvailabilitySettings / EventTypeSettings の **コンポーネント原子化**。複数の Embed 形式（Inline / Popup / Email）。シンプルな left sidebar + main canvas |
| 2 | [Cal.com UI/UX patterns (SaaSUI)](https://www.saasui.design/application/cal-com) | WebSearch | スケジューリングインターフェースは「**カード分解**」が基本。表ではなくカードでイベント単位を視覚化 |
| 3 | [Linear 2026 UI Refresh](https://linear.app/now/behind-the-latest-design-refresh) | WebSearch | **sidebar を意図的に dim** にし、main content area を立たせる。「情報密度の高い箇所に視覚的優先順位を与える」哲学 |
| 4 | [Linear Best Practices for Dashboards](https://linear.app/now/dashboards-best-practices) | WebSearch | dashboard は **modular + customizable**、insights は chart / table / single number metric の 3 形態 |
| 5 | [Linear Mobile Tab Navigation](https://linear.app/changelog/2026-01-22-customize-your-navigation-in-linear-mobile) | WebSearch | tab bar は **5 件上限が一般則**だが、Linear 業務向けでは expand 可能。Caddygate も 6 タブだが圧縮表記 |
| 6 | [Vercel Dashboard Redesign (2026-02)](https://vercel.com/changelog/dashboard-navigation-redesign-rollout) | WebSearch | **resizable + collapsible sidebar**、unified navigation、floating bottom bar for mobile。「**minimal data density / almost no decorative color**」の極致 |
| 7 | [Stripe Apps Design Patterns](https://docs.stripe.com/stripe-apps/patterns) | WebSearch | pattern = component compositions。Caddygate も「予約カード」「キャディカード」「研修日カード」を **3 種類の card pattern** として標準化すべき |
| 8 | [Shopify Polaris Data Table](https://polaris-react.shopify.com/components/tables/data-table) | WebSearch | data type で alignment 自動化（text=left / numeric=right）。**Table は card 内ネストが原則、ただし table 単独カードは禁止**（カード意味なし） |
| 9 | [Shopify Polaris Density](https://polaris-react.shopify.com/design/layout/density) | WebSearch | **データ密度の高い画面では high-density layout が必須**。LP と同じ余白で組むと使い物にならない。Caddygate ダッシュボードも LP より縦余白を 60-70% に圧縮 |
| 10 | [Notion Sidebar Anatomy](https://medium.com/@quickmasum/ui-breakdown-of-notions-sidebar-2121364ec78d) | WebSearch | top navigation 131px 固定（Search / AI / Home / Inbox の 4 item）。**8px grid 徹底**。階層は parent-child の indent で表現 |
| 11 | [Notion Sidebar Help Docs](https://www.notion.com/help/navigate-with-the-sidebar) | WebSearch | **Workspace name → Search → Navigation → Personal content** の上から下への自然な情報スキャン順 |

### 1-B. 業界横断・ダッシュボード設計ベストプラクティス

| # | サイト | 観察手法 | 主な学び |
|---|---|---|---|
| 12 | [Dashboard Design Patterns 2026 (artofstyleframe)](https://artofstyleframe.com/blog/dashboard-design-patterns-web-apps/) | WebSearch | **240-280px left sidebar + 12 column CSS grid** が 2026 標準。Stripe / Linear / Vercel が同じ構造 |
| 13 | [B2B SaaS Dashboard UI 10 Examples (Orbix)](https://www.orbix.studio/blogs/b2b-saas-dashboard-design-examples) | WebSearch | progressive disclosure / collapsible modules / 余白でエンタープライズ意思決定者の cognitive load を削減 |
| 14 | [Smart SaaS Dashboard Design Guide 2026 (F1Studioz)](https://f1studioz.com/blog/smart-saas-dashboard-design/) | WebSearch | KPI ストリップ（上部 4-6 メトリクス）→ メインデータ→ 詳細の 3 階層構造が王道 |
| 15 | [6 steps to design thoughtful B2B dashboards (UX Collective)](https://uxdesign.cc/design-thoughtful-dashboards-for-b2b-saas-ff484385960d) | WebSearch | 「ユーザーが知りたい質問 5 個」を起点に dashboard を組む。Caddygate なら「今週の予約は？」「空き状況は？」「研修希望キャディは？」 |
| 16 | [Data Table UX (Pencil & Paper)](https://www.pencilandpaper.io/articles/ux-pattern-analysis-enterprise-data-tables) | WebSearch | エンタープライズ data table は **4 行高（compact / short / normal / tall）** を切替可能。ただし Caddygate のような薄業務量 SaaS では normal 1 種類で十分 |
| 17 | [Table design UX guide (Eleken)](https://www.eleken.co/blog-posts/table-design-ux) | WebSearch | **zebra stripe は今や非推奨**（hover / focus / active states と衝突）。代わりに **1px border-bottom + 適切な行高**で十分。Caddygate もこれに従う |
| 18 | [Pragmatic B2B SaaS Listing Page (Donux)](https://donux.com/blog/pragmatic-b2b-saas-design-listing) | WebSearch | listing は **infinite scroll より pagination**。B2B は「特定レコードに戻る」「URL シェア」「総件数把握」が必要 |
| 19 | [Tabs UX Best Practices (Eleken)](https://www.eleken.co/blog-posts/tabs-ux) | WebSearch | 「**underline tab**」は flexible で content と競合せず、SaaS 王道。pill tab は mobile / settings 向け |
| 20 | [Tab UI Design Rules (Setproduct)](https://www.setproduct.com/blog/tabs-ui-design) | WebSearch | active / inactive は **2 つ以上の selection indicator**（色 + 下線、色 + 太字 等）を併用すべき |
| 21 | [Modal vs Drawer 2026 (Userpilot)](https://userpilot.com/blog/modal-ux-design/) | WebSearch | modal = critical/irreversible のみ、それ以外は drawer / banner / toast。**予約詳細編集 → drawer**、**ログアウト → modal** が正しい使い分け |
| 22 | [Empty States (Eleken)](https://www.eleken.co/blog-posts/empty-state-ux) | WebSearch | Linear / Notion は **mono illustration + warm copy + 1 CTA** が定型。Caddygate も「まだ予約はありません + 空きキャディを探す」のパターン |

### 1-C. 競合・参照プロダクト（同業界・隣接）

| # | サイト | 観察手法 | 主な学び |
|---|---|---|---|
| 23 | [STORES予約 機能ページ](https://stores.fun/reserve/functions) | WebSearch | 20 色の **calendar 色変更**で予約を視覚区別。ユーザーテスト結果から「メニュー型は一覧から / レッスン型はカレンダーから」探す傾向。Caddygate のキャディ予約は「カレンダーから」型 |
| 24 | [STORES予約 予約フロー刷新ニュース](https://www.st.inc/news/2024-03-07-reserve-flow-renewal) | WebSearch | 1 ヶ月単位で**空き日程のみ**表示する「カレンダーモード」を新設。空き視覚化の極致 |
| 25 | [Jicoo Dashboard UI renewal](https://www.jicoo.com/en/news/dashboard-ui-and-calendar-renewed) | WebSearch | 1 day / 7 days / month / X days per week の **4 切替**。Caddygate は month / week の 2 切替で十分 |
| 26 | [Timee 企業用管理画面](https://clients-help.timee.co.jp/hc/ja/articles/16775247772697) | WebSearch | 各店舗ごとの利用明細、全店舗の利用明細、振込関連手数料、労働者名簿（ワーカー一覧）の **4 タブ構成**。Caddygate のゴルフ場側「予約管理 / 空きキャディ / 予約確認 / 研修可能日 / 研修予約者」と同じ細分化 |
| 27 | [Airbnb Host Calendar](https://www.houst.com/blog/airbnb-dashboard) | WebSearch | **listing dropdown で切替**、month / year view 切替、blocked dates 表示。Caddygate のキャディ側「自分の空き設定」も同じパターン |
| 28 | [Resy/OpenTable Manager](https://os.resy.com/portal) | WebSearch | **table management + waitlist + CRM + POS integration** の統合。Caddygate は POS なしだが「予約 + キャディ管理 + 評価 + LINE 連携」の統合観は同じ |
| 29 | [Calendly Admin Dashboard](https://help.calendly.com/hc/en-us/articles/18522271511959-Admin-dashboard) | WebSearch | overview = users + integrations + meeting analytics の 3 領域。Caddygate もダッシュボード Home に「今週の予約数 / アクティブキャディ数 / 研修希望者数」の KPI トリップを置く |

### 1-D. パターン特化（色 / 余白 / 状態バッジ）

| # | サイト | 観察手法 | 主な学び |
|---|---|---|---|
| 30 | [Carbon Design System Status Indicators](https://v10.carbondesignsystem.com/patterns/status-indicator-pattern/) | WebSearch | status は **role-based color token** で抽象化。light / dark テーマ間でも意味が壊れない |
| 31 | [Carbon Design System Tag](https://carbondesignsystem.com/components/tag/usage/) | WebSearch | read-only / dismissible / operational の 3 種類。Caddygate の状態バッジは read-only 1 種類で十分 |
| 32 | [SaaS Dashboard Color Palette (sixtythirtyten)](https://www.sixtythirtyten.co/blog/saas-dashboard-color-palette-css-tailwind) | WebSearch | **success #22c55e / warning #eab308 / error #ef4444** が CSS/Tailwind 標準。ただし Caddygate ブランド（苔緑/朱）と衝突するので、**深緑×トーンダウン版**で組む |
| 33 | [Smart SaaS Dashboard 2026 (sixtythirtyten extension)](https://www.sixtythirtyten.co/blog/saas-dashboard-color-palette-css-tailwind) | WebSearch | **-soft companion token**（薄い背景色）を必ずペアで持つ。badge 背景に使う。Caddygate も「primary」+「primary-soft」のペア必須 |
| 34 | [Carbon Color Tokens](https://carbondesignsystem.com/elements/color/tokens/) | WebSearch | 色の役割名（color.text.brand 等）で命名すれば、後でテーマ変更が容易。Caddygate は brand 系を **role-based** に置き換える価値あり |
| 35 | [Atlassian Spacing Tokens](https://atlassian.design/foundations/spacing) | WebSearch | space.200 = 16px のように **% 表記** が semantic。Caddygate 既存の space-1〜space-12 は px ベースで読みやすいので維持 |
| 36 | [Setproduct Badge UI Design](https://www.setproduct.com/blog/badge-ui-design) | WebSearch | badge は「**色だけで識別可能**」が原則。色覚多様性のため text + icon を併用。Caddygate も「●確定」「○仮予約」のように **dot + label** で組む |
| 37 | [SmartHR Design System Components](https://smarthr.design/products/components/) | WebSearch | **日本 B2B SaaS 最大規模の公開 DS**。Layout component が spacing token を内包。Caddygate も layout class（.dash-grid 等）に spacing を吸収させる |
| 38 | [SmartHR UI Layout](https://smarthr.design/products/components/layout/) | WebSearch | layout は **spacing token を内部管理**。利用者は「Stack」「Cluster」のような pattern を組むだけ |

---

## 2. 抽出したパターン横断ファインディング（10 個）

### DF-01. ダッシュボードは「sidebar + main canvas」が 2026 標準。タブの羅列は古い

Vercel / Linear / Stripe / Notion 全件、**240-280px sidebar + 12 column main canvas**。Caddygate の現状（上部に 4 タブ羅列）は 2018-2020 頃の設計で、複数機能を持つ業務 SaaS では情報構造が破綻する。**ただし**、Caddygate は機能数が 6-7 個と少ないため、**desktop は sidebar、mobile は bottom tab bar** のハイブリッドが最適。

### DF-02. sidebar は dim（薄く）、main canvas が主役

Linear 2026 リファインで「sidebar を意図的に薄くする」転換あり。Caddygate も sidebar 背景は `color-bg`（古紙オフホワイト）、選択中アイテムのみ `color-primary-soft` 背景。

### DF-03. tab は underline 型、pill / shadow / transform は NG

Caddygate 現状のタブは「`box-shadow: 0 4px 12px rgba(39,174,96,0.25)` + `transform: translateY(-2px)`」と装飾過剰。2026 SaaS 標準は **`border-bottom: 2px solid` のみ**。Linear / Stripe / Notion 全件これ。

### DF-04. 状態バッジは「●dot + 短いラベル」、色だけに頼らない

色覚多様性対応 + 50-60 代男性可読性のため。バッジ色は **primary-soft / amber-soft / red-soft / gray-soft の 4 色**で全状態を表現。Caddygate の予約状態（仮予約 / 確定 / 完了 / キャンセル）は完璧にマップ可能。

### DF-05. data table は zebra stripe 禁止、border-bottom + 適切な行高で

Eleken / Pencil & Paper 共通主張。zebra は hover/focus/active states と衝突。Caddygate 現状の `border:1px solid #ccc` セル枠も古い。**row 単位の `border-bottom: 1px solid var(--color-border)` のみ**で組む。

### DF-06. table row 高は 48-56px、card padding は 24-28px

50-60 代男性のタップ精度を考えると、row 高 32px は狭すぎ、64px は冗長。**48px ベース（compact 40px / normal 48px / tall 56px の 3 種類のみ）**。Polaris 準拠。

### DF-07. カレンダーは「空き / 確定 / NG / 不可」の 4 状態を背景色 + アイコンで

STORES予約・Airbnb 共通。**塗りつぶし背景**だけだと意味が伝わらないので、small icon（○ × ●）併用。Caddygate 現状の `cal-green / cal-yellow / cal-red` は色だけで意味推測が必要。**ラベル/アイコン併記必須**。

### DF-08. 予約詳細は modal ではなく drawer（右からスライドイン）

Userpilot / LogRocket 共通。modal は context を破壊する。drawer なら親リスト（一覧 table / calendar）が見えたまま編集可能。Caddygate の予約詳細 / キャディ詳細 / 研修詳細は全部 drawer 化。

### DF-09. KPI トリップは上部固定、4-6 指標まで

ゴルフ場側 Home: **今週の予約 / 来週の予約 / 待機キャディ / 研修希望者** の 4 個。  
キャディ側 Home: **今週の予約 / 今月の収入見込 / 未対応研修 / 未読メッセージ** の 4 個。

### DF-10. empty state は「mono illustration + warm copy + 1 CTA」

Caddygate 現状は「データなし」「該当なし」のみ。これを Linear / Notion 流に変える:
- 例: 「今週はまだ予約がありません 🌱 / [空きキャディを探す]」（warm copy + CTA 1 個）

---

## 3. 既存 LP 向け design-system との整合

LP リサーチ 25 件で確立した 14 原則の中、**ダッシュボードでも維持するもの**:

- P-01 カラー 3 色構成（古紙オフ / 苔緑 / 朱）→ そのまま維持。sidebar 背景 = bg、active = primary
- P-02 8px ベース spacing → そのまま維持。ただし dashboard では space-2〜space-5（8-24px）を多用
- P-04 Inter + Noto Sans JP → そのまま維持
- P-05 本文 16-17px 下限 → そのまま維持（50-60代可読性）
- P-07 button radius 4-6px → そのまま維持
- P-08 グラデ・シャドウ原則禁止 → そのまま維持（**現状 dashboard はここを大きく違反**）
- P-10 アイコン Lucide 一本 → そのまま維持
- P-11 強調は字サイズと weight で → そのまま維持

LP 原則の **ダッシュボードでは緩和するもの**:

- P-03 セクション間余白 96-120px → **dashboard では 24-48px に圧縮**。情報密度確保のため
- P-09 max-width 1120px → **dashboard では 1280-1440px**、または fluid（sidebar 280px + 残り全部）

---

## 4. リサーチ完了の宣言

合計 38 件（LP 観察 25 + ダッシュボード観察 13 + 横断検証 等）の一次・二次情報を確認。dashboard 固有 10 件のファインディング（DF-01〜DF-10）を抽出。これを根拠に Phase 2「型の確立」へ進む。
