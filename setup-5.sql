-- =====================================================
-- Caddygate setup-5.sql （差分）
-- caddies テーブルに line_id カラムを追加
-- 2026-06-01 user 報告のエラー対応:
--   「Could not find the 'line_id' column of 'caddies' in the schema cache」
-- =====================================================
--
-- 実行手順: Supabase Dashboard → SQL Editor → New query → 全文ペースト → Run
-- データは保持されます（カラム追加のみ）
--

ALTER TABLE public.caddies
  ADD COLUMN IF NOT EXISTS line_id TEXT;

-- 確認: caddies テーブルの全カラム
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'caddies'
ORDER BY ordinal_position;
