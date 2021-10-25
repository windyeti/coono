class ChangeContactPriceToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :contacts, :price, 'double precision USING CAST(price AS double precision)'
  end
end
