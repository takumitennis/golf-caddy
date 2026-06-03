# Caddygate Dashboard Components

作成: design-strategist
作成日: 2026-06-01
目的: dashboard-framework.css のクラスを使った HTML 構造を、visual-implementer がコピペで動かせる粒度で定義する。既存の Supabase JS / DOM ID は壊さない前提で、**外側のクラス追加 + 内側 inline style 削除** が基本作業。

## 0. 共通ルール

- HTML はセマンティックに（`<aside>` / `<main>` / `<nav>` / `<button>` 等）
- アイコンは Lucide CDN を `<head>` で 1 回読み込み、`<i data-lucide="...">` で配置
- 既存の Supabase JS の DOM 取得 ID は維持。新規クラスは ID と並行して付与
- すべての inline style は class に置換

---

## 1. Page Skeleton（ダッシュボード全体構造）

```html
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5">
  <title>ゴルフ場マイページ | Caddygate</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">

  <!-- LP framework を先に、dashboard を後に -->
  <link rel="stylesheet" href="/design-system/framework.css">
  <link rel="stylesheet" href="/design-system/dashboard-framework.css">

  <link rel="icon" type="image/png" href="/assets/logo-symbol.png">
</head>
<body>
  <div class="dash-shell">

    <!-- 1. Desktop Sidebar -->
    <aside class="dash-sidebar">
      <div class="dash-sidebar__brand">
        <img src="/assets/logo-symbol.png" alt="" width="24" height="24">
        Caddygate
      </div>

      <div class="dash-sidebar__group">
        <div class="dash-sidebar__group-label">予約</div>
        <a class="dash-nav-item is-active" href="#stat">
          <i data-lucide="calendar-check" class="dash-nav-item__icon"></i>
          予約管理
        </a>
        <a class="dash-nav-item" href="#caddies">
          <i data-lucide="users" class="dash-nav-item__icon"></i>
          空きキャディ
        </a>
        <a class="dash-nav-item" href="#confirm">
          <i data-lucide="check-circle" class="dash-nav-item__icon"></i>
          予約確認
        </a>
      </div>

      <div class="dash-sidebar__group">
        <div class="dash-sidebar__group-label">研修</div>
        <a class="dash-nav-item" href="#training-days">
          <i data-lucide="calendar-days" class="dash-nav-item__icon"></i>
          研修可能日
        </a>
        <a class="dash-nav-item" href="#training-list">
          <i data-lucide="clipboard-list" class="dash-nav-item__icon"></i>
          研修予約者
          <span class="dash-nav-item__badge">3</span>
        </a>
      </div>

      <div class="dash-sidebar__group">
        <div class="dash-sidebar__group-label">設定</div>
        <a class="dash-nav-item" href="#profile">
          <i data-lucide="user" class="dash-nav-item__icon"></i>
          プロフィール
        </a>
      </div>

      <div class="dash-sidebar__footer">
        <div class="dash-header__user" id="welcome">ゴルフ場名</div>
        <button id="logoutBtn" class="btn--ghost">
          <i data-lucide="log-out" style="width:14px;height:14px"></i>
          ログアウト
        </button>
      </div>
    </aside>

    <!-- 2. Main -->
    <main class="dash-main">
      <header class="dash-header">
        <h1 class="dash-header__title">予約管理</h1>
        <div class="dash-header__actions">
          <button class="btn--icon" aria-label="通知">
            <i data-lucide="bell"></i>
          </button>
        </div>
      </header>

      <!-- 3. KPI Strip -->
      <section class="kpi-strip">…</section>

      <!-- 4. Tabs（必要な場合のみ） -->
      <nav class="dash-tabs">…</nav>

      <!-- 5. Main content -->
      <section class="dash-section">…</section>
    </main>

    <!-- 6. Mobile Bottom Nav -->
    <nav class="dash-bottom-nav">
      <a class="dash-bottom-nav__item is-active" href="#stat">
        <i data-lucide="calendar-check"></i> 予約
      </a>
      <a class="dash-bottom-nav__item" href="#caddies">
        <i data-lucide="users"></i> キャディ
      </a>
      <a class="dash-bottom-nav__item" href="#training-list">
        <i data-lucide="clipboard-list"></i> 研修
      </a>
      <a class="dash-bottom-nav__item" href="#profile">
        <i data-lucide="user"></i> 設定
      </a>
    </nav>
  </div>

  <!-- Lucide -->
  <script src="https://unpkg.com/lucide@latest"></script>
  <script>lucide.createIcons();</script>
</body>
</html>
```

