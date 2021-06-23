class CategoryDim < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryDim', optional: true
  has_many :subordinates, class_name: 'CategoryDim', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
