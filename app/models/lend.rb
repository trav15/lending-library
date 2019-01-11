class Lend < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :lend_date, presence: true
end
