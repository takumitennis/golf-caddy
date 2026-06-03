-- =====================================================
-- Caddygate setup.sql
-- 新規 Supabase プロジェクト初期化用 統合スキーマ
-- 生成: 2026-06-01
--
-- 使い方:
--   1. Supabase Dashboard → SQL Editor → New query
--   2. このファイル全文をコピペ
--   3. Run（▶︎ ボタン）
--
-- 構成:
--   §1  Extensions
--   §2  Core tables（caddies / golf_courses / bookings / booking_caddies）
--   §3  Auxiliary tables（caddy_availability / messages / training_requests / line_*）
--   §4  Indexes
--   §5  Row Level Security
--   §6  Storage buckets（手動作成手順のコメント）
-- =====================================================


-- §1 ────────────────────────────────────────────────
--    Extensions
-- ─────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS pgcrypto;        -- gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";     -- 念のため uuid_generate_v4()


-- §2 ────────────────────────────────────────────────
--    Core tables（HTML/JS から逆算したコア DDL）
-- ─────────────────────────────────────────────────

-- caddies
CREATE TABLE IF NOT EXISTS public.caddies (
  cid              TEXT        PRIMARY KEY,
  email            TEXT        UNIQUE NOT NULL,
  name             TEXT,
  avatar_url       TEXT,
  birth_date       DATE,
  phone            TEXT,
  university       TEXT,
  golf_years       INTEGER     DEFAULT 0,
  caddy_years      INTEGER     DEFAULT 0,
  appeal           TEXT,
  rating           NUMERIC(3,2),
  rate             NUMERIC(10,2),
  trained_courses  TEXT,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- golf_courses
CREATE TABLE IF NOT EXISTS public.golf_courses (
  gid              TEXT        PRIMARY KEY,
  email            TEXT        UNIQUE NOT NULL,
  name             TEXT,
  contact_name     TEXT,
  phone            TEXT,
  prefecture       TEXT,
  city             TEXT,
  perks            TEXT,
  partner_display  BOOLEAN     DEFAULT false,
  image_url        TEXT,
  description      TEXT,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- bookings
CREATE TABLE IF NOT EXISTS public.bookings (
  booking_id  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  gid         TEXT        REFERENCES public.golf_courses(gid) ON DELETE CASCADE,
  date        DATE        NOT NULL,
  slots       INTEGER     NOT NULL,
  status      TEXT        DEFAULT 'open',
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- booking_caddies (M:N 中間テーブル)
CREATE TABLE IF NOT EXISTS public.booking_caddies (
  booking_id  UUID        REFERENCES public.bookings(booking_id) ON DELETE CASCADE,
  cid         TEXT        REFERENCES public.caddies(cid)        ON DELETE CASCADE,
  status      TEXT        DEFAULT 'pending',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (booking_id, cid)
);


-- §3 ────────────────────────────────────────────────
--    Auxiliary tables（リポジトリ既存 SQL を統合）
-- ─────────────────────────────────────────────────

-- caddy_availability (CREATE_CADDY_AVAILABILITY_TABLE.sql)
CREATE TABLE IF NOT EXISTS public.caddy_availability (
  cid         TEXT        REFERENCES public.caddies(cid) ON DELETE CASCADE,
  date        DATE        NOT NULL,
  available   BOOLEAN     DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (cid, date)
);

-- messages (CREATE_MESSAGES_TABLE.sql + ADD_BOOKING_ID_TO_MESSAGES.sql + UPDATE_MESSAGES_FOR_CHAT.sql 統合)
CREATE TABLE IF NOT EXISTS public.messages (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_type    TEXT        NOT NULL CHECK (sender_type IN ('caddy', 'golf_course', 'system')),
  sender_id      TEXT        NOT NULL,
  receiver_type  TEXT        NOT NULL CHECK (receiver_type IN ('caddy', 'golf_course', 'system')),
  receiver_id    TEXT        NOT NULL,
  booking_id     UUID        REFERENCES public.bookings(booking_id) ON DELETE SET NULL,
  content        TEXT        NOT NULL,
  is_read        BOOLEAN     DEFAULT false,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

-- training_requests (FIX_TRAINING_REQUESTS_SCHEMA.sql)
CREATE TABLE IF NOT EXISTS public.training_requests (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  cid         TEXT        REFERENCES public.caddies(cid)      ON DELETE CASCADE,
  gid         TEXT        REFERENCES public.golf_courses(gid) ON DELETE CASCADE,
  date        DATE,
  status      TEXT        DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'completed')),
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- line_link_tokens (CREATE_LINE_LINK_TOKENS_TABLE.sql)
CREATE TABLE IF NOT EXISTS public.line_link_tokens (
  token       TEXT        PRIMARY KEY,
  user_id     UUID        REFERENCES auth.users(id) ON DELETE CASCADE,
  user_type   TEXT        CHECK (user_type IN ('caddy', 'golf_course')),
  expires_at  TIMESTAMPTZ NOT NULL,
  used_at     TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- line_integration (CREATE_LINE_INTEGRATION_TABLE.sql)
CREATE TABLE IF NOT EXISTS public.line_integration (
  user_id       UUID        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  line_user_id  TEXT        UNIQUE,
  linked_at     TIMESTAMPTZ DEFAULT NOW()
);


-- §4 ────────────────────────────────────────────────
--    Indexes（クエリパフォーマンス）
-- ─────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_bookings_gid              ON public.bookings(gid);
CREATE INDEX IF NOT EXISTS idx_bookings_date             ON public.bookings(date);
CREATE INDEX IF NOT EXISTS idx_booking_caddies_cid       ON public.booking_caddies(cid);
CREATE INDEX IF NOT EXISTS idx_messages_booking_id       ON public.messages(booking_id);
CREATE INDEX IF NOT EXISTS idx_messages_receiver         ON public.messages(receiver_type, receiver_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at       ON public.messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_caddy_availability_date   ON public.caddy_availability(date);
CREATE INDEX IF NOT EXISTS idx_training_requests_cid     ON public.training_requests(cid);
CREATE INDEX IF NOT EXISTS idx_training_requests_gid     ON public.training_requests(gid);
CREATE INDEX IF NOT EXISTS idx_line_link_tokens_expires  ON public.line_link_tokens(expires_at);


-- §5 ────────────────────────────────────────────────
--    Row Level Security
--    ベースライン: 「認証済みは全件閲覧可、自分のレコードだけ書き込み可」
-- ─────────────────────────────────────────────────

ALTER TABLE public.caddies            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.golf_courses       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.booking_caddies    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.caddy_availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.training_requests  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.line_link_tokens   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.line_integration   ENABLE ROW LEVEL SECURITY;

-- caddies
DROP POLICY IF EXISTS "caddies_select" ON public.caddies;
DROP POLICY IF EXISTS "caddies_insert_own" ON public.caddies;
DROP POLICY IF EXISTS "caddies_update_own" ON public.caddies;
CREATE POLICY "caddies_select"     ON public.caddies FOR SELECT TO authenticated USING (true);
CREATE POLICY "caddies_insert_own" ON public.caddies FOR INSERT TO authenticated WITH CHECK (email = auth.email());
CREATE POLICY "caddies_update_own" ON public.caddies FOR UPDATE TO authenticated USING (email = auth.email());

-- golf_courses
DROP POLICY IF EXISTS "golf_courses_select" ON public.golf_courses;
DROP POLICY IF EXISTS "golf_courses_insert_own" ON public.golf_courses;
DROP POLICY IF EXISTS "golf_courses_update_own" ON public.golf_courses;
CREATE POLICY "golf_courses_select"     ON public.golf_courses FOR SELECT TO authenticated USING (true);
CREATE POLICY "golf_courses_insert_own" ON public.golf_courses FOR INSERT TO authenticated WITH CHECK (email = auth.email());
CREATE POLICY "golf_courses_update_own" ON public.golf_courses FOR UPDATE TO authenticated USING (email = auth.email());

-- bookings (ゴルフ場が自分の gid で作成・更新、全員閲覧)
DROP POLICY IF EXISTS "bookings_select" ON public.bookings;
DROP POLICY IF EXISTS "bookings_insert_by_golf" ON public.bookings;
DROP POLICY IF EXISTS "bookings_update_by_golf" ON public.bookings;
CREATE POLICY "bookings_select"         ON public.bookings FOR SELECT TO authenticated USING (true);
CREATE POLICY "bookings_insert_by_golf" ON public.bookings FOR INSERT TO authenticated
  WITH CHECK (gid IN (SELECT gid FROM public.golf_courses WHERE email = auth.email()));
CREATE POLICY "bookings_update_by_golf" ON public.bookings FOR UPDATE TO authenticated
  USING (gid IN (SELECT gid FROM public.golf_courses WHERE email = auth.email()));

-- booking_caddies (認証済みは全操作可。簡易設定、本番では細分化推奨)
DROP POLICY IF EXISTS "booking_caddies_all_auth" ON public.booking_caddies;
CREATE POLICY "booking_caddies_all_auth" ON public.booking_caddies FOR ALL TO authenticated
  USING (true) WITH CHECK (true);

-- caddy_availability (キャディが自分のシフトを管理、全員閲覧)
DROP POLICY IF EXISTS "caddy_availability_select" ON public.caddy_availability;
DROP POLICY IF EXISTS "caddy_availability_write_self" ON public.caddy_availability;
CREATE POLICY "caddy_availability_select"     ON public.caddy_availability FOR SELECT TO authenticated USING (true);
CREATE POLICY "caddy_availability_write_self" ON public.caddy_availability FOR ALL TO authenticated
  USING (cid IN (SELECT cid FROM public.caddies WHERE email = auth.email()))
  WITH CHECK (cid IN (SELECT cid FROM public.caddies WHERE email = auth.email()));

-- messages (認証済みは全操作可。本番では送受信者制限推奨)
DROP POLICY IF EXISTS "messages_all_auth" ON public.messages;
CREATE POLICY "messages_all_auth" ON public.messages FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- training_requests (認証済みは全操作可)
DROP POLICY IF EXISTS "training_requests_all_auth" ON public.training_requests;
CREATE POLICY "training_requests_all_auth" ON public.training_requests FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- line_link_tokens (本人のみ)
DROP POLICY IF EXISTS "line_link_tokens_self" ON public.line_link_tokens;
CREATE POLICY "line_link_tokens_self" ON public.line_link_tokens FOR ALL TO authenticated
  USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- line_integration (本人のみ)
DROP POLICY IF EXISTS "line_integration_self" ON public.line_integration;
CREATE POLICY "line_integration_self" ON public.line_integration FOR ALL TO authenticated
  USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());


-- §6 ────────────────────────────────────────────────
--    Storage buckets（SQL Editor からは作成不可。手動）
-- ─────────────────────────────────────────────────
--
--  Supabase Dashboard → Storage → New bucket で 2 つ作成:
--
--  1) avatars
--     - Public bucket: ON
--     - File size limit: 5 MB
--     - Allowed MIME types: image/*
--
--  2) golf-course-images
--     - Public bucket: ON
--     - File size limit: 10 MB
--     - Allowed MIME types: image/*
--
--  バケット作成後、Storage → 各バケット → Policies で
--  「Allow authenticated users to upload」「Allow public read」
--  のテンプレートを 2 つずつ追加すれば動作します。
--
-- =====================================================
-- END OF setup.sql
-- =====================================================
