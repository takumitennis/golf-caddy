-- =====================================================
-- Caddygate setup-3.sql （差分）
-- training_requests テーブルの training_date カラム整備
-- 2026-06-01 user 報告のエラー対応:
--   「column training_requests.training_date does not exist」
-- =====================================================
--
-- 実行手順: Supabase Dashboard → SQL Editor → New query → 全文ペースト → Run
-- データは保持されます。
--

DO $$
BEGIN
  -- Case 1: 旧スキーマで 'date' カラムがある場合は rename
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'training_requests'
      AND column_name = 'date'
  ) THEN
    ALTER TABLE public.training_requests RENAME COLUMN date TO training_date;
  END IF;

  -- Case 2: training_date カラムがまだ無ければ追加
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'training_requests'
      AND column_name = 'training_date'
  ) THEN
    ALTER TABLE public.training_requests ADD COLUMN training_date DATE;
  END IF;
END $$;

-- status の CHECK 制約も新仕様（pending / confirmed / completed / cancelled）に合わせる
ALTER TABLE public.training_requests
  DROP CONSTRAINT IF EXISTS training_requests_status_check;

ALTER TABLE public.training_requests
  ADD CONSTRAINT training_requests_status_check
  CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled'));

-- 確認: 全カラム一覧
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'training_requests'
ORDER BY ordinal_position;
