class CreateAuditLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :audit_logs do |t|
      t.integer :repair_request_id
      t.integer :user_id
      t.string :action
      t.string :from_status
      t.string :to_status

      t.timestamps
    end
  end
end
