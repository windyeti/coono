class CategoryShulepov < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryShulepov', optional: true
  has_many :subordinates, class_name: 'CategoryShulepov', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
