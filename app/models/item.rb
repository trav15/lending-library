class Item < ApplicationRecord
  has_many :loans, :dependent => :destroy
  has_many :users, through: :loans

  validates :name, presence: true


  def self.user_donations(user)
    where(donor_id: user.id)
  end

end
