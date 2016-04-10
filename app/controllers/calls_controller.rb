# == Schema Information
#
# Table name: calls
#
#  id                :integer          not null, primary key
#  uuid              :string
#  caller_id         :string
#  caller_name       :string
#  status            :string
#  company_number_id :integer
#  user_number_id    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  hangup_case       :string
#  start_time        :datetime
#  end_time          :datetime
#  answer_time       :datetime
#

class CallsController < ApplicationController
  before_action :set_app, only: :index
  before_action :set_call, only: :show

  def index
    @calls = @app.calls.order(:id)
  end

  def show
  end

  private

  def set_app
    @app = App.find params[:app_id]
  end

  def set_call
    @call = Call.find params[:id]
  end

end
