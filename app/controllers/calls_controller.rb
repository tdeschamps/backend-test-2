class CallsController < ApplicationController
  before_action :set_app, only: :index
  before_action :set_call, only: :show

  def index
    @calls = @app.calls.order_by(:id)
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
