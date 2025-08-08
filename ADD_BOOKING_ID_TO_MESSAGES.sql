-- messagesテーブルにbooking_idカラムを追加
-- 予定別のメッセージ管理を可能にする

-- booking_idカラムを追加（正しい主キー名を使用）
ALTER TABLE public.messages 
ADD COLUMN IF NOT EXISTS booking_id UUID REFERENCES public.bookings(booking_id);

-- 既存のメッセージのbooking_idを設定（オプション）
-- この部分は既存データがある場合のみ実行
-- UPDATE public.messages 
-- SET booking_id = (
--   SELECT b.booking_id 
--   FROM public.bookings b 
--   WHERE b.gid = messages.receiver_id 
--   LIMIT 1
-- ) 
-- WHERE booking_id IS NULL AND receiver_type = 'golf_course';

-- booking_idのインデックスを作成（パフォーマンス向上）
CREATE INDEX IF NOT EXISTS idx_messages_booking_id ON public.messages(booking_id);

-- 確認クエリ
SELECT 
  id,
  sender_type,
  sender_id,
  receiver_type,
  receiver_id,
  booking_id,
  content,
  is_read,
  created_at
FROM public.messages 
LIMIT 5; 