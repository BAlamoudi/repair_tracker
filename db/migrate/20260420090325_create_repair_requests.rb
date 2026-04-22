class CreateRepairRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :repair_requests do |t|
      t.string :vehicle_details
      t.text :problem_description
      t.string :status
      t.decimal :price_quotation
      t.integer :customer_id
      t.integer :workshop_id

      t.timestamps
    end
  end
end
