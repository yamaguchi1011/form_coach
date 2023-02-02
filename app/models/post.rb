class Post < ApplicationRecord
  # attr_accessor :video_cache
  mount_uploader :video, VideoUploader
  belongs_to :user

  validates :body, presence: true, length: { maximum: 280}
  validates :video, presence: true
  validates :dominant_arm, presence: true
end
