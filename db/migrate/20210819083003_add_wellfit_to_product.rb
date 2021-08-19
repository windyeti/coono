class AddWellfitToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :wellfit, foreign_key: true
  end
end
