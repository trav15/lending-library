class User < ApplicationRecord
  has_secure_password

  has_many :loans
  has_many :items, through: :loans

  validates :username, presence: true, uniqueness: {case_sensitive: :false}

  def self.find_or_create_by_omniauth(auth)
    oauth_username = auth["info"]["nickname"] || auth["info"]["name"]
    self.where(:username => oauth_username).first_or_create do |user|
      user.password = SecureRandom.hex
    end
  end
end
