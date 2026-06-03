# Caddygate Components

作成: design-strategist
作成日: 2026-05-31
目的: framework.css のクラスを使った HTML 構造を、visual-implementer がコピペで動かせる粒度で定義する。

## 0. 共通ルール

- HTML はセマンティックに（`<section>` / `<article>` / `<details>` 等）
- アイコンは Lucide CDN を 1 回読み込み、`<i data-lucide="...">` で配置
- 画像参照パス: `/assets/hero-main.png` 等（既存 `~/caddytas/assets/` 配下）
- すべて framework.css 必須

---

## 1. Page Skeleton（HTML <head> + 全体構造）

```html
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5">
  <title>キャディゲート | 九州のゴルフ場と、大学生キャディを結ぶ予約プラットフォーム</title>
  <meta name="description" content="九州（福岡・長崎）のゴルフ場の支配人さまへ。キャディ不足で組数を絞らずに済む経営を、予約手数料だけで。先着100社・基本料／掲載料 永久無料。">

  <!-- OG -->
  <meta property="og:title" content="キャディが、開く。— 九州のゴルフ場の朝を、断らない経営へ。">
  <meta property="og:description" content="九州のゴルフ場 × 大学生キャディの予約プラットフォーム。先着100社・永久無料。予約が決まった時だけ ¥2,500。">
  <meta property="og:image" content="/assets/og-image.png">
  <meta property="og:type" content="website">

  <!-- Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="/assets/logo-symbol.png">

  <!-- Design Framework -->
  <link rel="stylesheet" href="/design-system/framework.css">
</head>
<body>
  <!-- Sticky Header -->
  <header class="header">...</header>

  <!-- Hero Section A -->
  <section class="hero">...</section>

  <!-- Alert Bar B（先着100社）-->
  <div class="alert-bar">...</div>

  <!-- C. 課題提起 -->
  <section class="section">...</section>

  <!-- D. 解決 Before/After -->
  <section class="section section--surface">...</section>

  <!-- ... E〜J 続く ... -->

  <!-- Footer -->
  <footer class="footer">...</footer>

  <!-- Lucide -->
  <script src="https://unpkg.com/lucide@latest"></script>
  <script>lucide.createIcons();</script>
</body>
</html>
```

---

## 2. Header（Sticky Navigation）

```html
<header class="header">
  <div class="container header__inner">
    <a href="/" class="header__logo">
      <img src="/assets/logo-wordmark.png" alt="Caddygate（キャディゲート）">
    </a>
    <nav class="header__nav" aria-label="メインナビ">
      <a href="#problem">課題</a>
      <a href="#solution">解決</a>
      <a href="#flow">仕組み</a>
      <a href="#pricing">料金</a>
      <a href="#faq">よくあるご質問</a>
      <a href="#contact" class="btn btn--primary btn--sm">無料で始める</a>
    </nav>
  </div>
</header>
```

モバイルでは `.header__nav` を hamburger に切り替える（実装は visual-implementer 判断、ミニマル運用で十分）。

---

## 3. Button バリエーション

```html
<!-- Primary（朱・最重要 CTA） -->
<a href="#contact" class="btn btn--primary">無料で始める</a>

<!-- Secondary（苔緑アウトライン） -->
<a href="#about" class="btn btn--secondary">事業内容を見る</a>

<!-- Solid（苔緑塗りつぶし・代替 CTA） -->
<a href="#download" class="btn btn--solid">資料をダウンロード</a>

<!-- Ghost（テキストリンク的） -->
<a href="tel:09012345678" class="btn btn--ghost">お電話でのご相談</a>

<!-- Size -->
<a class="btn btn--primary btn--lg">大きめ CTA</a>
<a class="btn btn--secondary btn--sm">小さめ CTA</a>

<!-- アイコン付き -->
<a class="btn btn--primary">
  無料で始める <i data-lucide="arrow-right" style="width:18px;height:18px"></i>
</a>
```

状態：
- hover: 背景色が deep に
- :active: `translateY(1px)` で押し込み感
- :focus-visible: 2px の苔緑アウトライン
- :disabled: opacity 0.45

