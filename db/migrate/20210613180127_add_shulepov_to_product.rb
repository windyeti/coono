class AddShulepovToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :shulepov, foreign_key: true
  end
end
