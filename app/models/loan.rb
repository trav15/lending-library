class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :loan_date, presence: true
end
