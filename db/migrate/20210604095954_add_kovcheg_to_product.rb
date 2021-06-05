class AddKovchegToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :kovcheg, foreign_key: true
  end
end
