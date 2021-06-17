class AddRealflameToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :realflame, foreign_key: true
  end
end
