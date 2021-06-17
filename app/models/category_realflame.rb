class CategoryRealflame < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryRealflame', optional: true
  has_many :subordinates, class_name: 'CategoryRealflame', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
