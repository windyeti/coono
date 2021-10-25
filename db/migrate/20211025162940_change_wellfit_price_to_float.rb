class ChangeWellfitPriceToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :wellfits, :price, 'double precision USING CAST(price AS double precision)'
  end
end
