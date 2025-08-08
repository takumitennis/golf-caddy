-- bookingsテーブルの主キーを確認

-- 主キー情報を確認
SELECT 
  tc.constraint_name,
  tc.table_name,
  kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY' 
  AND tc.table_name = 'bookings'
  AND tc.table_schema = 'public';

-- 全カラム一覧を確認
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'bookings' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- サンプルデータを確認（主キー候補を特定）
SELECT * FROM public.bookings LIMIT 3; 