# Caddygate 営業資料 画像生成プロンプト集

作成: art-director
日付: 2026-06-04
用途: ChatGPT image (gpt-image-1) / DALL-E 3 / Midjourney へ投げる英語プロンプト集
方針: 「営業先＝50-70代ゴルフ場オーナー、保守的・信頼感重視」のため、AI 量産臭・派手なグラデ・抽象3D・パーティクル系を一切排除。**編集写真（editorial photography）**寄り、または **シンプルな抽象アクセント図形**に振る。
備考: 画像内に日本語テキストは含めない（後で SVG/CSS で乗せる）。

---

## 共通ルール（全プロンプト末尾に追加推奨）

```
no text overlay, no watermark, no logo, no captions,
no people facing camera (back view only if any human),
no neon, no glow particles, no purple haze, no AI-cliche gradients,
photorealistic editorial photography style,
natural lighting, subtle film grain, slight bokeh allowed,
muted earthy color palette, white-balanced for print,
shot on Sony A7 IV with 35mm prime, ISO 400, f/2.8.
```

ChatGPT image2 / DALL-E 3 では `--ar` は効かないので、**プロンプト末尾に「aspect ratio 16:9, 1920x1080」** を文章として入れる。Midjourney 利用時は `--ar 16:9` を末尾に。

---

## 01. カバースライド用 Hero ビジュアル（背景写真 透過 8% 用）

**用途**：カバースライド Type A の背景に淡く敷く写真。前景の大見出しを邪魔しない静かなトーン。
**サイズ**：1920×1080（16:9）
**出力先**：`~/caddytas/sales/assets/cover-hero.jpg`

### 推奨プロンプト

```
A wide-angle editorial photograph of an empty Japanese golf course fairway
at early morning, soft mist hovering low over the grass, the fairway
gently curving into the distance toward a line of pine trees. The light
is cool dawn light (5500K), slightly silvery, no direct sunbeams.
The grass shows a subtle dew sheen, with hints of moss green (#2C4A3B)
and warm beige (#F5F0E6) in the rough. No people, no flag, no golf cart.
The composition leaves the upper third of the frame as quiet sky for
text overlay. Subtle film grain, shot on Sony A7 IV with 35mm lens,
f/4, ISO 400. Editorial restraint, no commercial aerial drone look,
no saturated greens, no AI hyperreal sharpness.
Aspect ratio 16:9, 1920x1080. White-balanced for print.
```

### 代替案 A（クラブハウス系）

```
A quiet editorial photograph of a traditional Japanese golf club's stone
entrance path at dawn, low stone lantern visible at the edge, no people,
no signage. Soft overcast light, muted greens and warm grey tones,
slight morning mist. Composition centered low to leave the top half of
the frame quiet for text overlay. Shot on 50mm lens, f/2.8, subtle film
grain. No flashy color grading, no commercial brochure look.
Aspect ratio 16:9, 1920x1080.
```

### 代替案 B（抽象寄り・写真使わない場合のフォールバック）

```
A minimal abstract composition resembling the soft texture of a putting
green at the corner of a frame, with about 80% of the canvas left as
clean off-white (#F7F7F5) space. Only the bottom-left corner shows a
subtle close-up of moss-green grass blades, gradually fading to white.
Editorial still-life sensibility, soft natural light, no people, no logos.
Aspect ratio 16:9, 1920x1080. Photorealistic but understated.
```

### 利用ガイド
- 採用案：推奨プロンプト > 代替 A > 代替 B（保守度が低い順）。
- 採用後は PPTX 上で **opacity 8%** に落として上に Display テキストを重ねる。
- 上半分が空（テキスト用余白）になる構図を厳守。

---

## 02. 章扉用アクセント図形（任意・必要なら）

**用途**：章扉スライド Type B の右下に小さく置く抽象アクセント（任意）。なくても章扉は成立する。
**サイズ**：800×800（1:1、透過 PNG）
**出力先**：`~/caddytas/sales/assets/chapter-mark.png`

### 推奨プロンプト

