class Post < ApplicationRecord
  mount_uploader :video, VideoUploader
  belongs_to :user
  has_many :comments, dependent: :destroy 
  validates :body, presence: true, length: { maximum: 280}
  validates :video, presence: true
  validates :dominant_arm, presence: true
  validates :pitching_form, presence:true
  enum pitching_form: { over: 0, three_quarters: 1, side: 2, under: 3}
  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "dominant_arm", "pitching_form", "updated_at",]
  end
  def self.ransackable_associations(auth_object = nil)
    ["comments", "user","dominant_arm","created_at","pitching_form"]
  end

end
