# Caddygate Dashboard — Before / After ギャップ分析

作成: design-strategist
作成日: 2026-06-01
目的: 現状の golf_dashboard.html / caddy_dashboard.html / profile.html / dashboard.html を観察し、刷新後の到達点との差分を**事実の積み重ね**で言語化する。

---

## 0. 観察した現状ファイル

- `/Users/takumi/caddytas/golf_dashboard.html`（100KB, ゴルフ場側ダッシュボード）
- `/Users/takumi/caddytas/caddy_dashboard.html`（92KB, キャディ側ダッシュボード）
- `/Users/takumi/caddytas/profile.html`（13KB, プロフィール編集）
- `/Users/takumi/caddytas/dashboard.html`（2.3KB, 振り分けハブ）

---

## 1. ヘッダー（Before / After）

### Before（現状）
```css
h1{margin:0;padding:20px 24px;background:#2c3e50;color:#fff;font-size:1.4rem}
```
- 青系紺 #2c3e50 のべた塗り
- LP 側の brand color（苔緑 #2f8f2f）と無関係 = **2 つの異なるサービスに見える**
- Caddy dashboard では #34495e と微妙に異なる青 → 2 つのダッシュボード間でも統一されていない

### After（型）
- header は `background: var(--color-surface)` + `border-bottom: 1px solid var(--color-border)` のフラット型
- title は dark text（var(--color-ink)）
- LP ヘッダー（白ベース + 苔緑 wordmark）と完全に同一トーン
- → **「ログイン前と後で同じサービスに見える」状態を達成**

---

## 2. タブナビ（Before / After）

### Before（現状）
```css
.tabs-main button.active{
  background: #27ae60;
  color: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(39,174,96,0.25);
  transform: translateY(-2px);
}
.tabs-main button:hover{
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.12);
}
```
- active は緑塗り + 浮き上がり + シャドウ + 12px radius = **B2C アプリ感**
- 全 5 タブが羅列、機能追加で破綻するレイアウト
- hover の transform で UI がガタつく
- `#27ae60`（鮮緑）は LP の苔緑 #2f8f2f と微妙に違う → ブランド劣化

### After（型）
- underline 型（`border-bottom: 2px solid var(--color-primary)`）
- box-shadow / transform / 緑塗り全部削除
- desktop は sidebar に昇格、mobile のみ bottom nav
- LP 設計哲学 P-08「グラデ・シャドウ原則禁止」と整合

---

## 3. logout ボタン（Before / After）

### Before（現状）
```css
#logoutBtn{
  background: #dc3545 !important;
  color: #fff !important;
}
```
- 真っ赤 #dc3545、`!important` を 4 箇所付与
- 「危険を示す赤」をログアウトに使う = **毎日見たくない**
- 50-60 代男性ターゲットには威圧的

### After（型）
- ghost button（`btn--ghost`）に降格、border のみ
- sidebar 最下部、または header 右端の小ボタン
- 誤クリック防止は modal で（赤塗りで威嚇しない）

---

## 4. カレンダー（Before / After）

### Before（現状）
```css
.cal-green{background:#c8e6c9}
.cal-yellow{background:#fff9c4}
.cal-red{background:#ffcdd2}
```
- 色だけで意味（OK / 残少 / NG）を示す
- 凡例なし
- 50-60 代の色覚多様性に未対応
- 印刷すると区別困難

### After（型）
- 4 状態（`.cal-available / .cal-confirmed / .cal-warn / .cal-disabled`）
- 各セルに ○ / ✓ / △ / × の小マーク併記
- 下部に legend 帯
- 「今日」は box-shadow inset で枠強調

---

## 5. table（Before / After）

### Before（現状）
```css
th,td{border:1px solid #ccc;padding:8px;text-align:center}
th{background:#f2f2f2}
```
- 全セルに 1px border = 「Excel スプレッドシート」感
- 全列 center 寄せ = 数字と文字が読みにくい
- padding 8px = 50-60 代男性のタップ精度に不十分
- 行高指定なし

### After（型）
- セル borderless、row 単位で border-bottom 1px のみ
- 数値列 right、文字列 left
- 行高 48px 固定（normal）、padding 12px / 16px
- thead 背景のみ `--color-surface-alt`、本体は white

---

## 6. card / form（Before / After）

### Before（現状）
- inline style だらけ:
```html
<div style="max-width:560px;margin:0 auto;background:#fff;border-radius:8px;padding:16px;box-shadow:0 2px 6px rgba(0,0,0,.08)">
  <input style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;">
  <button style="background:#27ae60;color:#fff;border:none;border-radius:6px;padding:10px 16px;">
```
- 全ての装飾が inline = メンテ不能
- box-shadow ありフラット原則違反
- ボタン色 #27ae60 が LP token と乖離

### After（型）
- `.card` / `.form-field` / `.form-input` / `.btn btn--primary` に統一
- inline style 完全削除
- shadow 削除、border 1px のみ
- LP framework token を継承し色ズレ解消

---

## 7. 状態表示（Before / After）

### Before（現状）
- 一覧上は文字列のみ（「仮予約」「予約済」等）
- 一部に絵文字（チャットの "🟢未読" 等）
- 表記ゆれあり（「予約確定」「確定」「予約済」が混在）

