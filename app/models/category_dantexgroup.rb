class CategoryDantexgroup < ApplicationRecord
  belongs_to :boss, class_name: 'CategoryDantexgroup', optional: true
  has_many :subordinates, class_name: 'CategoryDantexgroup', foreign_key: 'boss_id'

  validates :name, :link, :category_path, presence: true
end
