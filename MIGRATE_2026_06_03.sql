-- ════════════════════════════════════════════════════════════════
-- Caddygate マイグレーション 2026-06-03
-- 一括で Supabase SQL Editor に貼って Run してください
-- ════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────
-- 1. training_availability テーブル（既存 SQL 未実行のため）
-- ────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.training_availability (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  gid TEXT NOT NULL,
  date DATE NOT NULL,
  max_slots INT DEFAULT 1 CHECK (max_slots > 0),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(gid, date)
);

ALTER TABLE public.training_availability ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Golf courses can manage their training availability" ON public.training_availability;
CREATE POLICY "Golf courses can manage their training availability"
ON public.training_availability
FOR ALL USING (
  gid IN (
    SELECT golf_courses.gid
    FROM public.golf_courses
    WHERE golf_courses.email = auth.email()
  )
);

DROP POLICY IF EXISTS "Caddies can view training availability" ON public.training_availability;
CREATE POLICY "Caddies can view training availability"
ON public.training_availability
FOR SELECT USING (true);

-- ────────────────────────────────────────
-- 2. golf_courses に新カラム追加
--    - address: 住所全文 (既存コードは select しているが列が無く 'column does not exist' エラー)
--    - prefecture: 都道府県（キャディ側の絞り込み検索用）
--    - city: 市区町村
--    - homepage_url: ゴルフ場の公式 HP URL
--    - gallery_urls: 追加写真 (Supabase Storage の URL を text[] で保持)
-- ────────────────────────────────────────
ALTER TABLE public.golf_courses ADD COLUMN IF NOT EXISTS address      TEXT;
ALTER TABLE public.golf_courses ADD COLUMN IF NOT EXISTS prefecture   TEXT;
ALTER TABLE public.golf_courses ADD COLUMN IF NOT EXISTS city         TEXT;
ALTER TABLE public.golf_courses ADD COLUMN IF NOT EXISTS homepage_url TEXT;
ALTER TABLE public.golf_courses ADD COLUMN IF NOT EXISTS gallery_urls TEXT[];

-- 都道府県は絞り込み検索が高頻度になる想定なので index を貼る
CREATE INDEX IF NOT EXISTS idx_golf_courses_prefecture
  ON public.golf_courses(prefecture)
  WHERE prefecture IS NOT NULL;

-- ────────────────────────────────────────
-- 確認用
-- ────────────────────────────────────────
SELECT
  'training_availability' AS table_name,
  EXISTS (SELECT 1 FROM information_schema.tables
          WHERE table_schema='public' AND table_name='training_availability') AS exists
UNION ALL
SELECT 'golf_courses.address',
       EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema='public' AND table_name='golf_courses' AND column_name='address')
UNION ALL
SELECT 'golf_courses.prefecture',
       EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema='public' AND table_name='golf_courses' AND column_name='prefecture')
UNION ALL
SELECT 'golf_courses.city',
       EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema='public' AND table_name='golf_courses' AND column_name='city')
UNION ALL
SELECT 'golf_courses.homepage_url',
       EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema='public' AND table_name='golf_courses' AND column_name='homepage_url')
UNION ALL
SELECT 'golf_courses.gallery_urls',
       EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema='public' AND table_name='golf_courses' AND column_name='gallery_urls');
