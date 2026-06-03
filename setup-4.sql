-- =====================================================
-- Caddygate setup-4.sql （差分）
-- Storage bucket 2つ作成 + RLS ポリシー設定
-- 2026-06-01 プロフ画像アップロード失敗対応
-- =====================================================
--
-- 実行手順: Supabase Dashboard → SQL Editor → New query → 全文ペースト → Run
--

-- ① bucket 作成（public read）
INSERT INTO storage.buckets (id, name, public)
VALUES
  ('golf-course-images', 'golf-course-images', true),
  ('caddy-avatars',      'caddy-avatars',      true)
ON CONFLICT (id) DO UPDATE SET public = EXCLUDED.public;

-- ② storage.objects に対する RLS ポリシー
--   既存ポリシー削除（重複防止）
DROP POLICY IF EXISTS "Authenticated can upload golf-course-images" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can view golf-course-images"          ON storage.objects;
DROP POLICY IF EXISTS "Authenticated can update golf-course-images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated can delete golf-course-images" ON storage.objects;

DROP POLICY IF EXISTS "Authenticated can upload caddy-avatars" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can view caddy-avatars"          ON storage.objects;
DROP POLICY IF EXISTS "Authenticated can update caddy-avatars" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated can delete caddy-avatars" ON storage.objects;

-- golf-course-images: 認証済みは upload/update/delete、誰でも view
CREATE POLICY "Authenticated can upload golf-course-images" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'golf-course-images');

CREATE POLICY "Anyone can view golf-course-images" ON storage.objects
  FOR SELECT TO public
  USING (bucket_id = 'golf-course-images');

CREATE POLICY "Authenticated can update golf-course-images" ON storage.objects
  FOR UPDATE TO authenticated
  USING (bucket_id = 'golf-course-images');

CREATE POLICY "Authenticated can delete golf-course-images" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'golf-course-images');

-- caddy-avatars: 同じパターン
CREATE POLICY "Authenticated can upload caddy-avatars" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'caddy-avatars');

CREATE POLICY "Anyone can view caddy-avatars" ON storage.objects
  FOR SELECT TO public
  USING (bucket_id = 'caddy-avatars');

CREATE POLICY "Authenticated can update caddy-avatars" ON storage.objects
  FOR UPDATE TO authenticated
  USING (bucket_id = 'caddy-avatars');

CREATE POLICY "Authenticated can delete caddy-avatars" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'caddy-avatars');

-- ③ DB側のカラム確認（既に存在するはず、念のため idempotent に追加）
ALTER TABLE public.golf_courses
  ADD COLUMN IF NOT EXISTS image_url TEXT;

ALTER TABLE public.caddies
  ADD COLUMN IF NOT EXISTS avatar_url TEXT;

-- 確認
SELECT id, name, public FROM storage.buckets WHERE id IN ('golf-course-images', 'caddy-avatars');