---

## 4. Card（汎用・3カラム特徴用）

```html
<div class="container">
  <div class="grid grid--3">
    <article class="card">
      <span class="card__number">1</span>
      <h3 class="card__title">単発ではなく、続く関係を。</h3>
      <p class="card__body">
        登録キャディは、ゴルフ場ごとに継続して入る前提で動きます。
        一度のラウンドで終わらず、貴クラブの常連にも顔を覚えてもらえます。
      </p>
    </article>
    <article class="card">
      <span class="card__number">2</span>
      <h3 class="card__title">育てる前提の、研修付き。</h3>
      <p class="card__body">
        オンライン教材 → 半日の現地研修 → 先輩キャディとの同行ラウンドを経て、
        独り立ちまで2〜4週間。「未経験から始めて、続けて伸びる」設計です。
      </p>
    </article>
    <article class="card">
      <span class="card__number">3</span>
      <h3 class="card__title">九州の門は、九州で開く。</h3>
      <p class="card__body">
        福岡大学のゴルフ部、長崎国際大学の強化指定部から始め、
        順次、九州の体育会・サークルへと広げていきます。
      </p>
    </article>
  </div>
</div>
```

---

## 5. Alert Bar（B. 枠の残り）

ヒーロー直下 or hero 内最下部。スティッキーにせず、フローに置く。

```html
<div class="alert-bar">
  <div class="container alert-bar__inner">
    <span class="alert-bar__item">
      <i data-lucide="award" style="width:16px;height:16px"></i>
      ファウンダーズプラン｜先着 100 社限定／永久無料
    </span>
    <span class="alert-bar__divider">|</span>
    <span class="alert-bar__item">
      現在 <strong>11</strong> 社が利用開始済み — 残り <strong>89</strong> 枠
    </span>
    <span class="alert-bar__divider">|</span>
    <span class="alert-bar__item">2026 年ローンチ記念 ／ 九州 2 県から</span>
  </div>
</div>
```

---

## 6. Checklist（C. 課題提起）

```html
<section class="section" id="problem">
  <div class="container container--narrow">
    <h2 class="h1 mb-5">土曜の朝、断った予約は、ありませんでしたか。</h2>
    <p class="lead mb-7">
      全国のゴルフ場の9割がセルフプレーに進む中で、<br>
      「キャディ付き堅持」を選ぶコースほど、ひとつの欠員が経営に響いています。
    </p>

    <ul class="checklist mb-7">
      <li class="checklist__item">
        <span class="checklist__box"></span>
        ハイシーズンの土日、キャディが足りずに組数を絞ったことがある
      </li>
      <li class="checklist__item">
        <span class="checklist__box"></span>
        急な欠員の連絡があると、支配人の朝が予約電話の対応で終わる
      </li>
      <li class="checklist__item">
        <span class="checklist__box"></span>
        派遣会社に頼んでも、コースを知らないキャディが来ることがある
      </li>
      <li class="checklist__item">
        <span class="checklist__box"></span>
        ベテランキャディの引退が近く、後継の見通しが立っていない
      </li>
      <li class="checklist__item">
        <span class="checklist__box"></span>
        採用広告を出しても、若い世代からの応募が来ない
      </li>
      <li class="checklist__item">
        <span class="checklist__box"></span>
        「キャディ付き堅持」を続けたいが、人手の理由で迷い始めている
      </li>
    </ul>

    <!-- 機会損失の強調枠 -->
    <div class="card" style="background:var(--color-primary); border-color:var(--color-primary); color:var(--color-bg); text-align:center;">
      <p class="body-text" style="color:var(--color-bg); opacity:0.85;">
        1組4人 × ラウンドフィー 15,000 円 = 6 万円／組。<br>
        1日に5組を断れば 30 万円、月20営業日で
      </p>
      <p class="stat-lg" style="color:var(--color-bg);">600 万円</p>
      <p class="small" style="color:var(--color-bg); opacity:0.7;">失った1日は、戻ってきません。</p>
    </div>

    <p class="micro mt-4">
      ※ 全国セルフプレー比率 約9割（dstar101 / 2024年）／キャディ不足率 正社員84.4%・パート90.5%（NGK 雇用状況実態調査）
    </p>
  </div>
</section>
```

