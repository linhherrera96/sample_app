class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.number_maximum}
  validate :picture_size
  scope :posted_by, ->(user){where user_id: user.id}
  scope :swap, ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  scope :post_feed, ->(following_ids, id){where "user_id IN (?) OR user_id = ?", following_ids, id}

  private

  def picture_size
    errors.add :picture, t("model.micropost.picture_size") if picture.size > Settings.micropost.picture_size.megabytes
  end
end