---

## 2. KPI Strip（Home 上部 4 指標）

```html
<section class="kpi-strip">
  <article class="kpi-card">
    <div class="kpi-card__label">今週の予約</div>
    <div class="kpi-card__value">12<span class="kpi-card__unit">件</span></div>
    <div class="kpi-card__delta kpi-card__delta--up">先週比 +2</div>
  </article>
  <article class="kpi-card">
    <div class="kpi-card__label">来週の予約</div>
    <div class="kpi-card__value">8<span class="kpi-card__unit">件</span></div>
    <div class="kpi-card__delta">先週同曜日比 ±0</div>
  </article>
  <article class="kpi-card">
    <div class="kpi-card__label">待機キャディ</div>
    <div class="kpi-card__value">5<span class="kpi-card__unit">名</span></div>
    <div class="kpi-card__delta">9/15 時点</div>
  </article>
  <article class="kpi-card">
    <div class="kpi-card__label">研修希望者</div>
    <div class="kpi-card__value">3<span class="kpi-card__unit">名</span></div>
    <div class="kpi-card__delta kpi-card__delta--up">+1（新規）</div>
  </article>
</section>
```

---

## 3. Tabs（underline 型）

既存の `.tabs` / `.tabs-main` クラスを `.dash-tabs` に置換。

```html
<nav class="dash-tabs" role="tablist" aria-label="予約管理タブ">
  <button id="btnTab1" class="dash-tab is-active" role="tab" aria-selected="true">空きキャディ確認</button>
  <button id="btnTabConfirm" class="dash-tab" role="tab" aria-selected="false">予約確認</button>
  <button id="btnTab3" class="dash-tab" role="tab" aria-selected="false">研修可能日設定</button>
  <button id="btnTab4" class="dash-tab" role="tab" aria-selected="false">研修予約者一覧</button>
</nav>
```

JS で active class 切替時:
```js
document.querySelectorAll('.dash-tab').forEach(t => {
  t.classList.remove('is-active');
  t.setAttribute('aria-selected', 'false');
});
btn.classList.add('is-active');
btn.setAttribute('aria-selected', 'true');
```

---

## 4. Status Badge

```html
<!-- 状態表示 -->
<span class="badge badge--pending">仮予約</span>
<span class="badge badge--confirmed">確定</span>
<span class="badge badge--completed">完了</span>
<span class="badge badge--cancelled">キャンセル</span>
<span class="badge badge--error">拒否</span>
```

table のセル内、card 内、drawer 内、どこでも一貫して使う。

---

## 5. Data Table（予約一覧 / キャディ一覧）

```html
<div class="dash-section">
  <div class="dash-section__head">
    <h2 class="dash-section__title">今週の予約</h2>
    <div class="dash-section__actions">
      <button class="btn--ghost">CSV 書き出し</button>
    </div>
  </div>

  <table class="dash-table">
    <thead>
      <tr>
        <th>日付</th>
        <th>時間</th>
        <th>キャディ</th>
        <th>顧客</th>
        <th class="col-num">人数</th>
        <th>状態</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <tr data-booking-id="b001">
        <td>9/15（日）</td>
        <td>7:30</td>
        <td>佐藤 健太</td>
        <td>山田組（4名）</td>
        <td class="col-num">4</td>
        <td><span class="badge badge--confirmed">確定</span></td>
        <td><button class="btn--icon" aria-label="詳細"><i data-lucide="chevron-right"></i></button></td>
      </tr>
      <tr data-booking-id="b002">
        <td>9/16（月）</td>
        <td>8:00</td>
        <td>—</td>
        <td>—</td>
        <td class="col-num">2</td>
        <td><span class="badge badge--pending">仮予約</span></td>
        <td><button class="btn--icon"><i data-lucide="chevron-right"></i></button></td>
      </tr>
    </tbody>
  </table>
</div>
```

