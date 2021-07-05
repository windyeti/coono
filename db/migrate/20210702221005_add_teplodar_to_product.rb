class AddTeplodarToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :teplodar, foreign_key: true
  end
end
