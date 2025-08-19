-- golf_coursesテーブルにpartner_displayフィールドを追加
-- Supabaseの SQL Editor で実行してください

-- 1. partner_displayカラムを追加（デフォルトはfalse）
ALTER TABLE public.golf_courses 
ADD COLUMN IF NOT EXISTS partner_display BOOLEAN DEFAULT false;

-- 2. 既存データの確認
SELECT 
  gid, 
  name, 
  contact_name, 
  phone, 
  partner_display,
  created_at
FROM public.golf_courses 
ORDER BY created_at DESC
LIMIT 10;

-- 3. 既存データを全て非表示に設定（オプション）
-- UPDATE public.golf_courses 
-- SET partner_display = false 
-- WHERE partner_display IS NULL;

-- 4. 確認用クエリ
SELECT 
  column_name, 
  data_type, 
  is_nullable, 
  column_default
FROM information_schema.columns 
WHERE table_name = 'golf_courses' 
AND column_name = 'partner_display'
ORDER BY ordinal_position;
