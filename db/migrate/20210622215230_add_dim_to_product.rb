class AddDimToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :dim, foreign_key: true
  end
end
