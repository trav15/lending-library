class Item < ApplicationRecord
  has_many :lends
  has_many :users, through :lends
end
