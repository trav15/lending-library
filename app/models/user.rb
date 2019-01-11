class User < ApplicationRecord
  has_secure_password

  has_many :lends
  has_many :items, through: :lends

  validates :username, presence: true, uniqueness: {case_sensitive: :false}
end
