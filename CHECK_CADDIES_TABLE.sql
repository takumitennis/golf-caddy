-- caddiesテーブルの構造を確認

-- テーブル情報を確認
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'caddies' 
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
  AND tc.table_name = 'caddies'
  AND tc.table_schema = 'public';

-- サンプルデータを確認
SELECT * FROM public.caddies LIMIT 3; 