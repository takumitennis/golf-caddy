# LP Visual Redesign Research — 2026-06-01

## 目的
古紙ベージュ基調 (#F5F0E6) を白基調へ振り替え、modern B2B SaaS の「白 + 1 アクセント」ルールに揃える。
ダッシュボード側は dashboard-framework.css で既に白基調 + near-black (#18181B) accent に振り替え済み。LP もこれに揃えてプロダクト全体の言語を統一する。

## 観察したリファレンス（2026-06-01）

### 海外 modern SaaS
- **Linear (linear.app)** — ダーク基調だが design language は最小主義。H1 48-64px、generous 60-120px section padding、subtle 1px low-contrast borders、minimal drop shadow、accent は cyan punctuation
- **Vercel (vercel.com)** — near-white 背景、large bold headline、accent は near-black、subtle card border + rounded、generous vertical spacing、grid based feature blocks
- **Stripe (stripe.com / Japan)** — 白背景 + blue accent、CTA は solid blue fill、subtle dividers、generous breathing room、testimonial カードは soft background + 小さい引用書式

### 共通パターン (research articles 2026)
1. **clean white space + vibrant accent for focus** — 全画面アクセント色ベタは時代遅れ。punctuation として使う
2. **conversion-centric minimalism** — 1 primary CTA、reduced visual clutter
3. **split layouts** — text と visual が equal weight（特に B2B）
4. **neon/accent as contrast not dominance** — high-vibrancy 色は paragraph ではなく punctuation
5. **subtle card borders (1px low-contrast gray) over heavy shadow**

### 日本 SaaS パターン
- **freee / SmartHR** 系: 白背景 + ブランドカラー（青系）アクセント、Noto Sans JP 700w で見出し、本文 line-height 1.7、letter-spacing 0.02em で和文を息継がせる
- **Sansan / マネーフォワード** 系: 白基調 + 控えめなブランド色 (deep navy / deep green)、CTA は ブランド色 solid fill、コンタクトは ghost button

## 採用パレット（LP 用 token override）

LP は Caddygate ブランドの深緑 #2C4A3B を maintain しつつ、背景・border・全面アクセントを白基調 + neutral へ振り替え：

| 用途 | 旧 | 新 | 備考 |
|---|---|---|---|
| `--color-bg` | #F5F0E6 古紙ベージュ | **#FFFFFF** | dashboard と同じ純白 |
| `--color-surface` | #FFFFFF | #FFFFFF | 維持 |
| `--color-surface-alt` | #FAF7F0 古紙オフホワイト | **#FAFAFA** | 中間 zebra |
| `--color-border` | #E8E2D5 ベージュ枠 | **#E5E7EB** | neutral gray |
| `--color-primary` | #2f8f2f 鮮緑 | **#2C4A3B** | 苔緑（深さを取り戻す。H1色・active 用） |
| `--color-primary-deep` | #1e5f1e | **#1F3A2D** | dashboard と統一 |
| `--color-primary-soft` | #4caf50 | **#E8F2E8** | 苔緑 soft bg（バッジ用） |
| `--color-accent` | #A88C5F 金茶（上書き済み） | **#18181B** | near-black CTA |
| `--color-accent-deep` | #8E7140 | #0A0A0A | near-black hover |
| `--color-ink` | #1A1A1A | **#0F172A** | 純黒より softer ink |
| `--color-ink-sub` | #5C5C5C | **#475569** | neutral slate |
| `--color-ink-mute` | #8A8A8A | **#94A3B8** | neutral slate mute |

## ルール

1. **背景は白 (#FFFFFF) を地として広く使う**。section--alt は #FAFAFA（ベージュ廃止）
2. **全画面深緑ベタ (section--primary) 廃止** → 白背景の中に「深緑カード」or 「左ボーダー強調 + 白背景」で controlled に
3. **CTA primary は near-black (#18181B)**、secondary は深緑アウトライン、ghost は muted ink
4. **Loss card (40 万円) は全画面ベタ廃止** → 白背景 + 細枠 + 数字だけ深緑大文字で強調
5. **Pricing カードは zebra 廃止**、border は #E5E7EB のみ、行間 padding 増
6. **見出し階層 3 段大胆**:
   - H1 (hero / section): 36-56px / weight 700-900 / letter-spacing -0.02em / line-height 1.18-1.25
   - H2: 28-40px / weight 700 / -0.015em / 1.2
   - H3: 18-22px / weight 600 / -0.01em / 1.4
7. **日本語見出し letter-spacing 0.02em**、英字（Caddygate）-0.015em
8. **section 余白 96-120px**（モバイル 64-80px）

## 動作確認
http://localhost:8000/ で以下を見る:
- Hero: 写真とテキストの可読性（背景は写真 + 黒ベール、これは維持）
- C section "土曜の朝...": 白背景 + 黒テキスト + 緑チェック細枠 + 40万円 白背景大数字
- D section "予約が決まった時...": 白背景 + テーブル zebra なし + 行間広め
- D-2 / E-2: surface-alt が古紙ベージュ → ライトグレーに
- E section "キャディは大学生": 白背景 + 写真細枠
- G section "料金は、シンプルに": 中央カード（fee-badges + founders-card）
- J section "キャディが、開く": 全画面深緑廃止 → 白背景 + 深緑カードで controlled
- Footer: 全画面深緑だがここは識別性のため維持（contrast 強）

## 参考リンク（research articles）
- SaaSFrame: 10 SaaS LP trends for 2026
- Tentackles: 4 B2B SaaS color palettes 2026
- SaaS Hero: Top LP design trends B2B SaaS 2026
- Schweitzer Designs: 2026 color & typography trends
- Fontfabric: Top 10 design & typography trends 2026
