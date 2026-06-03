-- =====================================================
-- Caddygate setup-7.sql （差分）
-- 予約・応募・キャンセル の RLS ポリシーを一括整備
-- 2026-06-02 user 報告のエラー対応:
--   「new row violates row-level security policy for table "bookings"」
-- =====================================================
--
-- 実行手順: Supabase Dashboard → SQL Editor → New query → 全文ペースト → Run
-- データは保持されます（ポリシー再作成のみ）
--

-- ============================
-- 1. golf_courses
-- ============================
ALTER TABLE public.golf_courses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "golf_courses_select"     ON public.golf_courses;
DROP POLICY IF EXISTS "golf_courses_insert_own" ON public.golf_courses;
DROP POLICY IF EXISTS "golf_courses_update_own" ON public.golf_courses;

CREATE POLICY "golf_courses_select"     ON public.golf_courses
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "golf_courses_insert_own" ON public.golf_courses
  FOR INSERT TO authenticated
  WITH CHECK (email = auth.email());

CREATE POLICY "golf_courses_update_own" ON public.golf_courses
  FOR UPDATE TO authenticated
  USING (email = auth.email());

-- ============================
-- 2. caddies
-- ============================
ALTER TABLE public.caddies ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "caddies_select"     ON public.caddies;
DROP POLICY IF EXISTS "caddies_insert_own" ON public.caddies;
DROP POLICY IF EXISTS "caddies_update_own" ON public.caddies;

CREATE POLICY "caddies_select"     ON public.caddies
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "caddies_insert_own" ON public.caddies
  FOR INSERT TO authenticated
  WITH CHECK (email = auth.email());

CREATE POLICY "caddies_update_own" ON public.caddies
  FOR UPDATE TO authenticated
  USING (email = auth.email());

-- ============================
-- 3. bookings
-- ============================
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "bookings_select"          ON public.bookings;
DROP POLICY IF EXISTS "bookings_insert_by_golf"  ON public.bookings;
DROP POLICY IF EXISTS "bookings_update_by_golf"  ON public.bookings;
DROP POLICY IF EXISTS "bookings_delete_by_golf"  ON public.bookings;

CREATE POLICY "bookings_select" ON public.bookings
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "bookings_insert_by_golf" ON public.bookings
  FOR INSERT TO authenticated
  WITH CHECK (
    gid IN (SELECT gid FROM public.golf_courses WHERE email = auth.email())
  );

CREATE POLICY "bookings_update_by_golf" ON public.bookings
  FOR UPDATE TO authenticated
  USING (
    gid IN (SELECT gid FROM public.golf_courses WHERE email = auth.email())
  );

CREATE POLICY "bookings_delete_by_golf" ON public.bookings
  FOR DELETE TO authenticated
  USING (
    gid IN (SELECT gid FROM public.golf_courses WHERE email = auth.email())
  );

-- ============================
-- 4. booking_caddies（キャディ応募 + ゴルフ場確定）
-- ============================
ALTER TABLE public.booking_caddies ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "booking_caddies_all_auth" ON public.booking_caddies;
DROP POLICY IF EXISTS "booking_caddies_select"   ON public.booking_caddies;
DROP POLICY IF EXISTS "booking_caddies_insert"   ON public.booking_caddies;
DROP POLICY IF EXISTS "booking_caddies_update"   ON public.booking_caddies;
DROP POLICY IF EXISTS "booking_caddies_delete"   ON public.booking_caddies;

-- SELECT: 認証済みなら全行閲覧可（双方向のマッチング画面のため）
CREATE POLICY "booking_caddies_select" ON public.booking_caddies
  FOR SELECT TO authenticated USING (true);

-- INSERT: キャディが自分の cid で応募する場合 OR ゴルフ場が自分の booking に対して INSERT する場合
CREATE POLICY "booking_caddies_insert" ON public.booking_caddies
  FOR INSERT TO authenticated
  WITH CHECK (
    cid IN (SELECT cid FROM public.caddies WHERE email = auth.email())
    OR
    booking_id IN (
      SELECT booking_id FROM public.bookings
      WHERE gid IN (SELECT gid FROM public.golf_courses WHERE email = auth.email())
    )
  );

-- UPDATE: 自分の応募行 OR 自分のゴルフ場の booking の関連行
CREATE POLICY "booking_caddies_update" ON public.booking_caddies
  FOR UPDATE TO authenticated
  USING (
    cid IN (SELECT cid FROM public.caddies WHERE email = auth.email())
    OR
    booking_id IN (
      SELECT booking_id FROM public.bookings
      WHERE gid IN (SELECT gid FROM public.golf_courses WHERE email = auth.email())
    )
  );

-- DELETE: 同様
CREATE POLICY "booking_caddies_delete" ON public.booking_caddies
  FOR DELETE TO authenticated
  USING (
    cid IN (SELECT cid FROM public.caddies WHERE email = auth.email())
    OR
    booking_id IN (
      SELECT booking_id FROM public.bookings
      WHERE gid IN (SELECT gid FROM public.golf_courses WHERE email = auth.email())
    )
  );

-- ============================
-- 5. caddy_availability（キャディの空き日登録）
-- ============================
ALTER TABLE public.caddy_availability ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "caddy_availability_select" ON public.caddy_availability;
DROP POLICY IF EXISTS "caddy_availability_insert" ON public.caddy_availability;
DROP POLICY IF EXISTS "caddy_availability_update" ON public.caddy_availability;
DROP POLICY IF EXISTS "caddy_availability_delete" ON public.caddy_availability;

CREATE POLICY "caddy_availability_select" ON public.caddy_availability
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "caddy_availability_insert" ON public.caddy_availability
  FOR INSERT TO authenticated
  WITH CHECK (
    cid IN (SELECT cid FROM public.caddies WHERE email = auth.email())
  );

CREATE POLICY "caddy_availability_update" ON public.caddy_availability
  FOR UPDATE TO authenticated
  USING (
    cid IN (SELECT cid FROM public.caddies WHERE email = auth.email())
  );

CREATE POLICY "caddy_availability_delete" ON public.caddy_availability
  FOR DELETE TO authenticated
  USING (
    cid IN (SELECT cid FROM public.caddies WHERE email = auth.email())
  );

-- ============================
-- 確認: 適用されたポリシー一覧
-- ============================
SELECT schemaname, tablename, policyname, cmd
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename IN ('golf_courses','caddies','bookings','booking_caddies','caddy_availability')
ORDER BY tablename, cmd;
