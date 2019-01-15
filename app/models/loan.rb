class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :loan_date, presence: true

  scope :user_loans, -> (user) {where(user_id: user.id)}
  scope :current_user_loans, -> (user) {where(user_id: user.id).where(return_date: nil).all}
  scope :item_loans, -> (item) {where(item_id: item.id)}
  scope :current_loan, -> {where(return_date: nil)}

end
