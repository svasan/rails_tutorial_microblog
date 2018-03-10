class User < ApplicationRecord
  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-]+(\.[\w+\-]+)*@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, :presence => true, :length => {:maximum => 255}
  validates :email, :presence => true, :length => {:maximum => 255},
            :format => {:with => VALID_EMAIL_REGEX}, :uniqueness => {:case_sensitive => false}
  has_secure_password
  validates :password, :presence => true, :length => {:minimum => 8}
  attr_accessor :remember_token

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

end
