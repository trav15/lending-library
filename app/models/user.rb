class User < ApplicationRecord
  has_secure_password

  has_many :lends
  has_many :items, through: :lends
end
