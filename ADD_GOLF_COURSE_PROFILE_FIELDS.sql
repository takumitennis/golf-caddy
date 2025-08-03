-- ゴルフ場プロフィールに画像と説明フィールドを追加
-- Supabaseの SQL Editor で実行してください

-- 1. golf_coursesテーブルに新しいカラムを追加
ALTER TABLE public.golf_courses 
ADD COLUMN IF NOT EXISTS image_url TEXT,
ADD COLUMN IF NOT EXISTS description TEXT;

-- 2. Supabase Storageバケットを作成（もし存在しない場合）
-- 注意: これはSupabaseダッシュボードのStorageセクションで手動で作成する必要があります
-- バケット名: golf-course-images
-- パブリックアクセス: 有効

-- 3. StorageバケットのRLSポリシーを設定
-- 以下のポリシーをStorageセクションで設定してください：

-- 認証済みユーザーが画像をアップロードできるポリシー
-- CREATE POLICY "Authenticated users can upload golf course images"
-- ON storage.objects FOR INSERT
-- TO authenticated
-- WITH CHECK (bucket_id = 'golf-course-images');

-- 認証済みユーザーが画像を更新できるポリシー
-- CREATE POLICY "Authenticated users can update golf course images"
-- ON storage.objects FOR UPDATE
-- TO authenticated
-- USING (bucket_id = 'golf-course-images');

-- 誰でも画像を閲覧できるポリシー
-- CREATE POLICY "Anyone can view golf course images"
-- ON storage.objects FOR SELECT
-- TO public
-- USING (bucket_id = 'golf-course-images');

-- 4. 確認用クエリ
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'golf_courses' 
AND column_name IN ('image_url', 'description')
ORDER BY ordinal_position;

-- 5. 既存データの確認
SELECT gid, name, image_url, description 
FROM public.golf_courses 
LIMIT 5; 