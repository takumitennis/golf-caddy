-- メッセージ機能用のテーブル作成
-- Supabaseの SQL Editor で実行してください

-- 1. messagesテーブルを作成
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_type TEXT NOT NULL CHECK (sender_type IN ('golf_course', 'caddy')),
  sender_id TEXT NOT NULL, -- gid または cid
  receiver_type TEXT NOT NULL CHECK (receiver_type IN ('golf_course', 'caddy')),
  receiver_id TEXT NOT NULL, -- gid または cid
  subject TEXT NOT NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. インデックスを作成
CREATE INDEX idx_messages_sender ON public.messages(sender_type, sender_id);
CREATE INDEX idx_messages_receiver ON public.messages(receiver_type, receiver_id);
CREATE INDEX idx_messages_created_at ON public.messages(created_at);
CREATE INDEX idx_messages_is_read ON public.messages(is_read);

-- 3. RLSを有効化
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- 4. RLSポリシーを作成
-- ゴルフ場が自分のメッセージを送受信できるポリシー
CREATE POLICY "Golf courses can manage their messages" 
ON public.messages
FOR ALL 
TO authenticated
USING (
  (sender_type = 'golf_course' AND sender_id IN (
    SELECT golf_courses.gid 
    FROM public.golf_courses 
    WHERE golf_courses.email = auth.email()
  )) OR
  (receiver_type = 'golf_course' AND receiver_id IN (
    SELECT golf_courses.gid 
    FROM public.golf_courses 
    WHERE golf_courses.email = auth.email()
  ))
)
WITH CHECK (
  (sender_type = 'golf_course' AND sender_id IN (
    SELECT golf_courses.gid 
    FROM public.golf_courses 
    WHERE golf_courses.email = auth.email()
  )) OR
  (receiver_type = 'golf_course' AND receiver_id IN (
    SELECT golf_courses.gid 
    FROM public.golf_courses 
    WHERE golf_courses.email = auth.email()
  ))
);

-- キャディが自分のメッセージを送受信できるポリシー
CREATE POLICY "Caddies can manage their messages" 
ON public.messages
FOR ALL 
TO authenticated
USING (
  (sender_type = 'caddy' AND sender_id IN (
    SELECT caddies.cid 
    FROM public.caddies 
    WHERE caddies.email = auth.email()
  )) OR
  (receiver_type = 'caddy' AND receiver_id IN (
    SELECT caddies.cid 
    FROM public.caddies 
    WHERE caddies.email = auth.email()
  ))
)
WITH CHECK (
  (sender_type = 'caddy' AND sender_id IN (
    SELECT caddies.cid 
    FROM public.caddies 
    WHERE caddies.email = auth.email()
  )) OR
  (receiver_type = 'caddy' AND receiver_id IN (
    SELECT caddies.cid 
    FROM public.caddies 
    WHERE caddies.email = auth.email()
  ))
);

-- 5. 確認用クエリ
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'messages' 
ORDER BY ordinal_position; 