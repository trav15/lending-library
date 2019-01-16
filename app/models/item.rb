class Item < ApplicationRecord
  has_many :loans, :dependent => :destroy
  has_many :users, through: :loans

  validates :name, presence: true

  scope :is_available, -> {where(available: true)}
  scope :is_borrowed, -> {where(available: false)}


  def self.user_donations(user)
    where(donor_id: user.id)
  end

  def self.by_popularity
    self.all.sort_by {|item| item.loans.length}
  end

end
