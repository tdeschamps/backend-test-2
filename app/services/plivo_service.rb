class PlivoService
  include Plivo

  def initialize
    @AUTH_ID = ENV.fetch 'PLIVO_ID'
    @AUTH_TOKEN = ENV.fetch 'PLIVO_AUTH_TOKEN'
    @plivo = RestAPI.new(@AUTH_ID, @AUTH_TOKEN)
  end

  def create_sip_endpoint(name, password, app_id)
    params = {
      'username' => name,
      'password' => password,
      'alias' => name,
      'app_id': app_id
    }
    begin
      response = @plivo.create_endpoint(params)
      return  {
                sip_endpoint_id: response[1]['endpoint_id'],
                sip_endpoint: "sip:#{response[1]['username']}@phone.plivo.com" ,
                password: password
              }
    rescue Exception => e
      Rails.logger.debug e
      raise
    end
  end

  def create_application(app_url, app_name)
    params = {
      'answer_url' => "#{app_url}/inbounding_calls/forward",
      'answer_method' => 'POST',
      'fallback_answer_url' => "#{app_url}/inbounding_calls/fallback",
      'fallback_method' => 'POST',
      'hangup_url' => "#{app_url}/inbounding_calls/hangup",
      'hangup_method' => 'POST',
      'app_name' => app_name,
      'default_endpoint_app' => true
    }
    response = @plivo.create_application(params)
    {
      app_id: response[1]['app_id'],
      api_id: response[1]['api_id']
    }
  end

  def find_responder call_uuid
    response = @plivo.get_cdrs(parent_call_uuid: call_uuid)

    if response[1]["objects"] != []
      responder_sip = response[1]["objects"][0]["to_number"]
    else
      nil
    end

  end

  def self.forward(params, app_id)
    app = App.find(app_id)
    response = Response.new

    dial_params = {
      callerId: params[:From],
      callerName: params[:CallerName],
      timeout: '15',
      action: "#{app.app_url}/inbounding_calls/voicemail.xml",
      method: 'POST'
    }
    response.addSpeak("You're at #{app.name}, we're looking for someone for you")
    dial = response.addDial(dial_params)
    app.user_numbers.each do |user_number|
      dial.addUser(user_number.sip_endpoint)
    end
    response.to_xml
  end

  def self.set_up_voicemail(app_id)
    app = App.find(app_id)
    response = Response.new

    response.addSpeak("Thanks for reaching us leave a message")

    record_params = {
      action: "#{app.app_url}/inbounding_calls/save_record.xml",
      method: 'POST',
      maxLength: '60',
      finishOnKey: '#',
      playBeep: 'true',
      redirect: 'true'
    }
    response.addRecord(record_params)
    response.addHangup()
    response.to_xml
  end

  def self.hangup
    response = Response.new
    response.addHangup()
    response.to_xml
  end

  def destroy_application *ids
    ids.each do |app_id|
      response = @plivo.delete_application({'app_id' => app_id})
      if response.status != 204
        Rails.logger.debug response["errors"]
        raise
      end
    end
  end

  def destroy_endpoints *ids
    ids.each do |endpoint_id|
      response = @plivo.delete_endpoint({'endpoint_id'=> endpoint_id})
      if response.status != 204
        Rails.logger.debug response["errors"]
        raise
      end
    end
  end
end
