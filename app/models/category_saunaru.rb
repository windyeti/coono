class CategorySaunaru < ApplicationRecord
  belongs_to :boss, class_name: 'CategorySaunaru', optional: true
  has_many :subordinates, class_name: 'CategorySaunaru', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
