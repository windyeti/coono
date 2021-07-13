class CategoryContact < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryContact', optional: true
  has_many :subordinates, class_name: 'CategoryContact', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