```
A single minimal line drawing of an abstract topographic contour pattern,
3 to 5 concentric organic curves resembling golf course terrain elevation
lines. Lines are 1.5px solid #2C4A3B moss green on transparent background.
The composition occupies the center of a 800x800 square with generous
white space around. Editorial vector minimalism, no fill, no shadow,
no gradient. Reference: Swiss design typography meets Japanese
topographic survey maps.
Transparent PNG, 800x800, vector-like sharpness.
```

### 代替案（より具体）

```
A minimalist single-line illustration of a stylized golf flag silhouette
seen from a distance, drawn with one continuous 1.5px line in
#2C4A3B moss green on transparent background. Composition centered,
generous white space. No fill, no shadow, no embellishments.
Editorial vector style, like a small mark on a business document.
Transparent PNG, 800x800.
```

### 利用ガイド
- 章扉の右下、80px の余白を取って高さ 120-160px で配置。
- 透過 PNG。色は苔緑 #2C4A3B 一色のみ。
- 不要なら章扉は連番だけで十分。**置かなくて良い**と判断したらスキップ。

---

## 03. 本文スライド用：キャディ後ろ姿（顔判別不可）

**用途**：「現場で働く人がいる」を伝えるための写真。本文スライド Type C のサブビジュアル枠で使用。
**サイズ**：1160×870（4:3）
**出力先**：`~/caddytas/sales/assets/caddie-back.jpg`

### 推奨プロンプト

```
An editorial photograph of a single caddie walking down a Japanese golf
course fairway, viewed from behind at mid-distance (waist-up framing),
wearing a clean cream-colored uniform with a navy cap and pulling a
single-bag electric pull-cart with one golf bag. The caddie's face is
not visible. Soft late-afternoon side light (4800K), long shadows,
warm tones on the grass. Background is gently blurred fairway and
distant trees. No tournament branding, no other people in frame.
Documentary tone, shot on 85mm prime, f/2.8, ISO 200.
Subtle film grain. No commercial smile, no over-saturation.
Aspect ratio 4:3, 1160x870. Editorial restraint.
```

### 代替案 A（広角・現場感強め）

```
A wide editorial photograph of two caddies' silhouettes seen from behind,
walking together along a fairway in late afternoon. Their uniforms are
muted navy and cream, no visible logos. The composition shows the
caddies in the lower third, with golf course terrain and distant pines
in the upper two thirds. Warm low-angle sunlight, long shadows.
Documentary photojournalism style. No faces visible. No commercial polish.
Shot on 35mm prime, f/4, ISO 200. Aspect ratio 4:3, 1160x870.
```

### 代替案 B（道具クローズアップ・人物なし）

```
A still-life editorial photograph of a leather golf bag standing on
freshly mowed fairway grass at dawn, dew droplets visible on the
grass blades. Soft overcast light from the upper left. Muted earth
tones: tan leather, moss green grass (#2C4A3B), pale sky.
No branding visible on the bag. Composition: bag occupies right third,
grass and shallow depth-of-field background fills the rest.
Shot on 50mm macro, f/2.8. Subtle film grain.
Aspect ratio 4:3, 1160x870.
```

### 利用ガイド
- 採用：推奨 > A > B。営業先がカジュアル寄りなら推奨、フォーマル寄りなら B。
- 顔が映ったら採用しない。必ず後ろ姿または道具のみ。
- カバー写真と色温度を揃える（推奨カバー＝5500K dawn、推奨キャディ＝4800K dusk なので時間軸で対比あり）。

---

## 04. 本文スライド用：早朝のフェアウェイ（道具・地形のクローズアップ）

**用途**：「課題」「業界の現状」章の本文スライドで、テキスト横に置く重い静止写真。
**サイズ**：1160×870（4:3）
**出力先**：`~/caddytas/sales/assets/fairway-dawn.jpg`

### 推奨プロンプト

```
An editorial photograph of a fairway at dawn with subtle morning mist
hovering above the grass. The viewpoint is low, close to the ground,
showing the texture of mowed grass in sharp detail in the foreground,
softly transitioning to a blurred horizon line and pale silver sky.
A single golf flag is visible in the far background, soft and out of
focus. Cool dawn light (5000K), no direct sun. Color palette:
deep moss green (#2C4A3B), warm beige rough (#D6CFB8), pale silver sky.
Shot on 50mm macro, f/2.8, ISO 200. Slight film grain.
No people, no logos, no commercial polish.
Aspect ratio 4:3, 1160x870. Editorial restraint.
```