### After（型）
- `.badge badge--{pending|confirmed|completed|cancelled|error}` で 5 種類に統一
- ●dot + label の組み合わせ
- 表記は「仮予約 / 確定 / 完了 / キャンセル / 拒否」の 5 語に固定

---

## 8. 詳細表示（Before / After）

### Before（現状）
- `#reserveBar` は画面下に fixed の小バー、見落としやすい
- 予約詳細 / キャディ詳細はインラインで展開、リストが見えなくなる
- modal も多用、context が毎回切れる

### After（型）
- 詳細 = 右からスライドの drawer（mobile = bottom sheet）
- 親リストが見えたまま編集可能
- modal は logout / 予約取消の確認 2 種類のみ

---

## 9. 余白（Before / After）

### Before（現状）
```css
.container{padding:24px}
.card{padding:20px;margin-bottom:24px}
.tabs-main{padding:16px;margin:16px}
```
- 数値が中途半端（20px / 16px / 24px が混在）
- 8px グリッドに乗っていない
- セクション間概念なし

### After（型）
- すべて `--space-{1-12}` トークンから選択
- セクション間 32px、card 間 12px、card 内 16-24px
- 数値ゆらぎゼロ

---

## 10. font / 色（Before / After）

### Before（現状）
```css
body{font-family:'Segoe UI',sans-serif;background:#f5f6fa}
```
- font は Segoe UI、Windows 専用フォント → Mac/iPhone でフォールバック発生
- 背景 #f5f6fa は冷たい青グレー → LP の古紙オフホワイト #F5F0E6 と全く違う
- 結果として **LP は温かみ、dashboard は冷たい** ちぐはぐ印象

### After（型）
- font は `Inter + Noto Sans JP`（LP と同一）
- background は `--color-bg` (#F5F0E6 古紙オフホワイト)
- LP と dashboard が同じ「世界観」になる

---

## 11. KPI 可視化（Before / After）

### Before（現状）
- 数字表示なし
- 「welcome」文字（ゴルフ場名）だけが上に表示
- 「今週の予約 / 待機キャディ / 研修希望者」が一覧してすぐ分からない

### After（型）
- 上部 4 連 KPI ストリップ
- ゴルフ場側: 今週予約 / 来週予約 / 待機キャディ / 研修希望者
- キャディ側: 今週予約 / 今月収入見込 / 未対応研修 / 未読メッセージ
- Home 着地 3 秒で業務状態が把握可能

---

## 12. empty state（Before / After）

### Before（現状）
- 「データなし」「該当なし」のみ
- 何をすればいいか不明
- 新規登録直後のユーザーが迷子になる

### After（型）
- `mono icon + warm copy + 1 CTA` で次の一歩を提示
- 例: 「今週はまだ予約がありません」+ [空きキャディを探す]

---

## 13. mobile 対応（Before / After）

### Before（現状）
```css
@media (max-width: 768px){
  .tabs-main{padding:12px;gap:6px;margin:12px;}
  .tabs-main button{padding:8px 10px;font-size:0.8rem;min-height:50px;flex:1;min-width:90px;max-width:120px;}
}
```
- タブが折り返して 2-3 段になる
- table はそのまま、横スクロール発生
- bottom nav なし、上タブのまま

### After（型）
- desktop sidebar / mobile bottom nav の切替（767px breakpoint）
- table は mobile では card 表示に切替（`.booking-card` 等）
- drawer は mobile で bottom sheet 化（上スワイプ）

---

## 14. 全体トーン（Before / After）

### Before のトーン
- 「個人開発 SaaS の MVP」感
- B2C アプリの装飾（緑塗りボタン + 浮き上がり）と業務 SaaS の地味さが混在
- LP の苔緑/朱/古紙オフホワイトの世界観と乖離

### After のトーン
- 「日本 B2B SaaS の現代標準」感（SmartHR / freee / Sansan ライン）
- 装飾を引いた静謐さ、数字と予約が主役
- LP との完全な世界観統一

---

## 15. 工数見積（実装側への参考）

実装側は以下の優先順で進めると、見た目の刷新効果が最大化する:

| 優先 | 対象 | 工数感 | 効果 |
|---|---|---|---|
| **最高** | dash-shell + sidebar + header（D-01, D-11） | 半日 | 第一印象 95% 改善 |
| **最高** | tab を underline 化（D-02） | 1-2 時間 | B2C 感の払拭 |
| **高** | badge 統一（D-03） | 1-2 時間 | 状態表現の一貫性 |
| **高** | calendar 4 状態化（D-05） | 半日 | 業務理解度向上 |
| **高** | card 3 種固定 + inline style 削除（D-06） | 1 日 | 保守性確保 |
| **中** | KPI ストリップ（D-08） | 半日 | Home 体験向上 |
| **中** | drawer 化（D-07） | 半日 | 詳細編集の context 維持 |
| **中** | empty state（D-09） | 2-3 時間 | onboarding 体験 |
| **低** | toast / chat（既存稼働中、優先度低） | 半日 | 完成度の底上げ |

---

## 16. 結論：刷新の最大効果ポイント

**「ヘッダー紺 + タブ緑塗り浮き + logout 赤塗り」の 3 大装飾を消すだけで、現代 B2B SaaS の見た目になる。**

これは P-08（グラデ・シャドウ原則禁止）の dashboard 適用に過ぎず、追加デザイン作業は不要。むしろ「**装飾を引く**」作業が刷新の中核。
