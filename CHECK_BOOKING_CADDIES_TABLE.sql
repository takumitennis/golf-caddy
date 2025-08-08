-- booking_caddiesテーブルの構造を確認

-- テーブル情報を確認
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'booking_caddies' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 主キー情報を確認
SELECT 
  tc.constraint_name,
  tc.table_name,
  kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY' 
  AND tc.table_name = 'booking_caddies'
  AND tc.table_schema = 'public';

-- 外部キー情報を確認
SELECT 
  tc.constraint_name,
  tc.table_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu 
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_name = 'booking_caddies'
  AND tc.table_schema = 'public';

-- サンプルデータを確認
SELECT * FROM public.booking_caddies LIMIT 3; 