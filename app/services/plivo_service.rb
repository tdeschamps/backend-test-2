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
                sip_endpoint: response[1]['sip_uri'],
                password: password
              }
    rescue Exception => e
      Rails.logger.debug e
      raise
    end
  end

  def create_application(app_url, app_name)
    params = {
      'answer_url' => "#{app_url}/inbounding_calls/forward.xml",
      'answer_method' => 'POST',
      'fallback_url' => "#{app_url}/inbounding_calls/fallback.xml",
      'fallback_method' => 'POST',
      'hangup_url' => "#{app_url}/nbounding_calls/hangup.xml",
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

  def self.forward(params, app_id)
    app = App.find(app_id)
    response = Response.new

    dial_params = {
      callerId: params[:From],
      callerName: params[:CallerName],
      timeout: '15'
    }
    dial = response.addDial(dial_parameters)
    app.user_numbers.each do |user_number|
      dial.addUser user_number.sip_endpoint
    end

    response.addSpeak("You're at #{app.name}, leave a message!")

    record_params = {
      action: "http://#{app.app_url}/inbounding_calls/voicemail.xml",
      method: 'POST',
      maxLength: '60',
      redirect: 'true'
    }

    response.addRecord(record_params)

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
