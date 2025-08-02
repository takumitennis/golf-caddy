-- training_requestsテーブル用のRLSポリシー
-- Supabaseの SQL Editor で実行してください

-- training_requestsテーブルのRLSを有効化
ALTER TABLE public.training_requests ENABLE ROW LEVEL SECURITY;

-- 既存のポリシーを削除（もしあれば）
DROP POLICY IF EXISTS "Caddies can create training requests" ON public.training_requests;
DROP POLICY IF EXISTS "Golf courses can view training requests for their courses" ON public.training_requests;

-- キャディが研修リクエストを作成できるポリシー
CREATE POLICY "Caddies can create and view their training requests" 
ON public.training_requests
FOR ALL 
TO authenticated
USING (
  cid IN (
    SELECT caddies.cid 
    FROM public.caddies 
    WHERE caddies.email = auth.email()
  )
)
WITH CHECK (
  cid IN (
    SELECT caddies.cid 
    FROM public.caddies 
    WHERE caddies.email = auth.email()
  )
);

-- ゴルフ場が自分のコースへの研修リクエストを閲覧・管理できるポリシー
CREATE POLICY "Golf courses can manage training requests for their courses" 
ON public.training_requests
FOR ALL 
TO authenticated
USING (
  gid IN (
    SELECT golf_courses.gid 
    FROM public.golf_courses 
    WHERE golf_courses.email = auth.email()
  )
)
WITH CHECK (
  gid IN (
    SELECT golf_courses.gid 
    FROM public.golf_courses 
    WHERE golf_courses.email = auth.email()
  )
);

-- テスト用: より寛容なポリシー（問題が続く場合）
-- CREATE POLICY "Allow all authenticated users" 
-- ON public.training_requests
-- FOR ALL 
-- TO authenticated
-- USING (true)
-- WITH CHECK (true);

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
WHERE tablename = 'training_requests'; 