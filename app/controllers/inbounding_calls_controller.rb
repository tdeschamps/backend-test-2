class InboundingCallsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_company_number, only: :forward
  before_action :set_call, only: [:voicemail, :hangup, :fallback]

  def forward
    @call = Call.create(
                        uuid: params[:CallUUID],
                        caller_id: params[:From],
                        caller_name: params[:CallerName],
                        status: params[:CallStatus],
                        company_number: @company_number
                      )
    if @call.errors.messages != {}
      Rails.logger.debug @call.errors.inspect
      raise
    end
    render xml: PlivoService.forward(params, @company_number.app.id)
  end

  def voicemail
    @voicemail = VoiceMail.create(url: params[:RecordFile], duration: params[:RecordingDuration], call: @call)

    if @voicemail.errors.messages != {}
      Rails.logger.debug @voice_mail.errors
      raise
    end

    render nothing: true
  end

  def hangup
    @call.hangup_cause = params[:HangupCause]
    @call.status = params[:CallStatus]
    @call.start_time = params[:StartTime]
    @call.end_time = params[:EndTime]
    @call.answer_time = params[:AnswerTime]
    @call.duration = params[:Duration]
    @call.save
    render nothing: true
  end

  def fallback
    @call.status = "error"
    @call.save

    if @call.errors.messages != {}
      Rails.logger.debug @call.errors
      raise
    end

    render nothing: true
  end


  private

  def set_company_number
    @company_number = CompanyNumber.includes(:app).find_by_sip_endpoint(params[:To])
  end

  def set_call
    @call = Call.find_by_uuid(params[:CallUUID])
  end

end
