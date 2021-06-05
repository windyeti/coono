class CreateCategoryKovchegs < ActiveRecord::Migration[5.0]
  def change
    create_table :category_kovchegs do |t|
      t.references :boss, index: true
      t.string :name
      t.string :link
      t.string :category_path
      t.boolean :parsing, default: false
      t.timestamps
    end
  end
end
