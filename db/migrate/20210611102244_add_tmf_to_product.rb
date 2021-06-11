class AddTmfToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :tmf, foreign_key: true
  end
end
