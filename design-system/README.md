# Caddygate Design System

作成: design-strategist
最終更新: 2026-05-31
位置付け: Caddygate LP / Web サイト全体の **デザインの憲法**。すべての視覚的判断は本ディレクトリの定義を起点とする。

---

## 0. このディレクトリの全体像

```
design-system/
├── README.md           ← 本ファイル（使い方ガイド）
├── research.md         ← Phase 1 リサーチログ（25 件観察 + 11 ファインディング）
├── principles.md       ← Phase 2 抽出した型 14 原則（Why と実装パターン）
├── tokens.md           ← CSS 変数の網羅リファレンス
├── typography.md       ← （tokens.md / principles.md 内で網羅、別ファイル不要）
├── framework.css       ← Phase 3 実装の中核（読み込めば即適用）
├── components.md       ← Header/Hero/Card/Button/FAQ 等の HTML 構造とクラス
├── layouts.md          ← A〜K 11 セクションのレイアウト型
├── responsive.md       ← ブレイクポイント・モバイル挙動・パフォーマンス
└── tone-of-voice.md    ← 視覚要素のトーン規定（写真・アイコン・絵文字）
```

---

## 1. 使い方（visual-implementer 向け）

### 1-A. 新しい HTML ページを作るとき

1. **components.md §1「Page Skeleton」** をコピーして head と body 骨格を作る
2. `<link rel="stylesheet" href="/design-system/framework.css">` でフレームワーク読み込み
3. **layouts.md** でセクション A〜K の順序と構造を確認
4. **components.md §2 以降** で各セクションの HTML をコピペし、コピーは `lp-copy-2026-05.md` から差し込む
5. 実装後 **responsive.md §10「レスポンシブ・チェックリスト」** と **tone-of-voice.md §8「一貫性チェックリスト」** を全件パス

### 1-B. 色・サイズ・余白を決めるとき

1. まず **tokens.md** で既存トークンを探す
2. 該当があれば `var(--token-name)` で参照
3. なければ **principles.md** に該当する原則があるか確認
4. それでもなければ Takumi or design-strategist にエスカレーション（Ad-hoc 追加禁止）

### 1-C. 新しいコンポーネントを作るとき

1. **components.md** に既存類似コンポーネントがあるか確認
2. なければ既存パターンの組み合わせで作れるか試す
3. 真に新規なら components.md に追加 + framework.css にクラス追加
4. 追加した変更は本 README の「変更履歴」に記録

---

## 2. 使い方（copywriter / brand-strategist 向け）

- 視覚トーン（写真選び・アイコン使い）の規定は **tone-of-voice.md** を参照
- 文言・コピーのトーンは **brand-identity.md** §4「ボイス＆トーン」が正典（本DS は視覚のみを規定する）
- 14 原則は **principles.md** で確認可能

---

## 3. 使い方（legal-advisor 向け）

- フッターの法人取引仕様要件は **principles.md P-14** に明文化
- 「特商法表記・プライバシーポリシー・利用規約・募集情報等提供事業 届出」の 4 点が必須
- これらのドキュメントが揃わない限り、LP 公開を待つ判断あり（FB-09 を design-system に格上げした重大要件）

---

## 4. 編集権限とバージョニング

### 4-A. 編集権限

| ファイル | 編集してよい役割 |
|---|---|
| `principles.md` | design-strategist のみ（Takumi 承認後） |
| `tokens.md` / `framework.css` | design-strategist + visual-implementer（実装上の必要時） |
| `components.md` / `layouts.md` | visual-implementer（新規追加時、必ず principles.md 準拠） |
| `responsive.md` / `tone-of-voice.md` | design-strategist |
| `research.md` | design-strategist のみ（リサーチ追加時） |
| `README.md`（本ファイル） | design-strategist |

### 4-B. バージョニング

- v1.0 = 2026-05-31 初版（本リリース）
- 大きな改訂時は本 README に変更履歴を追加
- セマンティック相当:
  - メジャー: 原則の追加・削除（principles.md の構造変化）
  - マイナー: コンポーネント追加、トークン追加
  - パッチ: 軽微な値変更、誤字修正

### 4-C. 変更履歴

| バージョン | 日付 | 変更内容 |
|---|---|---|
| 1.0 | 2026-05-31 | 初版。25 件リサーチ + 14 原則 + 全ファイル整備 |

---

## 5. 関連ドキュメント（design-system 外）

- `~/caddytas/brand-identity.md` — タグライン・ボイス・カラー三本柱の出典
- `~/caddytas/lp-copy-2026-05.md` — copywriter 確定コピー（本DS の実装対象）
- `~/caddytas/visual-assets-spec.md` — 画像生成プロンプトと素材リスト
- `~/caddytas/design-feedback-2026-05.md` — design-strategist 初回 FB（本DS の問題意識の出発点）
- `~/caddytas/sales-strategy.md` — 事業戦略（Pricing 左列強調などの根拠）
- `~/caddytas/assets/` — 確定済の画像アセット（hero / caddies / logo / og-raw）

---

## 6. 重要な前提（再掲・厳守）

### 6-A. トーンは「現代ミニマル × 日本 B2B 実用感」
brand-strategist 当初の「明朝×老舗ゴルフクラブ」格式路線は **「厳か too much」と user 判定**で破棄済。**明朝復活禁止**。

### 6-B. カラーパレットは brand-strategist 確定通り
- 苔緑 #2C4A3B / 古紙オフホワイト #F5F0E6 / 朱 #B83A2E
- ベタなゴルフ緑（鮮緑）禁止、ゴールド使用禁止

### 6-C. ターゲット
九州（福岡・長崎）のゴルフ場 支配人・運営会社決裁者（50-60代男性中心）
- 本文 16-17px 下限（可読性）
- 法人取引仕様フッター必須
- 装飾過多・煽り表現 NG

### 6-D. 既往 CSS 継ぎ足し問題は完全廃止
- `html { font-size: 150%; }` 撤廃
- 「約 2/3」「約 1/3」の強引縮小撤廃
- すべて clamp() ベースのスケールに刷新

---

## 7. visual-implementer への引き継ぎサマリ

`~/caddytas/index.html`（現状は準備中ページ）を以下の手順で完全置換：

1. `design-system/framework.css` を読み込み
2. `components.md §1 Page Skeleton` で骨格を作る
3. `layouts.md` の A〜K 順序で各セクションを組み立て
4. 各セクションの HTML 構造は `components.md §2-12` を参照
5. コピーは `~/caddytas/lp-copy-2026-05.md` から差し込み
6. アセットは `~/caddytas/assets/` を参照（`/assets/...` 相対パス）
7. `og-image.png` は `og-image-raw.png` を `components.md §13` の指示で後加工
8. `responsive.md §10` と `tone-of-voice.md §8` のチェックリストを全件パス

**優先適用すべき原則**: P-03（余白）/ P-04（フォント）/ P-05（タイポスケール）/ P-12（Pricing 左列強調）/ P-14（フッター法人取引仕様）

---

作成完了: 2026-05-31
本 design-system が Caddygate のすべての視覚的判断の起点となる。**この憲法に従う限り、誰が触っても一定品質の Web 体験を保てる**。
