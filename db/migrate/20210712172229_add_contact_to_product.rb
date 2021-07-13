class AddContactToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :contact, foreign_key: true
  end
end
