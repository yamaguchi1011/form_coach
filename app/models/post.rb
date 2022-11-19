class Post < ApplicationRecord
  mount_uploader :video, VideoUploader
  belongs_to :user

  validates :body, presence: true, length: { maximum: 280}
  validates :video, presence: true
  
end
