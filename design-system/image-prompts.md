# Caddygate Dashboard — Image Generation Prompts (DALL-E 3 / ChatGPT image2 用)

作成: art-director
作成日: 2026-06-01
用途: visual-implementer が実装の参照として「理想形のスクリーンショット」を ChatGPT で生成し、実 HTML/CSS の見え方目標として手元に置く。**実装に貼るアセットではなく、ビジュアル目標の mockup**。日本語テキストは生成画像内で再現しない（DALL-E は日本語が苦手なので英語ラベルで近似し、実装では日本語に置き換える）。

---

## 共通ルール（3 案すべてに適用）

- **解像度**: 16:9（1792 × 1024 推奨、ChatGPT で「wide」指定）
- **スタイル統一文言** (必ず含める):
  - `clean modern B2B SaaS dashboard UI screenshot, flat illustration style with vector precision, no photo realism`
  - `pure white background #FFFFFF, warm-tinted light gray sidebar #F7F7F5, 1px borders #E5E7EB, no drop shadows on cards`
  - `near-black primary CTA button #18181B, deep moss green accent #2C4A3B used sparingly for active sidebar item and one KPI value`
  - `Inter font, tabular numerals, generous tracking on uppercase labels`
  - `8px grid system, 6-8px rounded corners, no neon, no gradient, no glow, no purple, no decorative illustration`
- **禁止要素**:
  - `no photo backgrounds, no people, no golf course photography, no Japanese text, no glow effects, no neon accents, no glassmorphism, no 3D, no isometric, no purple, no red, no orange, no beige background`
  - `no excessive shadows, no rainbow charts, no marketing-style hero illustrations`
- **テキスト処理**: 画面内テキストは英語で近似（実装時に日本語に置換）。ラベルは "This Week", "Next Week", "Active Caddies" などシンプルに。

---

## Prompt 1: golf_dashboard.html（ゴルフ場側 予約管理画面）

### 用途
ゴルフ場支配人が日常的に見る予約管理画面。KPI ストリップ 4 個 + 「今週の予約」データテーブルが主役。

### Master Prompt（コピペ用）

```
A pristine, ultra-clean B2B SaaS dashboard screenshot for a golf course booking management system, viewed on a desktop browser at 1440px width. 16:9 aspect ratio.

LAYOUT:
- Left sidebar 240px wide, background #F7F7F5 (warm-tinted light gray), separated from main canvas by a single 1px border #E5E7EB
- Top header bar 56px tall, pure white #FFFFFF, with bottom border #E5E7EB only, NO shadow
- Main canvas pure white #FFFFFF with generous 24px padding

SIDEBAR CONTENT:
- Small logo mark at top left (a tiny geometric shape, no text logo)
- Three navigation groups with quiet uppercase 11px labels in #9CA3AF: "Bookings", "Training", "Settings"
- Each nav item is 36px tall with a 16px line icon (Lucide style) on the left
- ONE active item highlighted: background #ECF3EE (soft moss green tint), text #1F3A2D (deep moss green), font weight 600, with a thin 2px vertical bar #2C4A3B on its left edge
- Other items show in #5C5C5C text, weight 500, icons in #9CA3AF
- At the bottom of sidebar: a tiny user identifier and a ghost-style "Logout" button (transparent background, 1px border #E5E7EB)

MAIN CANVAS CONTENT (top to bottom):
1. Header row: page title "Bookings" in 20px semibold #1A1A1A on the left, two small icon buttons (bell, settings) on the right
2. KPI strip with FOUR cards in a single row, gap 12px between them, each card 6px rounded corners with 1px #E5E7EB border, NO shadow, padding 20px
   - Card 1 (most prominent): label "This Week" in 13px #5C5C5C, value "12" in 32px bold #1F3A2D (deep moss green) with tiny "bookings" unit, delta "+2 vs last week" in 12px #2C4A3B
   - Card 2: label "Next Week", value "8" in 32px bold #1A1A1A (near black), delta "±0" in 12px #9CA3AF
   - Card 3: label "Active Caddies", value "5" in 32px bold #1A1A1A, delta in #9CA3AF
   - Card 4: label "Training Requests", value "3" in 32px bold #1A1A1A, delta in #9CA3AF
3. Section title "This Week's Bookings" in 16px semibold #1A1A1A with a secondary "Export CSV" outline button on the right
4. A data table with 8px rounded outer corners, 1px #E5E7EB border, NO shadow
   - Table header row: background #F7F7F5, height 40px, column labels in uppercase 12px #5C5C5C with 0.04em letter-spacing: "DATE", "TIME", "CADDY", "PARTY", "SIZE", "STATUS", " "
   - Six data rows, each 48px tall, 14px #1A1A1A text, 1px #E5E7EB border-bottom between rows, NO zebra striping
   - Status column shows small pill badges 22px tall with a 6px dot on the left:
     - "Confirmed" badge: background #ECF3EE, text #1F3A2D
     - "Pending" badge: background #FEF3C7, text #92400E
     - "Completed" badge: background #DBEAFE, text #1E40AF
     - "Cancelled" badge: background #F3F4F6, text #6B7280
   - Last column has a chevron-right icon button per row
   - Numeric "SIZE" column right-aligned with tabular numerals

TYPOGRAPHY: Inter or similar geometric sans, with tabular numerals for all numbers. Use -0.02em letter-spacing for KPI values, +0.04em uppercase tracking for table headers.

OVERALL FEEL: Linear-meets-Stripe-meets-Cal.com 2026, calm, professional, dense but readable, almost no color, lots of white space, single 1px borders everywhere. NO drop shadows except a very faint one only on the entire browser window frame. NO glow, NO gradients, NO illustrations.

Render as a high-fidelity UI mockup, vector-precise, as if exported from Figma at 2x.
```

