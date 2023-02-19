class Post < ApplicationRecord
  # attr_accessor :video_cache
  mount_uploader :video, VideoUploader
  belongs_to :user
  has_many :comments, dependent: :destroy 
  validates :body, presence: true, length: { maximum: 280}
  validates :video, presence: true
  validates :dominant_arm, presence: true
  validates :pitching_form, presence:true
  enum pitching_form: { over: 0, three_quarters: 1, side: 2, under: 3}
end
