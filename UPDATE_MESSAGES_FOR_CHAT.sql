-- チャット機能用にメッセージテーブルを更新
-- Supabaseの SQL Editor で実行してください

-- 1. 既存のmessagesテーブルを削除
DROP TABLE IF EXISTS public.messages CASCADE;

-- 2. チャット機能用のmessagesテーブルを作成
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_type TEXT NOT NULL CHECK (sender_type IN ('golf_course', 'caddy')),
  sender_id TEXT NOT NULL, -- gid または cid
  receiver_type TEXT NOT NULL CHECK (receiver_type IN ('golf_course', 'caddy')),
  receiver_id TEXT NOT NULL, -- gid または cid
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 3. インデックスを作成
CREATE INDEX idx_messages_sender ON public.messages(sender_type, sender_id);
CREATE INDEX idx_messages_receiver ON public.messages(receiver_type, receiver_id);
CREATE INDEX idx_messages_created_at ON public.messages(created_at);
CREATE INDEX idx_messages_is_read ON public.messages(is_read);

-- 4. 1ヶ月で自動削除するための関数を作成
CREATE OR REPLACE FUNCTION delete_old_messages()
RETURNS void AS $$
BEGIN
  DELETE FROM public.messages 
  WHERE created_at < NOW() - INTERVAL '1 month';
END;
$$ LANGUAGE plpgsql;

-- 5. 自動削除のためのスケジュール設定（PostgreSQLのpg_cron拡張が必要）
-- 注意: Supabaseではpg_cronが利用できない場合があります
-- その場合は、アプリケーション側で定期的に削除処理を実行する必要があります

-- 6. RLSを有効化
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- 7. RLSポリシーを作成
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

-- 8. 確認用クエリ
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'messages' 
ORDER BY ordinal_position; 