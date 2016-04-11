class InboundingCallsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_company_number, only: [:forward, :voicemail]
  before_action :set_call, only: [:voicemail, :hangup, :fallback, :save_record]

  def forward
    @call = Call.create(
                        uuid: params[:CallUUID],
                        caller_id: params[:From],
                        caller_name: params[:CallerName],
                        status: params[:CallStatus],
                        company_number: @company_number
                      )
    render xml: PlivoService.forward(params, @company_number.app.id)
  end

  def voicemail
    if params['CallStatus'] != 'completed'
      render xml: PlivoService.set_up_voicemail(@company_number.app.id)
    else
      render xml: PlivoService.hangup
    end
  end

  def save_record
    @voicemail = VoiceMail.create(url: params[:RecordFile], duration: params[:RecordingDuration], call_id: @call.id)
    render xml: PlivoService.hangup
  end

  def hangup
    @call.hangup_cause = params[:HangupCause]
    @call.status = params[:CallStatus]
    @call.start_time = params[:StartTime]
    @call.end_time = params[:EndTime]
    @call.answer_time = params[:AnswerTime]
    @call.duration = params[:Duration]

    plivo = PlivoService.new
    if responder_sip = plivo.find_responder(@call.uuid)
      responder = UserNumber.find_by_sip_endpoint responder_sip
      @call.user_number_id = responder.id
    end
    @call.save
    render nothing: true
  end

  def fallback
    @call.status = "error"
    @call.save
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
