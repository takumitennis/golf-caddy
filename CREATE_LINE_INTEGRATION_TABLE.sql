-- LINE連携機能用のテーブル作成
-- Supabaseの SQL Editor で実行してください

-- 1. LINE連携情報テーブルを作成
CREATE TABLE IF NOT EXISTS public.line_integrations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cid TEXT NOT NULL REFERENCES public.caddies(cid) ON DELETE CASCADE,
  line_user_id TEXT UNIQUE NOT NULL, -- LINEユーザーID
  display_name TEXT, -- LINEの表示名
  picture_url TEXT, -- LINEのプロフィール画像URL
  status_message TEXT, -- LINEのステータスメッセージ
  is_active BOOLEAN DEFAULT TRUE, -- 連携が有効かどうか
  linked_at TIMESTAMP DEFAULT NOW(), -- 連携した日時
  last_notification_at TIMESTAMP, -- 最後に通知を送った日時
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. インデックスを作成
CREATE INDEX idx_line_integrations_cid ON public.line_integrations(cid);
CREATE INDEX idx_line_integrations_line_user_id ON public.line_integrations(line_user_id);
CREATE INDEX idx_line_integrations_active ON public.line_integrations(is_active);

-- 3. RLSを有効化
ALTER TABLE public.line_integrations ENABLE ROW LEVEL SECURITY;

-- 4. RLSポリシーを作成
-- キャディが自分のLINE連携情報のみアクセス可能
CREATE POLICY "Caddies can manage their own LINE integration" 
ON public.line_integrations
FOR ALL 
TO authenticated
USING (
  cid IN (
    SELECT caddies.cid 
    FROM public.caddies 
    WHERE caddies.email = auth.email()
  )
)
WITH CHECK (
  cid IN (
    SELECT caddies.cid 
    FROM public.caddies 
    WHERE caddies.email = auth.email()
  )
);

-- ゴルフ場が関連するキャディのLINE連携状況を確認可能（通知送信のため）
CREATE POLICY "Golf courses can view caddy LINE integration status" 
ON public.line_integrations
FOR SELECT 
TO authenticated
USING (
  EXISTS (
    SELECT 1 
    FROM public.golf_courses 
    WHERE golf_courses.email = auth.email()
  )
);

-- 5. 更新時刻の自動更新トリガー
CREATE OR REPLACE FUNCTION update_line_integrations_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_line_integrations_updated_at
  BEFORE UPDATE ON public.line_integrations
  FOR EACH ROW
  EXECUTE FUNCTION update_line_integrations_updated_at();

-- 6. 通知履歴テーブル（オプション）
CREATE TABLE IF NOT EXISTS public.line_notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  line_integration_id UUID NOT NULL REFERENCES public.line_integrations(id) ON DELETE CASCADE,
  message_type TEXT NOT NULL, -- 'booking_confirmed', 'booking_cancelled', 'reminder', etc.
  message_content TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT NOW(),
  status TEXT DEFAULT 'sent' -- 'sent', 'failed', 'pending'
);

CREATE INDEX idx_line_notifications_integration_id ON public.line_notifications(line_integration_id);
CREATE INDEX idx_line_notifications_sent_at ON public.line_notifications(sent_at);
