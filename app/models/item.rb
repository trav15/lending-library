class Item < ApplicationRecord
  has_many :loans, :dependent => :destroy
  has_many :users, through: :loans

  validates :name, presence: true


  def self.user_donations(user)
    where(donor_id: user.id)
  end

  def self.is_available
    where(available: true)
  end

  def self.is_borrowed
    where(available: false)
  end

end
