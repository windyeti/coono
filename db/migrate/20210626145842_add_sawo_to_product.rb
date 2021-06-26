class AddSawoToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :sawo, foreign_key: true
  end
end