行 hover で背景 `--color-bg`、行クリックで drawer 開閉（後述）。

---

## 6. Booking Card（カレンダー上 / モバイル予約リスト）

```html
<div class="dash-list">
  <article class="booking-card" data-booking-id="b001">
    <div class="booking-card__date">
      <span class="booking-card__date-num">15</span>
      <span class="booking-card__date-month">9月</span>
      <span class="booking-card__date-day">日</span>
    </div>
    <div class="booking-card__main">
      <div class="booking-card__title">7:30 — 山田組（4名）</div>
      <div class="booking-card__meta">
        <span><i data-lucide="user" style="width:12px"></i> 佐藤 健太</span>
        <span><i data-lucide="map-pin" style="width:12px"></i> アウト 1番</span>
      </div>
    </div>
    <div class="booking-card__actions">
      <span class="badge badge--confirmed">確定</span>
      <button class="btn--icon" aria-label="詳細"><i data-lucide="chevron-right"></i></button>
    </div>
  </article>
</div>
```

---

## 7. Person Card（キャディ一覧 / ゴルフ場一覧）

```html
<div class="dash-grid-2">
  <article class="person-card" data-caddy-id="c001">
    <div class="person-card__avatar">佐</div>
    <div class="person-card__info">
      <div class="person-card__name">佐藤 健太</div>
      <div class="person-card__meta">福岡大学・経験 1年・☆ 4.8（12件）</div>
    </div>
    <div class="person-card__actions">
      <button class="btn btn--primary btn--sm">予約する</button>
    </div>
  </article>

  <article class="person-card" data-caddy-id="c002">
    <div class="person-card__avatar">
      <img src="/assets/caddy-002.jpg" alt="">
    </div>
    <div class="person-card__info">
      <div class="person-card__name">田中 翔</div>
      <div class="person-card__meta">九州大学・経験 2年・☆ 4.9（28件）</div>
    </div>
    <div class="person-card__actions">
      <button class="btn btn--ghost btn--sm">詳細</button>
    </div>
  </article>
</div>
```

---

## 8. Calendar Grid（4 状態）

```html
<div class="cal-shell">
  <div class="cal-toolbar">
    <div class="cal-toolbar__nav">
      <button class="cal-toolbar__nav-btn" id="prevMonth" aria-label="前月">
        <i data-lucide="chevron-left"></i>
      </button>
      <button class="cal-toolbar__nav-btn" id="nextMonth" aria-label="翌月">
        <i data-lucide="chevron-right"></i>
      </button>
    </div>
    <div class="cal-toolbar__title" id="calTitle">2026年 9月</div>
    <div class="cal-toolbar__nav">
      <button class="btn--ghost">今月へ</button>
    </div>
  </div>

  <table class="cal-grid">
    <thead>
      <tr>
        <th>日</th><th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="cal-outside"><span class="cal-date">31</span></td>
        <td class="cal-available"><span class="cal-date">1</span><span class="cal-mark"></span></td>
        <td class="cal-available"><span class="cal-date">2</span><span class="cal-mark"></span></td>
        <td class="cal-confirmed"><span class="cal-date">3</span><span class="cal-note">山田組</span><span class="cal-mark"></span></td>
        <td class="cal-warn"><span class="cal-date">4</span><span class="cal-note">残1名</span><span class="cal-mark"></span></td>
        <td class="cal-available"><span class="cal-date">5</span><span class="cal-mark"></span></td>
        <td class="cal-disabled"><span class="cal-date">6</span><span class="cal-mark"></span></td>
      </tr>
      <!-- 以下続く -->
    </tbody>
  </table>

  <div class="cal-legend">
    <span class="cal-legend__item">
      <span class="cal-legend__swatch" style="background:var(--color-surface)"></span> ○ 空き
    </span>
    <span class="cal-legend__item">
      <span class="cal-legend__swatch" style="background:var(--color-primary-soft-bg)"></span> ✓ 確定
    </span>
    <span class="cal-legend__item">
      <span class="cal-legend__swatch" style="background:var(--color-warn-soft)"></span> △ 残少
    </span>
    <span class="cal-legend__item">
      <span class="cal-legend__swatch" style="background:var(--color-gray-soft)"></span> × 不可
    </span>
  </div>
</div>
```

