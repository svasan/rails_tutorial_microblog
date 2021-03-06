class User < ApplicationRecord

  has_many :microposts, dependent: :destroy

  has_many :following_relationships,
           class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :following_relationships, source: :followed

  has_many :followed_relationships,
           class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :followed_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token

  validates :name, :presence => true, :length => {:maximum => 255}

  VALID_EMAIL_REGEX = /\A[\w+\-]+(\.[\w+\-]+)*@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, :presence => true, :length => {:maximum => 255},
            :format => {:with => VALID_EMAIL_REGEX}, :uniqueness => {:case_sensitive => false}

  has_secure_password
  validates :password, :presence => true, :length => {:minimum => 8}

  before_save :downcase_email
  before_create :create_activation_token

  def User.digest(s)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(s, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    self.remember_token = nil
    update_attribute(:remember_digest,nil)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_token
    self.reset_token = User.new_token
    self.update_columns(reset_digest: User.digest(reset_token),
                        reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def reset_valid?
    reset_sent_at >= 2.hours.ago
  end

  def feed
    following_ids  = "select followed_id from relationships where follower_id = :user_id"
    Micropost.where("user_id in (#{following_ids}) or user_id = :user_id", user_id: id)
  end

  def follow(other)
    following << other
  end

  def following?(other)
    following.include?(other)
  end

  def unfollow(other)
    following.delete(other)
  end

  def follower?(other)
    followers.include?(other)
  end

  private
    def downcase_email
      email.downcase!
    end

    # Called via before_action
    def create_activation_token
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
