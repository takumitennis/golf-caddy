-- ════════════════════════════════════════════════════════════════
-- Caddygate デモデータ seed (営業資料用スクリーンショット撮影向け)
-- 2026-06-04
-- ════════════════════════════════════════════════════════════════
--
-- 前提: MIGRATE_2026_06_03.sql を先に実行済みであること
--       (golf_courses に address / prefecture / city / homepage_url / gallery_urls が存在)
--
-- 使い方:
--   1. 営業デモ用のメアド (例: caddygate-demo@gmail.com) で
--      https://golf-caddy.pages.dev/login/?role=golf からメール+パスワードで新規登録
--   2. プロフィール画面で一旦保存して golf_courses 行を作る (gid が発行される)
--   3. この SQL を Supabase SQL Editor で開き、最初のセクションのメアドを上記に書き換えて Run
--   4. キャディ5名は擬似メアドで auth.users に直接 insert (Service Role なので RLS バイパス可)
--
-- ════════════════════════════════════════════════════════════════

-- 設定: ここを書き換える
DO $$
DECLARE
  demo_golf_email TEXT := 'caddygate-demo@gmail.com';  -- ← 営業デモ用ゴルフ場アカウント
  demo_gid TEXT;
  demo_caddy_emails TEXT[] := ARRAY[
    'demo-caddy-01@caddygate.test',
    'demo-caddy-02@caddygate.test',
    'demo-caddy-03@caddygate.test',
    'demo-caddy-04@caddygate.test',
    'demo-caddy-05@caddygate.test'
  ];
  demo_caddy_cids TEXT[] := ARRAY[
    'cdemo01', 'cdemo02', 'cdemo03', 'cdemo04', 'cdemo05'
  ];
  demo_caddy_names TEXT[] := ARRAY[
    '田中 健太', '佐藤 翔太', '鈴木 大樹', '高橋 直人', '渡辺 雄一'
  ];
  demo_caddy_unis TEXT[] := ARRAY[
    '九州大学', '福岡大学', '西南学院大学', '九州産業大学', '中村学園大学'
  ];
  demo_caddy_appeals TEXT[] := ARRAY[
    'ゴルフ部出身。プレーヤー経験を活かしたサポートが可能です。法人接待ラウンドも対応経験あり。',
    'キャディ経験3年。早朝・週末対応可能です。クラブ運びだけでなくグリーンの読みもお任せください。',
    '柔道部出身で体力に自信あり。雨天時の対応や急な代打も柔軟に対応します。',
    '英語対応可能。インバウンドゴルファーの接客経験あり。礼儀作法に自信があります。',
    'ゴルフ歴8年・キャディ歴2年。シニア層への対応が丁寧と評価いただいています。'
  ];
  i INT;
