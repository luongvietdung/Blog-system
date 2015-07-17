class User < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  has_many :comments
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: "followed"
  has_many :followeds, through: :passive_relationships, source: "follower"

  attr_accessor :remember_token
  before_save {:downcase_email}
  
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  has_secure_password 
  validates :password, presence: true, length: {minimum: 6}

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? Bcrypt::Engine::MIN_COST : BCrypt::Engine.cost
     BCrypt::Password.create(string, cost: cost)
  end
   # Returns a random token.

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def authenticated?(attribute, token)
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  def forget
    update_attribute(:remember_digest, nil)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  def feed
    following_ids = "SELECT followed_id FROM relationships
                   WHERE  follower_id = :user_id"
    Entry.where("user_id IN (#{following_ids})
                   OR user_id = :user_id", user_id: id)
  end
  private
    def downcase_email
    self.email = email.downcase 
  end
end
