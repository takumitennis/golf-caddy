-- 追加のRLSポリシー（エラーが続く場合に実行）
-- Supabaseの SQL Editor で実行してください

-- 既存のポリシーを削除（もしあれば）
DROP POLICY IF EXISTS "Golf courses can manage their training availability" ON public.training_availability;
DROP POLICY IF EXISTS "Caddies can view training availability" ON public.training_availability;

-- より寛容なポリシーを作成（テスト用）
CREATE POLICY "Allow all operations for authenticated users" 
ON public.training_availability
FOR ALL 
TO authenticated
USING (true)
WITH CHECK (true);

-- または、RLSを一時的に無効化してテスト
-- ALTER TABLE public.training_availability DISABLE ROW LEVEL SECURITY;

-- 確認用クエリ
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'training_availability'; 