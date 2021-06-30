class AddSaunaruToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :saunaru, foreign_key: true
  end
end
