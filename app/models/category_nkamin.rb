class CategoryNkamin < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryNkamin', optional: true
  has_many :subordinates, class_name: 'CategoryNkamin', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
