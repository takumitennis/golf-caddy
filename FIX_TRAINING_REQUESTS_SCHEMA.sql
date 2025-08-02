-- training_requestsテーブルのスキーマ修正
-- Supabaseの SQL Editor で実行してください

-- 1. 既存のtraining_requestsテーブルを削除（もし存在する場合）
DROP TABLE IF EXISTS public.training_requests CASCADE;

-- 2. training_requestsテーブルを正しいスキーマで再作成
CREATE TABLE public.training_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cid TEXT NOT NULL,
  gid TEXT NOT NULL,
  training_date DATE NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  -- 外部キー制約を明示的に定義
  CONSTRAINT fk_training_requests_caddy 
    FOREIGN KEY (cid) REFERENCES public.caddies(cid) ON DELETE CASCADE,
  CONSTRAINT fk_training_requests_golf_course 
    FOREIGN KEY (gid) REFERENCES public.golf_courses(gid) ON DELETE CASCADE,
  
  -- 複合ユニーク制約（同じキャディが同じゴルフ場の同じ日に複数のリクエストを送れないように）
  CONSTRAINT unique_training_request UNIQUE (cid, gid, training_date)
);

-- 3. インデックスを作成（パフォーマンス向上）
CREATE INDEX idx_training_requests_cid ON public.training_requests(cid);
CREATE INDEX idx_training_requests_gid ON public.training_requests(gid);
CREATE INDEX idx_training_requests_date ON public.training_requests(training_date);
CREATE INDEX idx_training_requests_status ON public.training_requests(status);

-- 4. RLSを有効化
ALTER TABLE public.training_requests ENABLE ROW LEVEL SECURITY;

-- 5. 既存のポリシーを削除（もしあれば）
DROP POLICY IF EXISTS "Caddies can create and view their training requests" ON public.training_requests;
DROP POLICY IF EXISTS "Golf courses can manage training requests for their courses" ON public.training_requests;
DROP POLICY IF EXISTS "Allow all authenticated users" ON public.training_requests;

-- 6. 新しいポリシーを作成
-- キャディが自分の研修リクエストを作成・閲覧できるポリシー
CREATE POLICY "Caddies can manage their training requests" 
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

-- 7. 確認用クエリ
SELECT 
  tc.table_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_name = 'training_requests';

-- 8. テーブル構造確認
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'training_requests' 
ORDER BY ordinal_position; 