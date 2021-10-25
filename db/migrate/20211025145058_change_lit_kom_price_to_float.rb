class ChangeLitKomPriceToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :lit_koms, :price, 'double precision USING CAST(price AS double precision)'
  end
end