---

## 7. Compare Table（D. Before/After 対比）

```html
<section class="section section--surface" id="solution">
  <div class="container">
    <h2 class="h1 mb-5">予約が決まった時だけ、<span style="color:var(--color-accent)">¥2,500</span>。<br>それ以外の固定費は、いただきません。</h2>
    <p class="lead mb-7">
      キャディゲートは、貴クラブの求人を九州の登録キャディに届け、<br>
      応募が来た時だけ、予約システム手数料 ¥2,500 を月末にまとめて精算します。
    </p>

    <table class="compare-table">
      <thead>
        <tr><th>これまで</th><th>キャディゲートで</th></tr>
      </thead>
      <tbody>
        <tr><td>派遣単価が高く、人件費を圧迫していた</td><td>予約 1 件 ¥2,500 だけ。固定費はゼロ</td></tr>
        <tr><td>急な欠員で、組数を絞っていた</td><td>求人を出せば、登録キャディから応募が届きます</td></tr>
        <tr><td>派遣会社ごとに別々の請求書が届いていた</td><td>月末に1通の請求書で精算</td></tr>
        <tr><td>単発のバイトで、客との関係が続かなかった</td><td>同じキャディが、貴クラブの常連と顔見知りに</td></tr>
        <tr><td>採用広告に出しても、若手が応募してこなかった</td><td>福岡・長崎の大学生キャディが応募</td></tr>
        <tr><td>「キャディ付き堅持」を諦めかけていた</td><td>断らない朝のために、もうひとつの門を開けます</td></tr>
      </tbody>
    </table>
  </div>
</section>
```

---

## 8. Steps（F. 4ステップ）

```html
<section class="section" id="flow">
  <div class="container">
    <h2 class="h1 mb-7 text-center">4 ステップで、始められます。</h2>
    <div class="steps">
      <div class="step">
        <span class="step__num">1</span>
        <h3 class="step__title">求人を掲載する</h3>
        <p class="step__body">日付・コース・必要人数を入力。最短5分で公開できます。</p>
      </div>
      <div class="step">
        <span class="step__num">2</span>
        <h3 class="step__title">応募が届く</h3>
        <p class="step__body">九州の登録キャディから応募。貴クラブはプロフィールを見て選びます。</p>
      </div>
      <div class="step">
        <span class="step__num">3</span>
        <h3 class="step__title">予約が確定する</h3>
        <p class="step__body">両方が承諾した時点で予約成立。当日のラウンドへ進みます。</p>
      </div>
      <div class="step">
        <span class="step__num">4</span>
        <h3 class="step__title">月末にまとめて精算</h3>
        <p class="step__body">先月の予約件数 × ¥2,500 を月末締めで請求します。</p>
      </div>
    </div>
    <p class="small mt-7" style="max-width:720px;">
      キャディゲートは、貴クラブとキャディの間に立つ「予約システム」です。<br>
      キャディの選別・推薦・代理応答は行いません。（特定募集情報等提供事業 届出予定／株式会社KAIROS）
    </p>
  </div>
</section>
```

---

## 9. Pricing Cards（G. 料金・P-12 変則型）

左列（ファウンダーズ）に朱の枠線 + バッジを当てて強調。

