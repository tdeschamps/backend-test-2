class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.string :app_id
      t.string :api_id

      t.timestamps null: false
    end
  end
end
