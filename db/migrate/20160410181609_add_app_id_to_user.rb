class AddAppIdToUser < ActiveRecord::Migration
  def change
    add_reference :users, :app, index: true, foreign_key: true
  end
end