### 代替案

```
A close-up editorial photograph of dew on freshly mowed Japanese golf
course grass at first light, with shallow depth of field. The
background is a soft wash of pale morning sky and distant tree
silhouettes. No people. Muted earth-tone color palette: moss green,
pale gold, soft grey. Shot on 100mm macro, f/4, ISO 200. Documentary
restraint. Aspect ratio 4:3, 1160x870.
```

### 利用ガイド
- 「業界の現状」や「キャディ不足の構造的要因」の本文スライド向け。重さを保つ。
- 派手な俯瞰や golden hour の強い色は避ける。

---

## 05. Before / After 対比スライド用：従来の人材確保現場（任意）

**用途**：Type E 対比スライドで使う場合のサブビジュアル。**ただし、対比スライドは数字とテキストだけで成立するので、画像は必須ではない**。
**サイズ**：560×420（4:3 小、左右に並ぶ）
**出力先**：`~/caddytas/sales/assets/before.jpg`, `~/caddytas/sales/assets/after.jpg`

### Before プロンプト

```
An editorial photograph of an empty Japanese golf course clubhouse
back-office staff room with a single landline phone on a wooden desk,
a printed paper roster pinned to a corkboard, and a clipboard.
No people. Dim warm tungsten lighting (3000K), slight haze.
Muted brown and beige tones. Documentary stillness. Shot on 35mm
prime, f/2.8, ISO 800. Aspect ratio 4:3, 560x420.
```

### After プロンプト

```
An editorial photograph of a clean wooden desk in a sunlit golf club
office, with a single tablet device showing a generic dashboard
interface (UI not specified, just shapes of cards visible), positioned
beside a small ceramic coffee cup. Bright natural light from the left.
Muted earth-tone palette: light wood, white tablet bezel, off-white
walls. No people, no readable text on screen.
Shot on 50mm prime, f/2.8, ISO 400. Subtle film grain.
Aspect ratio 4:3, 560x420.
```

### 利用ガイド
- これは**省略可**。Type E は数字とテキストで Before/After が十分伝わるので、画像追加は装飾過剰になりやすい。
- 採用するなら Before は暗く・古く、After は明るく・新しく、で色温度コントラスト。

---

## 06. CTA スライド用：QR コード背景パターン（任意）

**用途**：Type H CTA スライドの全体をやや締めるための背景テクスチャ。**置かなくても CTA は成立する**。
**サイズ**：1920×1080（16:9）
**出力先**：`~/caddytas/sales/assets/cta-bg.jpg`

### 推奨プロンプト

```
A minimal abstract editorial photograph of a faintly textured paper
surface, off-white #FAFAFA, with subtle warm undertones, very slight
imperfections like fiber texture or laid-paper grain. Even lighting
from above, no shadows, no logos, no marks. Photographed for use as
a calm background behind text and a QR code. Editorial restraint.
Aspect ratio 16:9, 1920x1080. Subtle film grain acceptable.
```

### 利用ガイド
- 配置するなら opacity 30-50% で薄く。テキストの可読性を最優先。
- これも省略してよい。

---

## 07. 章扉「導入効果」用：ゴルフ場・キャディ全体写真（任意）

**用途**：「Caddygate がもたらす効果」章の章扉に、控えめに配置する大判ビジュアル。
**サイズ**：1920×1080（16:9）
**出力先**：`~/caddytas/sales/assets/chapter-effect.jpg`

### 推奨プロンプト

```
An editorial photograph of a Japanese golf course fairway viewed from
a slightly elevated tee box at golden hour (5800K), with long shadows
cast by isolated pine trees. The fairway recedes into the distance,
showing the gentle topography of a traditional course. No people, no
flag, no golf cart. Color palette: warm green (#3C5A48), soft amber
(#D9B889), pale gold sky. Composition: fairway occupies the lower
two-thirds, sky and trees in the upper third. Shot on 35mm prime,
f/5.6, ISO 200. Subtle film grain. No drone aerial perspective, no
saturated colors, no commercial brochure look.
Aspect ratio 16:9, 1920x1080.
```

