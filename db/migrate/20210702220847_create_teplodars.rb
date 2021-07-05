class CreateTeplodars < ActiveRecord::Migration[5.0]
  def change
    create_table :teplodars do |t|
      t.string :fid
      t.string :link
      t.string :sku
      t.string :title
      t.string :sdesc
      t.string :desc
      t.string :oldprice
      t.string :price
      t.string :pict
      t.string :quantity
      t.string :cat
      t.string :cat1
      t.string :cat2
      t.string :cat3
      t.string :cat4
      t.string :mtitle
      t.string :mdesc
      t.string :mkeyw
      t.string :p1
      t.string :p2
      t.string :p3
      t.string :p4
      t.string :option1
      t.string :option2
      t.string :option3
      t.string :option4
      t.string :option5
      t.string :option6
      t.string :option7
      t.string :option8
      t.string :option9
      t.string :option10
      t.string :option11
      t.string :option12
      t.string :option13
      t.string :option14
      t.boolean :check, default: true
      t.timestamps
    end
  end
end