```html
<section class="section section--surface" id="pricing">
  <div class="container">
    <h2 class="h1 text-center mb-7">料金は、シンプルに。</h2>

    <div class="pricing-grid">

      <!-- Featured: ファウンダーズプラン -->
      <article class="pricing-card pricing-card--featured">
        <span class="pricing-card__badge">先着 100 社・永久無料</span>
        <h3 class="pricing-card__title">ファウンダーズプラン</h3>
        <ul class="pricing-card__list">
          <li><strong>基本料金</strong>　¥0／月</li>
          <li><strong>求人掲載料</strong>　¥0／月</li>
          <li><strong>予約手数料</strong>　¥2,500／件</li>
          <li><strong>最低契約期間</strong>　なし</li>
        </ul>
        <a href="#contact" class="btn btn--primary">無料で始める</a>
      </article>

      <!-- Normal: 通常プラン -->
      <article class="pricing-card">
        <h3 class="pricing-card__title">通常プラン</h3>
        <p class="small muted">101 社目以降</p>
        <ul class="pricing-card__list">
          <li><strong>基本料金</strong>　¥3,000／月</li>
          <li><strong>求人掲載料</strong>　¥1,000／月</li>
          <li><strong>予約手数料</strong>　¥2,500／件</li>
          <li><strong>最低契約期間</strong>　なし</li>
        </ul>
        <a href="#contact" class="btn btn--secondary">ご相談する</a>
      </article>

      <!-- Reference: 参考（他社派遣） -->
      <article class="pricing-card pricing-card--reference">
        <h3 class="pricing-card__title">参考：他社の派遣単価</h3>
        <p class="small">業界相場 ／ キャディ取り分含む</p>
        <ul class="pricing-card__list">
          <li><strong>一般的なキャディ派遣</strong></li>
          <li class="stat-md" style="color:var(--color-ink-sub);">¥16,000〜32,000 ／組</li>
        </ul>
      </article>

    </div>

    <p class="small mt-6" style="max-width:720px;">
      キャディゲートは、貴クラブからキャディへのギャラには関与しません。<br>
      ギャラは業界慣習どおり、貴クラブからキャディへ直接お支払いください。
    </p>
  </div>
</section>
```

---

## 10. FAQ Accordion（I）

```html
<section class="section" id="faq">
  <div class="container">
    <h2 class="h1 text-center mb-7">よくあるご質問</h2>
    <div class="faq-list">

      <details class="faq-item">
        <summary class="faq-q">ゴルフ経験のない学生で、本当に大丈夫ですか。</summary>
        <div class="faq-a">
          全員に研修制度をご用意しています。オンライン教材で基礎を学んだあと、
          半日の現地研修と、先輩キャディとの同行ラウンドを2〜4週間。
          独り立ち後も、貴クラブのハウスキャディと一緒に組むペアリングから始められます。
        </div>
      </details>

      <details class="faq-item">
        <summary class="faq-q">キャディの質に、ばらつきはありませんか。</summary>
        <div class="faq-a">
          福岡大学ゴルフ部・長崎国際大学ゴルフ部（強化指定部）の現役学生を中核に、
          ゴルフ部経験者・ハンディキャップ保持者からスタートしています。
          ランク制度（Bronze / Silver / Gold）を設け、貴クラブが選べる仕組みです。
        </div>
      </details>

      <!-- 残り 6 問を同じ構造で繰り返し -->

    </div>
  </div>
</section>
```

---

## 11. Form（お問い合わせ・最終CTA代替）

```html
<form class="container container--narrow" id="contact-form" novalidate>
  <div class="field">
    <label class="label" for="company">ゴルフ場名 <span style="color:var(--color-accent)">*</span></label>
    <input class="input" type="text" id="company" name="company" required>
  </div>
  <div class="field">
    <label class="label" for="name">ご担当者さまのお名前 <span style="color:var(--color-accent)">*</span></label>
    <input class="input" type="text" id="name" name="name" required>
  </div>
  <div class="field">
    <label class="label" for="email">メールアドレス <span style="color:var(--color-accent)">*</span></label>
    <input class="input" type="email" id="email" name="email" required>
    <span class="help-text">2 営業日以内にご返信します。</span>
  </div>
  <div class="field">
    <label class="label" for="message">お問い合わせ内容（任意）</label>
    <textarea class="textarea" id="message" name="message"></textarea>
  </div>
  <button type="submit" class="btn btn--primary btn--lg" style="width:100%;">送信する</button>
</form>
```

---

## 12. Footer（K. 法人取引仕様・P-14）

