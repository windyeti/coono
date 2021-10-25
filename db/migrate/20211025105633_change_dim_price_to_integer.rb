class ChangeDimPriceToInteger < ActiveRecord::Migration[5.0]
  def change
    change_column :dims, :price, 'integer USING CAST(price AS integer)'
  end
end
