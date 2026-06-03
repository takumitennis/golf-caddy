-- =====================================================
-- Caddygate setup-6.sql （差分）
-- bookings テーブルに start_time カラムを追加
-- キャディ側「出勤予定」の開始時間表示に使用
-- 2026-06-01 caddy_dashboard 修正 1 に対応
-- =====================================================
--
-- 実行手順: Supabase Dashboard → SQL Editor → New query → 全文ペースト → Run
-- データは保持されます（カラム追加のみ）
--

ALTER TABLE public.bookings
  ADD COLUMN IF NOT EXISTS start_time TIME;

-- 確認: bookings テーブルの全カラム
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'bookings'
ORDER BY ordinal_position;
