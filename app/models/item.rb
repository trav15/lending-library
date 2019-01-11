class Item < ApplicationRecord
  has_many :lends
  has_many :users, through: :lends

  before_save :default_values
  validates :name, presence: true

  private
  def default_values
    self.available |= true
  end
end
