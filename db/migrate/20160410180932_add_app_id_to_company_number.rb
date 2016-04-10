class AddAppIdToCompanyNumber < ActiveRecord::Migration
  def change
    add_reference :company_numbers, :app, index: true, foreign_key: true
  end
end
