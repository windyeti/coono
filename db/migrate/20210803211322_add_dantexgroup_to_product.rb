class AddDantexgroupToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :dantexgroup, foreign_key: true
  end
end
