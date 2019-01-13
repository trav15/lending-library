class Item < ApplicationRecord
  has_many :loans, :dependent => :destroy
  has_many :users, through: :loans

  validates :name, presence: true

end
