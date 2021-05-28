class CategoryLitKom < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryLitKom', optional: true
  has_many :subordinates, class_name: 'CategoryLitKom', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
