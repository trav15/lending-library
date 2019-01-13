class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :loan_date, presence: true


  def self.user_loans(user)
    where(user_id: user.id)
  end

  def self.current_user_loans(user)
    where(user_id: user.id).where(return_date: nil).all
  end

  def self.item_loans(item)
    where(item_id: item.id)
  end

  def self.current_loan
    where(return_date: nil)
  end

end
