class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # ユーザーが消えてもeffectiveは消えてほしくないのでdependent: :destroyは指定しない。（アドバイザーからすると、コメントに対するいいね数が重要だから）
  has_many :effectives, dependent: :destroy
  # @user.effective_commentsのような形でいいねしているcommentのCollectionを取得できる。
  has_many :effective_comments, through: :effectives, source: :comment

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :name, presence: true, length: { maximum: 255}
   def own?(object)
    id == object.user_id
   end

   def own_post?(object)
    id == object.user_id
   end

  #  自分のcommentかどうかを判定するメソッドを定義
   def effective(comment)
    effective_comments << comment
    
  end

  def uneffective(comment)
    effective_comments.destroy(comment)
  end
  
  def effective?(comment)
    effective_comments.include?(comment)
  end
end
