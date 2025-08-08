# Supabase ストレージバケット設定手順

## 1. アバター画像用ストレージバケットの作成

### 手順1: Supabaseダッシュボードにアクセス
1. [Supabase](https://supabase.com) にログイン
2. プロジェクト `golf-caddy-org` を選択

### 手順2: ストレージバケットを作成
1. 左サイドバーから **Storage** をクリック
2. **New bucket** ボタンをクリック
3. 以下の設定でバケットを作成：
   - **Bucket name**: `avatars`
   - **Public bucket**: ✅ チェック（画像を公開表示するため）
   - **File size limit**: `5MB`
   - **Allowed MIME types**: `image/*`

### 手順3: ストレージポリシーを設定
1. 作成した `avatars` バケットをクリック
2. **Policies** タブをクリック
3. **Enable RLS** を有効化
4. 以下のポリシーを順番に追加：

#### ポリシー1: 画像のアップロード
```sql
CREATE POLICY "Users can upload their own avatar" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'avatars' AND 
  auth.uid()::text = (storage.foldername(name))[1]
);
```

#### ポリシー2: 画像の表示
```sql
CREATE POLICY "Avatar images are publicly viewable" ON storage.objects
FOR SELECT USING (bucket_id = 'avatars');
```

#### ポリシー3: 画像の更新
```sql
CREATE POLICY "Users can update their own avatar" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'avatars' AND 
  auth.uid()::text = (storage.foldername(name))[1]
);
```

#### ポリシー4: 画像の削除
```sql
CREATE POLICY "Users can delete their own avatar" ON storage.objects
FOR DELETE USING (
  bucket_id = 'avatars' AND 
  auth.uid()::text = (storage.foldername(name))[1]
);
```

## 2. データベーステーブルの更新

### SQLスクリプトの実行
1. **SQL Editor** を開く
2. `UPDATE_CADDY_PROFILE_FIELDS.sql` の内容を実行：

```sql
-- キャディテーブルにプロフィール関連フィールドを追加
ALTER TABLE public.caddies 
ADD COLUMN IF NOT EXISTS avatar_url TEXT,
ADD COLUMN IF NOT EXISTS birth_date DATE,
ADD COLUMN IF NOT EXISTS university TEXT,
ADD COLUMN IF NOT EXISTS golf_years INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS caddy_years INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS appeal TEXT;
```

## 3. 動作確認

### 確認項目
1. **ストレージバケット**: `avatars` バケットが存在する
2. **ポリシー**: 4つのポリシーが設定されている
3. **データベース**: 新しいフィールドが追加されている
4. **アプリケーション**: 画像アップロードが正常に動作する

### エラーが発生した場合
- **Bucket not found**: バケットが作成されていない
- **Permission denied**: ポリシーが正しく設定されていない
- **Column not found**: データベースのフィールドが追加されていない

## 4. トラブルシューティング

### よくある問題と解決方法

#### 問題1: "Bucket not found" エラー
**原因**: `avatars` バケットが存在しない
**解決方法**: 上記の手順2を実行してバケットを作成

#### 問題2: "Permission denied" エラー
**原因**: ストレージポリシーが正しく設定されていない
**解決方法**: 上記の手順3を実行してポリシーを設定

#### 問題3: 画像が表示されない
**原因**: バケットがパブリックに設定されていない
**解決方法**: バケット設定で "Public bucket" を有効化

#### 問題4: ファイルサイズエラー
**原因**: 5MBを超えるファイルをアップロードしようとしている
**解決方法**: より小さいファイルサイズの画像を使用

## 5. セキュリティ考慮事項

- バケットはパブリックに設定されているため、アップロードされた画像は誰でもアクセス可能
- 必要に応じて、認証済みユーザーのみアクセス可能な設定に変更可能
- 定期的に不要な画像を削除してストレージ容量を管理 

## 修正内容

**問題**: `bookings`テーブルの主キーが`id`ではなく`booking_id`でした。

**解決**: 外部キー参照を正しく修正しました：
```sql
-- 修正前（エラー）
ALTER TABLE public.messages 
ADD COLUMN IF NOT EXISTS booking_id UUID REFERENCES public.bookings(id);

-- 修正後（正しい）
ALTER TABLE public.messages 
ADD COLUMN IF NOT EXISTS booking_id UUID REFERENCES public.bookings(booking_id);
```

## 実行してください

Supabaseで以下のSQLを実行してください：

```sql
-- booking_idカラムを追加（正しい主キー名を使用）
ALTER TABLE public.messages 
ADD COLUMN IF NOT EXISTS booking_id UUID REFERENCES public.bookings(booking_id);

-- booking_idのインデックスを作成（パフォーマンス向上）
CREATE INDEX IF NOT EXISTS idx_messages_booking_id ON public.messages(booking_id);
```

これで予定別チャット機能が正常に動作するはずです！ 