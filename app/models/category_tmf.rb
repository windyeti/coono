class CategoryTmf < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryTmf', optional: true
  has_many :subordinates, class_name: 'CategoryTmf', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
