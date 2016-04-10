class AddAppUrlToApp < ActiveRecord::Migration
  def change
    add_column :apps, :app_url, :string
  end
end