---

## 9. Drawer（予約詳細・キャディ詳細）

```html
<!-- backdrop + drawer -->
<div class="drawer-backdrop" id="drawerBackdrop" data-open="false"></div>
<aside class="drawer" id="bookingDrawer" data-open="false" aria-hidden="true" role="dialog" aria-labelledby="drawerTitle">
  <header class="drawer__header">
    <h2 class="drawer__title" id="drawerTitle">予約詳細</h2>
    <button class="drawer__close" id="drawerClose" aria-label="閉じる">
      <i data-lucide="x"></i>
    </button>
  </header>

  <div class="drawer__body">
    <div class="form-field">
      <div class="form-field__label">日時</div>
      <div>9/15（日）7:30</div>
    </div>
    <div class="form-field">
      <div class="form-field__label">キャディ</div>
      <div>佐藤 健太</div>
    </div>
    <div class="form-field">
      <div class="form-field__label">顧客</div>
      <div>山田組（4名）</div>
    </div>
    <div class="form-field">
      <div class="form-field__label">状態</div>
      <div><span class="badge badge--confirmed">確定</span></div>
    </div>
    <div class="form-field">
      <label class="form-field__label" for="bkNote">メモ</label>
      <textarea class="form-textarea" id="bkNote"></textarea>
    </div>
  </div>

  <footer class="drawer__footer">
    <button class="btn--ghost" id="drawerCancel">閉じる</button>
    <button class="btn--danger">予約取消</button>
    <button class="btn btn--primary">保存</button>
  </footer>
</aside>
```

JS:
```js
function openDrawer(id) {
  document.getElementById('drawerBackdrop').dataset.open = 'true';
  document.getElementById(id).dataset.open = 'true';
  document.getElementById(id).setAttribute('aria-hidden', 'false');
}
function closeDrawer(id) {
  document.getElementById('drawerBackdrop').dataset.open = 'false';
  document.getElementById(id).dataset.open = 'false';
  document.getElementById(id).setAttribute('aria-hidden', 'true');
}
document.getElementById('drawerClose').onclick = () => closeDrawer('bookingDrawer');
document.getElementById('drawerBackdrop').onclick = () => closeDrawer('bookingDrawer');
```

---

## 10. Modal（critical な確認のみ）

```html
<div class="modal-backdrop" id="logoutBackdrop" data-open="false">
  <div class="modal" role="dialog" aria-labelledby="logoutModalTitle">
    <h2 class="modal__title" id="logoutModalTitle">ログアウトしますか？</h2>
    <p class="modal__body">未保存の入力があれば、保存されません。</p>
    <div class="modal__actions">
      <button class="btn--ghost" id="logoutCancel">キャンセル</button>
      <button class="btn btn--primary" id="logoutConfirm">ログアウト</button>
    </div>
  </div>
</div>
```

---

## 11. Empty State

```html
<div class="empty">
  <i data-lucide="calendar" class="empty__icon"></i>
  <div class="empty__title">今週はまだ予約がありません</div>
  <div class="empty__desc">空きキャディから予約を始めましょう。</div>
  <a href="#caddies" class="btn btn--primary btn--sm">空きキャディを探す</a>
</div>
```

---

## 12. Chat（業務向けにリフレッシュ）

```html
<div class="chat-shell">
  <div class="chat-list" id="chatList">
    <div class="chat-bubble chat-bubble--received">
      明日のスタート時間を確認したいです。
      <div class="chat-meta">14:32</div>
    </div>
    <div class="chat-bubble chat-bubble--sent">
      7:30 です。よろしくお願いします。
      <div class="chat-meta chat-meta--sent">14:35</div>
    </div>
  </div>
  <div class="chat-input-area">
    <input type="text" class="chat-input" id="chatInput" placeholder="メッセージを入力">
    <button class="btn btn--primary" id="sendChatBtn">送信</button>
  </div>
</div>
```

---

## 13. Toast（操作完了通知）

```html
<div class="toast-stack" id="toastStack"></div>
```

