-- キャディテーブルにプロフィール関連フィールドを追加
-- このスクリプトは既存のcaddiesテーブルに新しいフィールドを追加します

-- 新しいフィールドを追加
ALTER TABLE public.caddies 
ADD COLUMN IF NOT EXISTS avatar_url TEXT,
ADD COLUMN IF NOT EXISTS birth_date DATE,
ADD COLUMN IF NOT EXISTS university TEXT,
ADD COLUMN IF NOT EXISTS golf_years INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS caddy_years INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS appeal TEXT;

-- 既存のexperience_yearsフィールドがある場合は、caddy_yearsに移行（オプション）
-- UPDATE public.caddies SET caddy_years = experience_years WHERE experience_years IS NOT NULL;

-- アバター画像用のストレージバケットを作成（Supabaseダッシュボードで手動実行）
-- 1. Supabaseダッシュボードにアクセス
-- 2. Storage > New bucket
-- 3. Bucket name: "avatars"
-- 4. Public bucket: チェック
-- 5. File size limit: 5MB
-- 6. Allowed MIME types: image/*

-- ストレージポリシーを設定（Supabaseダッシュボードで手動実行）
-- 1. Storage > avatars > Policies
-- 2. "Enable RLS" を有効化
-- 3. 以下のポリシーを追加：

-- アバター画像のアップロードポリシー
-- CREATE POLICY "Users can upload their own avatar" ON storage.objects
-- FOR INSERT WITH CHECK (
--   bucket_id = 'avatars' AND 
--   auth.uid()::text = (storage.foldername(name))[1]
-- );

-- アバター画像の表示ポリシー
-- CREATE POLICY "Avatar images are publicly viewable" ON storage.objects
-- FOR SELECT USING (bucket_id = 'avatars');

-- アバター画像の更新ポリシー
-- CREATE POLICY "Users can update their own avatar" ON storage.objects
-- FOR UPDATE USING (
--   bucket_id = 'avatars' AND 
--   auth.uid()::text = (storage.foldername(name))[1]
-- );

-- アバター画像の削除ポリシー
-- CREATE POLICY "Users can delete their own avatar" ON storage.objects
-- FOR DELETE USING (
--   bucket_id = 'avatars' AND 
--   auth.uid()::text = (storage.foldername(name))[1]
-- );

-- 確認クエリ
SELECT 
  cid,
  name,
  email,
  avatar_url,
  birth_date,
  university,
  golf_years,
  caddy_years,
  appeal,
  created_at
FROM public.caddies 
LIMIT 5; 