```html
<footer class="footer">
  <div class="container">
    <div class="footer__grid">

      <div class="footer__col">
        <div class="footer__brand">Caddygate</div>
        <div class="footer__tagline">キャディが、開く。</div>
      </div>

      <div class="footer__col">
        <h4>サービス</h4>
        <ul>
          <li><a href="#solution">サービス紹介</a></li>
          <li><a href="#pricing">料金</a></li>
          <li><a href="#flow">導入の流れ</a></li>
          <li><a href="#faq">よくあるご質問</a></li>
          <li><a href="#contact">資料請求</a></li>
        </ul>
      </div>

      <div class="footer__col">
        <h4>運営会社</h4>
        <ul>
          <li>株式会社KAIROS</li>
          <li>〒[TBD] [TBD 住所]</li>
          <li>TEL: [TBD]</li>
          <li><a href="mailto:info@caddygate.jp">info@caddygate.jp</a></li>
        </ul>
      </div>

      <div class="footer__col">
        <h4>法務情報</h4>
        <ul>
          <li><a href="/legal/tokushoho">特定商取引法に基づく表記</a></li>
          <li><a href="/legal/privacy">プライバシーポリシー</a></li>
          <li><a href="/legal/terms">利用規約</a></li>
          <li><span class="micro" style="color:var(--color-bg); opacity:0.6;">募集情報等提供事業 届出 [TBD 番号]</span></li>
        </ul>
      </div>

    </div>
    <div class="footer__copyright">© 2026 KAIROS Inc.</div>
  </div>
</footer>
```

---

## 13. OG 画像 後加工指示（visual-implementer 用）

既存 `assets/og-image-raw.png` (1200×630) は user 生成済の素の画像。これに SVG オーバーレイで以下を載せる：

- 左下に Caddygate ロゴ（`logo-wordmark.png` を 200×48px、 #F5F0E6 単色化）
- 右下にタグライン「キャディが、開く。」を Noto Sans JP 900 / 32px / 苔緑 #2C4A3B
- もしくは半透明の古紙オフホワイト（rgba(245,240,230,0.85)）を画像下半分にグラデで重ね、その上にコピーを乗せる

簡単な実装：HTML + canvas で書き出すか、Figma で 1 回手動合成して `og-image.png` を保存。

---

## 14. アイコン使用例（Lucide）

```html
<i data-lucide="check-circle"></i>      <!-- チェック・成功 -->
<i data-lucide="phone"></i>              <!-- 電話 -->
<i data-lucide="message-square"></i>     <!-- 相談 -->
<i data-lucide="calendar-check"></i>     <!-- 予約 -->
<i data-lucide="file-text"></i>          <!-- 資料 -->
<i data-lucide="shield-check"></i>       <!-- 保険 -->
<i data-lucide="users"></i>              <!-- キャディ -->
<i data-lucide="arrow-right"></i>        <!-- CTA 矢印 -->
<i data-lucide="award"></i>              <!-- バッジ -->
<i data-lucide="map-pin"></i>            <!-- 地域 -->
```

サイズと色は CSS で制御：

```css
.icon-sm { width: 18px; height: 18px; stroke-width: 1.75; }
.icon-md { width: 24px; height: 24px; stroke-width: 1.75; }
.icon-lg { width: 32px; height: 32px; stroke-width: 1.5; }
```

---

## 15. クラス使用早見表（visual-implementer 用カンペ）

| やりたいこと | 使うクラス |
|---|---|
| ページ幅を 1120px に絞る | `.container` |
| ページ幅を 880px に絞る | `.container .container--narrow` |
| セクション間に 120px 余白 | `<section class="section">` |
| 白背景セクション | `<section class="section section--surface">` |
| 苔緑背景セクション | `<section class="section section--primary">` |
| H1 大見出し（ヒーロー以外） | `<h2 class="h1">` |
| 数字を大きく朱で | `<span class="stat-lg">600 万円</span>` |
| 3 カラムグリッド | `<div class="grid grid--3">` |
| Primary CTA | `<a class="btn btn--primary">` |
| 大きめ CTA | `<a class="btn btn--primary btn--lg">` |
| 限定バッジ | `<span class="badge badge--accent">残り 89 枠</span>` |

---

作成完了: 2026-05-31
次工程: layouts.md でセクション A〜K の組み合わせ図、responsive.md でブレイクポイント挙動を詳述。