```js
function toast(message, type = 'success') {
  const el = document.createElement('div');
  el.className = `toast toast--${type}`;
  el.textContent = message;
  document.getElementById('toastStack').appendChild(el);
  setTimeout(() => el.remove(), 4000);
}
toast('予約を保存しました');
```

---

## 14. Form（プロフィール編集）

既存の inline style 形式を form-field 構造に置き換え:

```html
<form id="gcCreateForm" class="card">
  <h3 class="card__title">プロフィールを登録してください</h3>

  <div class="form-field">
    <label class="form-field__label" for="gcName">ゴルフ場名</label>
    <input type="text" id="gcName" class="form-input" required>
  </div>

  <div class="form-field">
    <label class="form-field__label" for="gcContact">担当者名</label>
    <input type="text" id="gcContact" class="form-input">
  </div>

  <div class="form-field">
    <label class="form-field__label" for="gcPhone">電話番号</label>
    <input type="tel" id="gcPhone" class="form-input">
    <span class="form-field__hint">ハイフンなし</span>
  </div>

  <div class="dash-grid-2">
    <div class="form-field">
      <label class="form-field__label" for="gcPrefecture">都道府県</label>
      <select id="gcPrefecture" class="form-select">
        <option value="">選択してください</option>
        <!-- 既存の option をそのまま -->
      </select>
    </div>
    <div class="form-field">
      <label class="form-field__label" for="gcCity">市区町村</label>
      <input type="text" id="gcCity" class="form-input" placeholder="例: 福岡市">
    </div>
  </div>

  <div class="form-field">
    <label class="form-field__label" for="gcPerks">特典</label>
    <input type="text" id="gcPerks" class="form-input" placeholder="例: 打ちっぱなし無料">
    <span class="form-field__hint">キャディに表示される特典です</span>
  </div>

  <div style="text-align:right;">
    <button type="submit" class="btn btn--primary">保存して予約管理へ</button>
  </div>
</form>
```

---

## 15. 既存 inline style → class 置換マップ

visual-implementer は以下のマッピング表を機械的に適用すること。

| 既存 inline / class | 置換先 |
|---|---|
| `<h1 style="...">ゴルフ場マイページ</h1>` | `<header class="dash-header"><h1 class="dash-header__title">予約管理</h1></header>` |
| `.tabs-main` | `.dash-tabs`（+ 各 button に `.dash-tab`） |
| `.tabs` | `.dash-tabs`（+ 各 button に `.dash-tab`） |
| `.card`（古い inline shadow 版） | そのまま `.card`（dashboard-framework が上書き） |
| `#logoutBtn` の `background: #dc3545` | `.btn--ghost` クラス（赤塗り削除） |
| `.calendar` table | `.cal-grid`（th/td に対応） |
| `.cal-green / .cal-yellow / .cal-red` | `.cal-confirmed / .cal-warn / .cal-disabled` |
| `.chat-bubble.sent / .received` | `.chat-bubble--sent / .chat-bubble--received` |
| `<h1 style="background:#2c3e50;color:#fff;">` | `<header class="dash-header">`（紺背景バーを削除） |
| `style="background:#fff;border-radius:8px;padding:16px;box-shadow:..."` | `class="card"` |
| `style="background:#27ae60;color:#fff;border:none;border-radius:6px;padding:10px 16px;"` | `class="btn btn--primary"` |

---

## 16. 実装チェックリスト

visual-implementer が完了時に検証:

- [ ] body 直下が `.dash-shell`（sidebar + main 構造）
- [ ] sidebar が固定 240px、active item に `.is-active`
- [ ] header に `box-shadow` がない（border-bottom のみ）
- [ ] タブが underline 型（box-shadow / transform / 緑塗りなし）
- [ ] logout ボタンが ghost（赤塗りなし）
- [ ] 全 status 表記が `.badge--*` で統一
- [ ] table が zebra なし、border-bottom のみ
- [ ] カレンダーが 4 状態 + アイコン併記
- [ ] 詳細表示が modal ではなく drawer
- [ ] empty state が「icon + copy + CTA 1個」
- [ ] inline style が全て削除（または `style="display:none"` のみ許可）
- [ ] mobile で sidebar 非表示、bottom nav 表示
- [ ] 既存の Supabase JS 呼び出しが壊れていない（DOM ID 維持）
