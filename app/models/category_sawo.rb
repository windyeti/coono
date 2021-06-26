class CategorySawo < ApplicationRecord
  belongs_to :boss, class_name: 'CategorySawo', optional: true
  has_many :subordinates, class_name: 'CategorySawo', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
