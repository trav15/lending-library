class Item < ApplicationRecord
  has_many :lends
  has_many :users, through: :lends

  validates :name, presence: true

end
