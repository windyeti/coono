class AddLitKomToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :lit_kom, foreign_key: true
  end
end
