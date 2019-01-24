class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :available
  has_many :loans
  has_many :users, through: :loans
end
