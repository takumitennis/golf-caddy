-- キャディの空き日管理テーブルの作成
-- Supabaseの SQL Editor で実行してください

-- UUID拡張を有効化（既に有効になっている場合はスキップされます）
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- キャディの空き日テーブルを作成
CREATE TABLE IF NOT EXISTS public.caddy_availability (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cid TEXT NOT NULL,
  date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(cid, date)
);

-- Row Level Security (RLS) を有効化
ALTER TABLE public.caddy_availability ENABLE ROW LEVEL SECURITY;

-- キャディが自分の空き日を管理できるポリシー
CREATE POLICY "Caddies can manage their own availability" 
ON public.caddy_availability
FOR ALL USING (
  cid IN (
    SELECT caddies.cid 
    FROM public.caddies 
    WHERE caddies.email = auth.email()
  )
);

-- ゴルフ場がキャディの空き日を閲覧できるポリシー
CREATE POLICY "Golf courses can view caddy availability" 
ON public.caddy_availability
FOR SELECT USING (true);

-- インデックスを作成（パフォーマンス向上）
CREATE INDEX idx_caddy_availability_cid ON public.caddy_availability(cid);
CREATE INDEX idx_caddy_availability_date ON public.caddy_availability(date);
CREATE INDEX idx_caddy_availability_cid_date ON public.caddy_availability(cid, date);

-- 確認用クエリ
SELECT 'caddy_availability table created successfully' as result;
