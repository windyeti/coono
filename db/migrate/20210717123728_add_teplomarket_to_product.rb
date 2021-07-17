class AddTeplomarketToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :teplomarket, foreign_key: true
  end
end
