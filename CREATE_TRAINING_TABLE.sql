-- 研修可能日管理テーブルの作成
-- Supabaseの SQL Editor で実行してください

-- UUID拡張を有効化（既に有効になっている場合はスキップされます）
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 研修可能日テーブルを作成
CREATE TABLE IF NOT EXISTS public.training_availability (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  gid TEXT NOT NULL,
  date DATE NOT NULL,
  max_slots INT DEFAULT 1 CHECK (max_slots > 0),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(gid, date)
);

-- Row Level Security (RLS) を有効化
ALTER TABLE public.training_availability ENABLE ROW LEVEL SECURITY;

-- ゴルフ場が自分のデータを管理できるポリシー
CREATE POLICY "Golf courses can manage their training availability" 
ON public.training_availability
FOR ALL USING (
  gid IN (
    SELECT golf_courses.gid 
    FROM public.golf_courses 
    WHERE golf_courses.email = auth.email()
  )
);

-- キャディが研修可能日を閲覧できるポリシー
CREATE POLICY "Caddies can view training availability" 
ON public.training_availability
FOR SELECT USING (true);

-- 確認用クエリ
SELECT 'training_availability table created successfully' as result; 