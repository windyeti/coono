class AddNkaminToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :nkamin, foreign_key: true
  end
end
