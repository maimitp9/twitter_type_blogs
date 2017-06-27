class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy

  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  # in this case using the :source parameter, which explicitly tells Rails that the
  # source of the followed_users array is the set of followed ids.
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: 'followed_id',
                                   class_name: 'Relationship',
                                   dependent: :destroy

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { maximum: 6 }
  validates :password_confirmation, presence: true, length: { maximum: 6 }

  #select all microfeed which are associate with this user id
  def feed
    Micropost.from_users_followed_by(self)
  end

  # Generate new remember token when user signup
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # Encrypt new remember token using SHA1
  def User.digest(token)
    Digest::SHA1::hexdigest(token.to_s)
  end

  # to check other user is already follow or other user id already exist into relationships table
  def following?(other_user)
      relationships.find_by(followed_id: other_user.id)
  end

  # create entry into relationships table for follow
  def follow!(other_user)
      relationships.create!(followed_id: other_user.id)
  end

  # delete other user id from relationships table (unfollow)
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

    #create new remember_token
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
