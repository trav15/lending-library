class LoanSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :item_id, :used_for, :loan_date
  belongs_to :item
  belongs_to :user
end
