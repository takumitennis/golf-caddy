-- ============================================================
-- Caddygate Phase 1 拡張スキーマ
-- ============================================================
-- 旧 golf-caddy プロジェクトの既存スキーマ（bookings, caddies,
-- golf_courses, messages, caddy_availability, training_availability,
-- line_integration, line_link_tokens）を流用した上で、
-- Caddygate Phase 1 の新事業設計に必要な拡張を行う。
--
-- 実行順序：
--   1. 新 Supabase プロジェクト作成
--   2. 旧 CREATE_*.sql / ADD_*.sql / UPDATE_*.sql を順次実行
--   3. 本ファイルを最後に実行
--
-- 前提モデル：
--   - 事業類型: γ 募集情報等提供事業
--   - 料金: ファウンダーズプラン（先着100社・基本料&掲載料永久無料）
--          + 通常プラン（月額¥3,000 + 掲載¥1,000）
--          + 予約手数料 ¥2,500/件
--   - 決済: 月末請求方式（Phase 1）→ Stripe Connect 移行（Phase 2 検討）
--   - 中抜き防止: アプリ内予約成立ボタン + 12ヶ月縛り + 違約金
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ------------------------------------------------------------
-- 1. golf_courses 拡張：ファウンダーズプラン管理
-- ------------------------------------------------------------

ALTER TABLE public.golf_courses
  ADD COLUMN IF NOT EXISTS plan_type TEXT NOT NULL DEFAULT 'standard'
    CHECK (plan_type IN ('founders', 'standard')),
  ADD COLUMN IF NOT EXISTS founders_no INTEGER UNIQUE,
  ADD COLUMN IF NOT EXISTS contracted_at TIMESTAMP DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS billing_email TEXT;

COMMENT ON COLUMN public.golf_courses.plan_type IS 'founders=ファウンダーズプラン(先着100社), standard=通常プラン';
COMMENT ON COLUMN public.golf_courses.founders_no IS 'ファウンダーズプランの連番（1-100）';

-- ファウンダーズ枠の自動採番関数
CREATE OR REPLACE FUNCTION public.assign_founders_no()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.plan_type = 'founders' AND NEW.founders_no IS NULL THEN
    SELECT COALESCE(MAX(founders_no), 0) + 1
      INTO NEW.founders_no
      FROM public.golf_courses
      WHERE plan_type = 'founders';

    IF NEW.founders_no > 100 THEN
      RAISE EXCEPTION 'ファウンダーズプラン枠（100社）は満枠です';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_assign_founders_no ON public.golf_courses;
CREATE TRIGGER trigger_assign_founders_no
  BEFORE INSERT OR UPDATE ON public.golf_courses
  FOR EACH ROW
  EXECUTE FUNCTION public.assign_founders_no();

-- ------------------------------------------------------------
-- 2. bookings 拡張：予約成立確認 + 予約手数料
-- ------------------------------------------------------------

ALTER TABLE public.bookings
  ADD COLUMN IF NOT EXISTS platform_fee INTEGER NOT NULL DEFAULT 2500,
  ADD COLUMN IF NOT EXISTS confirmed_by_golf BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS confirmed_by_caddy BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS confirmed_at TIMESTAMP,
  ADD COLUMN IF NOT EXISTS cancelled_at TIMESTAMP,
  ADD COLUMN IF NOT EXISTS billing_year_month TEXT;

COMMENT ON COLUMN public.bookings.platform_fee IS '予約システム手数料（円）。Phase 1 は固定 2500';
COMMENT ON COLUMN public.bookings.confirmed_by_golf IS 'ゴルフ場側が「予約成立」ボタンを押した';
COMMENT ON COLUMN public.bookings.confirmed_by_caddy IS 'キャディ側が「予約成立」ボタンを押した';
COMMENT ON COLUMN public.bookings.billing_year_month IS '請求対象年月 (YYYY-MM)。月末締めバッチで自動セット';

-- 両方確認されたら confirmed_at を自動セット
CREATE OR REPLACE FUNCTION public.set_booking_confirmed_at()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.confirmed_by_golf = TRUE
     AND NEW.confirmed_by_caddy = TRUE
     AND OLD.confirmed_at IS NULL THEN
    NEW.confirmed_at := NOW();
    NEW.billing_year_month := TO_CHAR(NOW(), 'YYYY-MM');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_set_booking_confirmed_at ON public.bookings;
CREATE TRIGGER trigger_set_booking_confirmed_at
  BEFORE UPDATE ON public.bookings
  FOR EACH ROW
  EXECUTE FUNCTION public.set_booking_confirmed_at();

-- ------------------------------------------------------------
-- 3. monthly_invoices: 月末請求書管理
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.monthly_invoices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  gid TEXT NOT NULL REFERENCES public.golf_courses(gid) ON DELETE CASCADE,
  year_month TEXT NOT NULL,  -- 'YYYY-MM' 形式
  total_bookings INTEGER NOT NULL DEFAULT 0,
  monthly_fee INTEGER NOT NULL DEFAULT 0,       -- 基本料金（ファウンダーズなら 0）
  listing_fee INTEGER NOT NULL DEFAULT 0,        -- 掲載料（ファウンダーズなら 0）
  booking_fee_total INTEGER NOT NULL DEFAULT 0,  -- 予約手数料合計
  total_amount INTEGER NOT NULL DEFAULT 0,       -- 請求総額
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'sent', 'paid', 'overdue', 'cancelled')),
  sent_at TIMESTAMP,
  due_date DATE,
  paid_at TIMESTAMP,
  pdf_url TEXT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(gid, year_month)
);

