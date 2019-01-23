class LoanSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :item_id, :used_for, :return_date
  belongs_to :item
  belongs_to :user
end
