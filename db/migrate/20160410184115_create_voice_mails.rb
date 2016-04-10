class CreateVoiceMails < ActiveRecord::Migration
  def change
    create_table :voice_mails do |t|
      t.string :url
      t.integer :duration
      t.belongs_to :call, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