### 代替案 1: もっとミニマル（Linear 寄り）
上記の Master Prompt に追記:
```
Style reference: Linear app dashboard 2026 UI refresh. Sidebar items have no icons until hovered/active. Information density slightly increased. Page title in 18px instead of 20px.
```

### 代替案 2: もっと業務的（Stripe 寄り）
上記の Master Prompt に追記:
```
Style reference: Stripe Dashboard 2026. Add a very subtle inset card shadow only on the KPI cards (max 1px 2px rgba(0,0,0,0.04)). Table thead has a slightly stronger separator (#D1D5DB instead of #E5E7EB). Slightly tighter row height of 44px.
```

### 生成後の使い方
- 実装の見え方のゴールとして手元に置く
- visual-implementer が KPI strip / table の余白・色の見え方判定に使う
- アセットとしてアプリに貼らない（あくまで mockup）

---

## Prompt 2: caddy_dashboard.html（キャディ側 予約一覧画面）

### 用途
学生〜中年キャディがスマホ/PC 両方で見る画面。KPI + 次回予約の booking-card + 指名ゴルフ場の person-card grid。

### Master Prompt（コピペ用）

```
A clean, calm B2B SaaS dashboard screenshot for a freelance caddy showing personal bookings and earnings, viewed on a desktop browser at 1440px. 16:9 aspect ratio.

LAYOUT:
- Same shell as golf course dashboard: 240px sidebar #F7F7F5, 56px header, pure white #FFFFFF main canvas
- Sidebar nav groups: "Schedule", "Training", "Settings"
- Active item highlighted on "Schedule" with #ECF3EE background, #1F3A2D text, weight 600, left 2px #2C4A3B vertical bar

MAIN CANVAS (top to bottom):
1. Header: title "My Schedule" 20px semibold #1A1A1A
2. KPI strip, 4 cards in a row, gap 12px, 6px rounded, 1px #E5E7EB borders, NO shadow
   - Card 1 (main): "This Week" / value "4" in 32px bold #1F3A2D / "shifts" unit
   - Card 2: "Projected Earnings" / "¥48,000" in 32px bold #1A1A1A / "this month" delta in #9CA3AF
   - Card 3: "Training Pending" / "2" in 32px bold #1A1A1A
   - Card 4: "Unread Messages" / "1" in 32px bold #1A1A1A
3. Section "Next Booking" — a single wide booking card 6px rounded, 1px border, padding 20px:
   - Left: a large date block — day number "15" in 32px bold #2C4A3B (moss green), with "September" 13px and "Sunday" 13px below in #5C5C5C
   - Middle: title "7:30 — Yamada Group (4 players)" in 16px semibold #1A1A1A, two meta rows below in 13px #5C5C5C with tiny icons: "Hole: Out 1", "Course: Aso Hills"
   - Right: a "Confirmed" badge (#ECF3EE / #1F3A2D) and a chevron-right icon button
4. Section "Courses That Booked You Recently" — a grid of 4 person-cards (2 columns), each card 16px padding, 6px rounded, 1px border
   - Each card: left avatar circle 48px diameter, soft #ECF3EE background with deep green #1F3A2D initial letter inside
   - Right: golf course name in 14px semibold #1A1A1A, meta in 13px #5C5C5C ("Fukuoka / 12 bookings / ★ 4.8")
   - Far right: ghost "View" button (transparent, 1px border #E5E7EB)

DETAILS:
- Generous padding, calm spacing
- Numbers use tabular numerals throughout
- The ONLY pop of green color: the active sidebar item, the main KPI value, the date block "15", and the avatar circles
- Everything else is in grayscale: #1A1A1A, #5C5C5C, #9CA3AF
- No glow, no shadows on cards, no gradients

STYLE: Linear / Cal.com 2026 dashboard aesthetic. Information-dense but spacious, vector-precise rendering, as if exported from Figma at 2x. No photo realism.
```

