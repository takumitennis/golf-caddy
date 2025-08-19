-- golf_coursesテーブルに住所フィールドを追加
-- Supabaseの SQL Editor で実行してください

-- 1. prefecture（都道府県）カラムを追加
ALTER TABLE public.golf_courses 
ADD COLUMN IF NOT EXISTS prefecture TEXT;

-- 2. city（市区町村）カラムを追加
ALTER TABLE public.golf_courses 
ADD COLUMN IF NOT EXISTS city TEXT;

-- 3. 既存データの確認
SELECT 
  gid, 
  name, 
  prefecture,
  city,
  contact_name, 
  phone, 
  partner_display,
  created_at
FROM public.golf_courses 
ORDER BY created_at DESC
LIMIT 10;

-- 4. 確認用クエリ
SELECT 
  column_name, 
  data_type, 
  is_nullable, 
  column_default
FROM information_schema.columns 
WHERE table_name = 'golf_courses' 
AND column_name IN ('prefecture', 'city')
ORDER BY ordinal_position;