### 利用ガイド
- 章扉に背景写真を入れる場合は opacity 20-30% に落とし、テキストとの干渉を防ぐ。
- 全章扉に入れる必要はない（むしろ 1 章だけに入れて緩急をつけると効果的）。

---

## 08. 共通：プロダクト UI スクリーンショット（生成しない、撮影する）

**用途**：Type F スクショスライド。
**出力先**：`~/caddytas/sales/assets/screens/dashboard-pc.png`, `screens/dashboard-mobile.png`

### 取得方法（生成プロンプトではない）

実プロダクトのスクショは AI 生成せず、**実 HTML を撮影する**：

1. `~/caddytas/golf_dashboard.html` を Chrome で開く（1440×900 にリサイズ）
2. ダミーデータを「リアルなゴルフ場名・キャディ名（仮名）・現実的な日付」に差し替える
3. Cmd+Shift+4 でフルスクショ
4. Vercel Geist Browser コンポーネント or browserframe.com で薄chrome を被せる
   - URL bar: `caddygate.app/dashboard`
   - chrome 色: `#FAFAFA`
   - radius 12px、shadow 弱め

モバイルは `caddy_dashboard.html` を 375×812 で同様に撮影。

### 何を AI 生成しないか
- ダッシュボードのモックを Midjourney/DALL-E で生成しない。**保守的なオーナー層は「実在しない UI」を即見抜く**。実プロダクト撮影が信頼の最短経路。

---

## 採用優先順（user が ChatGPT image2 に投げる順番）

| # | 必要度 | プロンプト | 期待値 |
|---|---|---|---|
| 1 | 必須 | 01. カバー Hero | カバーの背景として opacity 8% で敷く |
| 2 | 必須 | 03. キャディ後ろ姿 | 本文の現場感担保 |
| 3 | 推奨 | 04. 早朝フェアウェイ | 課題章の重みづけ |
| 4 | 推奨 | 07. 章扉用ゴルフ場全景 | 章扉の緩急 |
| 5 | 任意 | 02. 章扉アクセント | あれば良い、なくて良い |
| 6 | 任意 | 05. Before/After | 数字で十分なので省略可 |
| 7 | 任意 | 06. CTA 背景パターン | 省略可 |

**必須 2 件 + 推奨 2 件 = 4 件を生成すれば 12-15 スライド資料は完成する。** その他は後追いで足す。

---

## 生成後の処理

1. **リサイズ**：ChatGPT image2 は 1024×1024 出力が多いため、必要に応じて 1920×1080 や 1160×870 にトリミング（Preview / sips コマンド可）。
2. **色補正**：もし暖かすぎる・派手すぎる場合は Preview で彩度 -10〜-20% / 露光 -0.3 程度の落ち着いた補正を行う。
3. **配置**：すべて `~/caddytas/sales/assets/` 配下に保存。PPTX マスターに参照を貼る。
4. **JPEG 化**：写真は JPEG 品質 85 で 1MB 以下を目標。透過必要分のみ PNG。

---

## ChatGPT image2 / DALL-E 3 の癖（実用ノウハウ）

- 「no people」だけだとモデルがしばしば人物を入れてしまう。**`no humans in frame, fully unoccupied scene`** とダメ押し。
- 「no text」と書いても看板/文字を入れることがある。**`no signage, no readable text, no characters`** で重ねがけ。
- 「photorealistic」と「editorial restraint」を併記すると AI 過剰彩度を抑えやすい。
- 「Sony A7 IV with 35mm prime」など具体的機材名は色味とボケ感に効く。
- 「subtle film grain」は粒状感を程よく入れる魔法ワード。AI フラットを和らげる。
- 1 発で良いものが出ないので、**同じプロンプトで 3-4 枚生成**して選ぶ運用が前提。

---

## 参考リンク

- [Vercel Geist Browser component](https://vercel.com/geist/browser) — スクショ chrome 設計の参考
- [BrandBird browser mockup](https://www.brandbird.app/tools/browser-mockup-generator) — chrome 生成ツール
- [BrowserFrame](https://browserframe.com/) — もう一つの chrome 生成ツール
- [Screenhance mockup generator](https://screenhance.com/mockup-generator) — モバイル枠用