### 代替案 1: モバイル想定（縦長）
上記を 9:16 アスペクト比に変更し、追記:
```
Mobile portrait view 390px wide. Sidebar collapsed into a bottom tab bar with 4 items (Schedule, Caddies, Training, Settings), 64px tall, white background, 1px top border #E5E7EB. KPI strip becomes 2x2 grid instead of 4x1. Booking card takes full width.
```

### 代替案 2: 空状態（empty state 入り）
上記の "Next Booking" セクションを以下に置換:
```
3. Section "Next Booking" — an empty state instead of a card:
   - 1px DASHED #E5E7EB border, 8px rounded, padding 56px, centered text
   - Top: a 56px circle with soft #F7F7F5 background, containing a 24px calendar line icon in #9CA3AF
   - Title 16px semibold #1A1A1A: "No bookings yet this week"
   - Description 13px #5C5C5C: "When a golf course books you, it'll show here."
   - One outline button "View available courses" (1px border #E5E7EB, transparent, #1A1A1A text)
```

### 生成後の使い方
- キャディ画面の温度感（やや暖かい、人間的）の判定材料
- person-card grid の余白・avatar 色の見え方確認

---

## Prompt 3: profile.html（プロフィール編集画面）

### 用途
ゴルフ場 or キャディ どちらも使う設定画面。フォーム入力の見え方が主役。

### Master Prompt（コピペ用）

```
A focused, single-column profile settings page in a B2B SaaS dashboard. Desktop browser at 1440px width, 16:9 aspect ratio.

LAYOUT:
- Same dashboard shell: 240px sidebar #F7F7F5, 56px header pure white, main canvas pure white
- In sidebar, "Profile" item under "Settings" group is active (#ECF3EE bg, #1F3A2D text, left 2px #2C4A3B bar)
- Main canvas: max-width 720px content area, centered horizontally with generous left/right space

MAIN CANVAS:
1. Page header: title "Profile" 20px semibold #1A1A1A, subtitle below 13px #5C5C5C "Update your golf course information"
2. ONE primary card containing the form:
   - Card: 8px rounded, 1px #E5E7EB border, 32px padding, pure white background, NO shadow
   - Card title "Basic Information" 16px semibold #1A1A1A with bottom 1px #E5E7EB divider
   - Form fields stacked vertically with 20px spacing between fields:
     - "Golf Course Name" label 13px semibold #1A1A1A, input field 36px tall, 6px rounded, 1px #E5E7EB border, white bg, 14px text inside, 12px horizontal padding, with placeholder in #9CA3AF
     - "Contact Person" same style
     - "Phone Number" same style with a small hint "No dashes" below in 12px #9CA3AF
     - Two side-by-side fields in a row: "Prefecture" (select dropdown with chevron-down icon) and "City" (input)
     - "Perks for Caddies" input with hint text below
   - One field is FOCUSED (currently being edited): its border is 2px #2C4A3B with a 2px outset rgba(44,74,59,0.18) ring offset
3. Card footer: 1px #E5E7EB top divider, padding 16px, with two buttons aligned right
   - "Cancel" ghost button (transparent, 13px #5C5C5C text)
   - "Save changes" primary button (#18181B background, white text, 6px rounded, 36px tall, 14px medium weight)

DETAILS:
- Form inputs have a calm rhythm, all aligned to a clear grid
- Generous 32px padding inside the card
- The ONLY green pop: the active sidebar item AND the focused input's border ring
- Primary CTA is near-black, never green
- No icons inside inputs except chevron-down on select
- No floating labels, no fancy animations, just clear flat labels above inputs

STYLE: Stripe / Vercel 2026 settings pages aesthetic. Calm, focused, almost forensic in clarity. Vector-precise Figma export look. No shadows except a barely-there focus ring on the active input.
```