CREATE INDEX IF NOT EXISTS idx_invoices_gid ON public.monthly_invoices(gid);
CREATE INDEX IF NOT EXISTS idx_invoices_year_month ON public.monthly_invoices(year_month);
CREATE INDEX IF NOT EXISTS idx_invoices_status ON public.monthly_invoices(status);

ALTER TABLE public.monthly_invoices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Golf courses can view their own invoices"
  ON public.monthly_invoices
  FOR SELECT
  TO authenticated
  USING (
    gid IN (
      SELECT gc.gid FROM public.golf_courses gc
      WHERE gc.email = auth.email()
    )
  );

-- ------------------------------------------------------------
-- 4. キャディランク制（Phase 1.5 で使用、テーブルだけ先に作る）
-- ------------------------------------------------------------

ALTER TABLE public.caddies
  ADD COLUMN IF NOT EXISTS rank TEXT NOT NULL DEFAULT 'bronze'
    CHECK (rank IN ('bronze', 'silver', 'gold')),
  ADD COLUMN IF NOT EXISTS total_rounds INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS referral_points INTEGER NOT NULL DEFAULT 0;

COMMENT ON COLUMN public.caddies.rank IS 'キャディランク（bronze=新人, silver=実績あり, gold=ベテラン）';
COMMENT ON COLUMN public.caddies.total_rounds IS '累計確定ラウンド数';
COMMENT ON COLUMN public.caddies.referral_points IS '中抜き通報・優良行動でのポイント。金銭換算不可（2025/4新規制準拠）。優先表示等の特典に使用';

-- ------------------------------------------------------------
-- 5. 中抜き検知ログ（違反通報の記録）
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.direct_contact_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  golf_course_gid TEXT NOT NULL REFERENCES public.golf_courses(gid),
  caddy_cid TEXT NOT NULL REFERENCES public.caddies(cid),
  reported_by TEXT NOT NULL CHECK (reported_by IN ('caddy', 'golf_course', 'admin')),
  reporter_id TEXT,  -- 通報者の cid または gid
  contact_date DATE,
  evidence_url TEXT,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'investigating', 'confirmed', 'dismissed', 'penalty_issued')),
  penalty_amount INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  resolved_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_direct_contact_gid ON public.direct_contact_reports(golf_course_gid);
CREATE INDEX IF NOT EXISTS idx_direct_contact_cid ON public.direct_contact_reports(caddy_cid);
CREATE INDEX IF NOT EXISTS idx_direct_contact_status ON public.direct_contact_reports(status);

ALTER TABLE public.direct_contact_reports ENABLE ROW LEVEL SECURITY;

-- ------------------------------------------------------------
-- 6. 評価レビュー（ランク制と連動）
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL,  -- bookings.id を参照
  reviewer_type TEXT NOT NULL CHECK (reviewer_type IN ('golf_course', 'caddy')),
  reviewer_id TEXT NOT NULL,
  reviewee_type TEXT NOT NULL CHECK (reviewee_type IN ('golf_course', 'caddy')),
  reviewee_id TEXT NOT NULL,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  is_public BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reviews_booking ON public.reviews(booking_id);
CREATE INDEX IF NOT EXISTS idx_reviews_reviewee ON public.reviews(reviewee_type, reviewee_id);

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Reviews visible to involved parties"
  ON public.reviews
  FOR SELECT
  TO authenticated
  USING (
    is_public = TRUE
    OR reviewer_id IN (
      SELECT gid FROM public.golf_courses WHERE email = auth.email()
      UNION
      SELECT cid FROM public.caddies WHERE email = auth.email()
    )
    OR reviewee_id IN (
      SELECT gid FROM public.golf_courses WHERE email = auth.email()
      UNION
      SELECT cid FROM public.caddies WHERE email = auth.email()
    )
  );

-- ------------------------------------------------------------
-- 7. ファウンダーズ枠カウンタ用ビュー（営業トーク・LP用）
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW public.founders_status AS
SELECT
  COUNT(*) FILTER (WHERE plan_type = 'founders') AS founders_used,
  100 - COUNT(*) FILTER (WHERE plan_type = 'founders') AS founders_remaining,
  CASE
    WHEN COUNT(*) FILTER (WHERE plan_type = 'founders') >= 100 THEN TRUE
    ELSE FALSE
  END AS is_full
FROM public.golf_courses;

GRANT SELECT ON public.founders_status TO anon, authenticated;

-- ------------------------------------------------------------
-- 8. 確認用クエリ
-- ------------------------------------------------------------

SELECT 'Caddygate Phase 1 拡張スキーマの適用完了' AS result;

SELECT
  'golf_courses' AS table_name,
  COUNT(*) AS row_count
FROM public.golf_courses
UNION ALL SELECT 'caddies', COUNT(*) FROM public.caddies
UNION ALL SELECT 'bookings', COUNT(*) FROM public.bookings
UNION ALL SELECT 'monthly_invoices', COUNT(*) FROM public.monthly_invoices
UNION ALL SELECT 'direct_contact_reports', COUNT(*) FROM public.direct_contact_reports
UNION ALL SELECT 'reviews', COUNT(*) FROM public.reviews;

SELECT * FROM public.founders_status;
