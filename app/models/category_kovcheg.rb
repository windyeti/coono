class CategoryKovcheg < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryKovcheg', optional: true
  has_many :subordinates, class_name: 'CategoryKovcheg', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
