class Item < ApplicationRecord
  has_many :lends, :dependent => :destroy
  has_many :users, through: :lends

  validates :name, presence: true

end