### 代替案 1: 入力エラー状態
上記に追記:
```
One field shows an error state: "Phone Number" input border is #FECACA, with an error message below in 12px #991B1B "Please enter at least 10 digits", and a tiny error icon at the right end of the input.
```

### 代替案 2: 保存成功 toast 付き
上記に追記:
```
Add a small toast notification at the bottom right corner: 280px wide, white background, 1px #E5E7EB border, 8px rounded, 12px padding, with a small green check icon (#2C4A3B), text "Profile saved" in 14px #1A1A1A, and a faint shadow (0 8px 20px rgba(17,24,39,0.10)).
```

### 生成後の使い方
- フォーム入力の見え方、focus ring の柔らかさの判定
- card 内部の情報密度感

---

## 4. 生成後の取り扱い（共通）

1. ChatGPT image2 / DALL-E 3 で生成 (Wide / 16:9 を選択)
2. 生成画像を `/Users/takumi/caddytas/design-system/mockups/` 配下に保存（フォルダ未作成なら作る）
   - `mockups/golf_dashboard.png`
   - `mockups/caddy_dashboard.png`
   - `mockups/profile.png`
3. visual-implementer が実装の見え方判定に使う（pixel-perfect 模倣ではなく、トーンの参照）
4. **本番アプリにこれらの画像を直接貼らない**。あくまで mockup

---

## 5. 観察すべき視覚要素チェックリスト（生成後）

生成画像が以下を満たしているか確認:

- [ ] 背景が純白 #FFFFFF（クリーム色やベージュではない）
- [ ] sidebar 背景がわずかに warm な薄グレー #F7F7F5（青みのある #F9FAFB ではない）
- [ ] card に drop shadow が付いていない（border 1px のみ）
- [ ] CTA ボタンが near-black（緑塗りではない）
- [ ] 苔緑が「active sidebar item + KPI 主役の数字 1 個 + 確定 badge」の 3-4 ヶ所のみに限定
- [ ] 角丸が 6-8px の一貫した範囲（極端な 12px+ や 0px ではない）
- [ ] テーブルに zebra stripe がない
- [ ] 赤 / 紫 / 青 / オレンジが画面全体で 1% 未満
- [ ] グラデーション・glow・neon・3D が一切ない
- [ ] 日本語テキストが画像内で破綻していない（英語で生成しているので問題ないはず）

満たさない要素があれば、その要素を **NEGATIVE PROMPT** として追記して再生成。

---

## 6. ChatGPT へのプロンプト投入の作法

ChatGPT image2 (GPT-4o image) は long prompt をそのまま受け付けるが、生成精度を上げるため:

1. Master Prompt をそのままコピペで投入
2. 1 回目で得た画像に対して「too much shadow」「the green is too saturated」など 1-2 個の具体的修正点を日本語/英語どちらでも追加 prompt で投げる
3. 3-4 回のラリーで目標に近づける
4. 良い 1 枚が出たら保存し、次の画面プロンプトに移る

各画面 30 分程度の作業を想定。
