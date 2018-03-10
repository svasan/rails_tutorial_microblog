class User < ApplicationRecord
  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-]+(\.[\w+\-]+)*@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, :presence => true, :length => {:maximum => 255}
  validates :email, :presence => true, :length => {:maximum => 255},
            :format => {:with => VALID_EMAIL_REGEX}, :uniqueness => {:case_sensitive => false}
  has_secure_password
  validates :password, :presence => true, :length => {:minimum => 8}

  def User.digest(s)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(s, cost: cost)
  end
end
