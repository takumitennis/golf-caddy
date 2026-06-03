-- =====================================================
-- Caddygate setup-2.sql （差分）
-- ゴルフ場プロフィールに「キャディ条件」項目を追加
-- 2026-06-01 user 要件追加
-- =====================================================
--
-- 実行手順: Supabase Dashboard → SQL Editor → New query → 全文ペースト → Run
--

ALTER TABLE public.golf_courses
  ADD COLUMN IF NOT EXISTS caddy_wage_per_round INTEGER,
  ADD COLUMN IF NOT EXISTS caddy_duration_hours NUMERIC(4,2);

-- 確認
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'golf_courses'
  AND column_name IN ('caddy_wage_per_round', 'caddy_duration_hours');
