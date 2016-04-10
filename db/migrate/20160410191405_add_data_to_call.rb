class AddDataToCall < ActiveRecord::Migration
  def change
    add_column :calls, :hangup_cause, :string
    add_column :calls, :start_time, :datetime
    add_column :calls, :end_time, :datetime
    add_column :calls, :answer_time, :datetime
    add_column :calls, :duration, :integer
  end
end
