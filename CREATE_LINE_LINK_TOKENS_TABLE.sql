-- LINE連携用トークン管理テーブル
-- Supabaseの SQL Editor で実行してください

-- 1. line_link_tokensテーブルを作成
CREATE TABLE IF NOT EXISTS public.line_link_tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cid TEXT NOT NULL REFERENCES public.caddies(cid) ON DELETE CASCADE,
  token TEXT UNIQUE NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  used_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 2. インデックスを作成
CREATE INDEX idx_line_link_tokens_token ON public.line_link_tokens(token);
CREATE INDEX idx_line_link_tokens_cid ON public.line_link_tokens(cid);
CREATE INDEX idx_line_link_tokens_expires ON public.line_link_tokens(expires_at);

-- 3. RLSを有効化
ALTER TABLE public.line_link_tokens ENABLE ROW LEVEL SECURITY;

-- 4. RLSポリシーを作成
-- キャディが自分のトークンのみアクセス可能
CREATE POLICY "Caddies can manage their own link tokens" 
ON public.line_link_tokens
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

-- 5. 期限切れトークンの自動削除関数
CREATE OR REPLACE FUNCTION cleanup_expired_tokens()
RETURNS void AS $$
BEGIN
  DELETE FROM public.line_link_tokens 
  WHERE expires_at < NOW() - INTERVAL '1 day';
END;
$$ LANGUAGE plpgsql;

-- 6. 自動クリーンアップのスケジュール（pg_cronが利用可能な場合）
-- SELECT cron.schedule('cleanup-expired-tokens', '0 2 * * *', 'SELECT cleanup_expired_tokens();');

-- 7. トリガー関数（トークン使用時にline_integrationsテーブルを更新）
CREATE OR REPLACE FUNCTION update_line_integration_on_token_use()
RETURNS TRIGGER AS $$
BEGIN
  -- トークンが使用済みになった時の処理
  IF OLD.used_at IS NULL AND NEW.used_at IS NOT NULL THEN
    -- line_integrationsテーブルの最終更新時刻を更新
    UPDATE public.line_integrations 
    SET updated_at = NOW()
    WHERE cid = NEW.cid;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 8. トリガーを作成
DROP TRIGGER IF EXISTS trigger_update_line_integration_on_token_use ON public.line_link_tokens;
CREATE TRIGGER trigger_update_line_integration_on_token_use
  AFTER UPDATE ON public.line_link_tokens
  FOR EACH ROW
  EXECUTE FUNCTION update_line_integration_on_token_use();
