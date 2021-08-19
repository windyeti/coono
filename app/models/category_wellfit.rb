class CategoryWellfit < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryWellfit', optional: true
  has_many :subordinates, class_name: 'CategoryWellfit', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
