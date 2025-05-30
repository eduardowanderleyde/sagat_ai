class CreateAuditLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.references :auditable, null: false, polymorphic: true
      t.jsonb :data

      t.timestamps
    end
  end
end
