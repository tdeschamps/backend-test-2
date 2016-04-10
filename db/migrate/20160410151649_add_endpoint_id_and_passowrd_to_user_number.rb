class AddEndpointIdAndPassowrdToUserNumber < ActiveRecord::Migration
  def change
    add_column :user_numbers, :sip_endpoint_id, :string
    add_column :user_numbers, :password, :string
  end
end