BEGIN
  -- ────────────────────────────────────────
  -- 1. ゴルフ場プロフィールを充実化 (既存 row を update)
  -- ────────────────────────────────────────
  SELECT gid INTO demo_gid FROM public.golf_courses WHERE email = demo_golf_email;
  IF demo_gid IS NULL THEN
    RAISE NOTICE 'ゴルフ場 % が見つかりません。先に Web からプロフィール登録してください。', demo_golf_email;
    RETURN;
  END IF;

  UPDATE public.golf_courses SET
    name                  = '糸島サンライズカントリークラブ',
    contact_name          = '山田 拓実',
    phone                 = '092-345-6789',
    prefecture            = '福岡県',
    city                  = '糸島市',
    address               = '志摩芥屋1234-5',
    homepage_url          = 'https://itoshima-sunrise-cc.example.jp',
    caddy_wage_per_round  = 12000,
    caddy_duration_hours  = 6,
    perks                 = 'キャディ昼食付き／打ちっぱなし1回無料／公共交通往復補助あり',
    description           = E'糸島半島の海を望む丘陵コース。\n1965 年開場、長く地元名門として愛されてきた 18 ホールのチャンピオンシップコースです。\n海風と松林がプレーに変化を与え、プレイヤーの実力が試される本格的なレイアウトです。\n法人接待・コンペ需要が高く、キャディ付きラウンドを継続提供しています。',
    partner_display       = true,
    image_url             = 'https://images.unsplash.com/photo-1587174486073-ae5e5cff23aa?w=1200&q=80',
    gallery_urls          = ARRAY[
      'https://images.unsplash.com/photo-1587174486073-ae5e5cff23aa?w=800&q=80',
      'https://images.unsplash.com/photo-1592919505780-303950717480?w=800&q=80',
      'https://images.unsplash.com/photo-1535131749006-b7f58c99034b?w=800&q=80',
      'https://images.unsplash.com/photo-1579781354995-91d80d31b54a?w=800&q=80'
    ]
  WHERE gid = demo_gid;

  RAISE NOTICE 'ゴルフ場 % (gid=%) を更新しました', demo_golf_email, demo_gid;

  -- ────────────────────────────────────────
  -- 2. デモキャディ 5 名を upsert (auth.users は touch せず caddies テーブルだけ)
  --    ※ ログイン不能の "shadow" キャディ。表示のみ用途。
  --    ※ booking_caddies の cid FK 制約満たすため caddies に必ず insert する
  -- ────────────────────────────────────────
  FOR i IN 1..5 LOOP
    INSERT INTO public.caddies (
      cid, email, name, phone, university, golf_years, caddy_years, appeal, rating,
      avatar_url
    ) VALUES (
      demo_caddy_cids[i],
      demo_caddy_emails[i],
      demo_caddy_names[i],
      '090-' || LPAD((1000 + i*123)::TEXT, 4, '0') || '-' || LPAD((5678 + i*45)::TEXT, 4, '0'),
      demo_caddy_unis[i],
      4 + i,
      1 + i,
      demo_caddy_appeals[i],
      4.5 + (i * 0.1),
      'https://i.pravatar.cc/200?img=' || (10 + i)::TEXT
    )
    ON CONFLICT (cid) DO UPDATE SET
      name = EXCLUDED.name,
      phone = EXCLUDED.phone,
      university = EXCLUDED.university,
      golf_years = EXCLUDED.golf_years,
      caddy_years = EXCLUDED.caddy_years,
      appeal = EXCLUDED.appeal,
      rating = EXCLUDED.rating,
      avatar_url = EXCLUDED.avatar_url;
  END LOOP;
  RAISE NOTICE 'デモキャディ 5 名 upsert しました';

  -- ────────────────────────────────────────
  -- 3. 既存デモ bookings をクリアして新規 seed
  -- ────────────────────────────────────────
  DELETE FROM public.booking_caddies
    WHERE booking_id IN (SELECT booking_id FROM public.bookings WHERE gid = demo_gid);
  DELETE FROM public.bookings WHERE gid = demo_gid;

  -- 過去 (実績) 3件 - confirmed/completed
  INSERT INTO public.bookings (gid, date, slots, status, start_time) VALUES
    (demo_gid, CURRENT_DATE - INTERVAL '14 days', 2, 'completed', '08:00'),
    (demo_gid, CURRENT_DATE - INTERVAL '7 days',  3, 'completed', '07:30'),
    (demo_gid, CURRENT_DATE - INTERVAL '3 days',  2, 'completed', '09:00');

  -- 直近未来 (確定) 2件
  INSERT INTO public.bookings (gid, date, slots, status, start_time) VALUES
    (demo_gid, CURRENT_DATE + INTERVAL '2 days', 2, 'confirmed', '08:00'),
    (demo_gid, CURRENT_DATE + INTERVAL '5 days', 3, 'confirmed', '07:30');

  -- 募集中 (pending) 5件 - キャディ枠が空いている状態
  INSERT INTO public.bookings (gid, date, slots, status, start_time) VALUES
    (demo_gid, CURRENT_DATE + INTERVAL '8 days',  2, 'pending', '08:00'),
    (demo_gid, CURRENT_DATE + INTERVAL '10 days', 3, 'pending', '07:30'),
    (demo_gid, CURRENT_DATE + INTERVAL '12 days', 2, 'pending', '09:00'),
    (demo_gid, CURRENT_DATE + INTERVAL '15 days', 4, 'pending', '08:30'),
    (demo_gid, CURRENT_DATE + INTERVAL '20 days', 2, 'pending', '07:00');

  -- ────────────────────────────────────────
  -- 4. booking_caddies (キャディの確定/応募) を seed
  -- ────────────────────────────────────────
  -- 過去 completed の予約には全枠 confirmed キャディ
  INSERT INTO public.booking_caddies (booking_id, cid, status)
    SELECT b.booking_id, demo_caddy_cids[1], 'completed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'completed' AND b.date = CURRENT_DATE - INTERVAL '14 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[2], 'completed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'completed' AND b.date = CURRENT_DATE - INTERVAL '14 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[1], 'completed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'completed' AND b.date = CURRENT_DATE - INTERVAL '7 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[3], 'completed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'completed' AND b.date = CURRENT_DATE - INTERVAL '7 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[4], 'completed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'completed' AND b.date = CURRENT_DATE - INTERVAL '7 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[2], 'completed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'completed' AND b.date = CURRENT_DATE - INTERVAL '3 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[5], 'completed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'completed' AND b.date = CURRENT_DATE - INTERVAL '3 days';

  -- 直近 confirmed には確定キャディ
  INSERT INTO public.booking_caddies (booking_id, cid, status)
    SELECT b.booking_id, demo_caddy_cids[1], 'confirmed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'confirmed' AND b.date = CURRENT_DATE + INTERVAL '2 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[3], 'confirmed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'confirmed' AND b.date = CURRENT_DATE + INTERVAL '2 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[2], 'confirmed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'confirmed' AND b.date = CURRENT_DATE + INTERVAL '5 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[4], 'confirmed'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'confirmed' AND b.date = CURRENT_DATE + INTERVAL '5 days';

  -- pending な予約には pending な応募者をいくつか
  INSERT INTO public.booking_caddies (booking_id, cid, status)
    SELECT b.booking_id, demo_caddy_cids[1], 'pending'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'pending' AND b.date = CURRENT_DATE + INTERVAL '8 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[2], 'pending'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'pending' AND b.date = CURRENT_DATE + INTERVAL '8 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[3], 'pending'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'pending' AND b.date = CURRENT_DATE + INTERVAL '10 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[4], 'pending'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'pending' AND b.date = CURRENT_DATE + INTERVAL '10 days'
    UNION ALL
    SELECT b.booking_id, demo_caddy_cids[5], 'pending'
      FROM public.bookings b WHERE b.gid = demo_gid AND b.status = 'pending' AND b.date = CURRENT_DATE + INTERVAL '12 days';

  RAISE NOTICE 'デモ予約 10件 + 関連キャディ確定/応募データ seed 完了';
END $$;

-- ────────────────────────────────────────
-- 確認用
-- ────────────────────────────────────────
SELECT 'golf_courses (demo)' AS section, gid, name, prefecture, city, address FROM public.golf_courses WHERE email = 'caddygate-demo@gmail.com';
SELECT 'bookings (demo)' AS section, booking_id, date, slots, status, start_time
  FROM public.bookings b
  WHERE gid IN (SELECT gid FROM public.golf_courses WHERE email = 'caddygate-demo@gmail.com')
  ORDER BY date;
SELECT 'caddies (demo)' AS section, cid, name, university, golf_years, caddy_years, rating FROM public.caddies WHERE cid LIKE 'cdemo%' ORDER BY cid;
