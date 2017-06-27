class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> {order('created_at DESC')}
  validates :content, presence: true, length: { maximum: 160 }
  validates :user_id, presence: true

  def self.from_users_followed_by(user)
    #user is id of current user and user.followed_user_idsreturn array of followed user by current user
    #followed_user_ids = user.followed_user_ids --> same as bellow
    followed_user_ids = 'SELECT followed_id from relationships where follower_id = :user_id'
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user)
  end

end
