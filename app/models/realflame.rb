class Realflame < ApplicationRecord
  has_one :product

  scope :product_all_size, -> { order(:id).size }
end
