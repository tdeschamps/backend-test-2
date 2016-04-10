class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :uuid
      t.string :caller_id
      t.string :caller_name
      t.string :status
      t.belongs_to :company_number, index: true, foreign_key: true
      t.belongs_to :user_number, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
