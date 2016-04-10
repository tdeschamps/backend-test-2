class AddEndpointIdAndPassowrdToCompanyNumber < ActiveRecord::Migration
  def change
    add_column :company_numbers, :sip_endpoint_id, :string
    add_column :company_numbers, :password, :string
  end
end
