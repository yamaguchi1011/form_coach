class Effective < ApplicationRecord
  # ユーザーとコメントの組み合わせのレコードを作成し一意にするためにunique制約を追加した。
  belongs_to :user
  belongs_to :comment

  validates :user_id, uniqueness: { scope: :comment_id }
end
