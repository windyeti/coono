class CategoryTeplodar < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryTeplodar', optional: true
  has_many :subordinates, class_name: 'CategoryTeplodar', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
